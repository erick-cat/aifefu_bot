package org.example.aikefu_bot02.service;

import org.example.aikefu_bot02.config.CustomerServiceProperties;
import org.example.aikefu_bot02.config.DeepSeekProperties;
import org.example.aikefu_bot02.dto.chat.ChatSendRequest;
import org.example.aikefu_bot02.dto.chat.ChatSendResponse;
import org.example.aikefu_bot02.entity.ChatMessage;
import org.example.aikefu_bot02.entity.ChatSession;
import org.example.aikefu_bot02.entity.KnowledgeDocument;
import org.example.aikefu_bot02.entity.ShopProduct;
import org.example.aikefu_bot02.exception.BusinessException;
import org.example.aikefu_bot02.llm.DeepSeekChatClient;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.StringUtils;

import java.util.ArrayList;
import java.util.Collections;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class CustomerChatService {

	private static final int MAX_SYSTEM_PROMPT_CHARS = 14000;
	private static final int PRODUCT_STATUS_ON = 0;

	private final ChatSessionService chatSessionService;
	private final ChatMessageService chatMessageService;
	private final CustomerUserService customerUserService;
	private final ShopProductService shopProductService;
	private final KnowledgeContextService knowledgeContextService;
	private final CustomerServiceProperties customerServiceProperties;
	private final DeepSeekChatClient deepSeekChatClient;
	private final DeepSeekProperties deepSeekProperties;

	public CustomerChatService(
			ChatSessionService chatSessionService,
			ChatMessageService chatMessageService,
			CustomerUserService customerUserService,
			ShopProductService shopProductService,
			KnowledgeContextService knowledgeContextService,
			CustomerServiceProperties customerServiceProperties,
			DeepSeekChatClient deepSeekChatClient,
			DeepSeekProperties deepSeekProperties) {
		this.chatSessionService = chatSessionService;
		this.chatMessageService = chatMessageService;
		this.customerUserService = customerUserService;
		this.shopProductService = shopProductService;
		this.knowledgeContextService = knowledgeContextService;
		this.customerServiceProperties = customerServiceProperties;
		this.deepSeekChatClient = deepSeekChatClient;
		this.deepSeekProperties = deepSeekProperties;
	}

	@Transactional(rollbackFor = Exception.class)
	public ChatSendResponse send(ChatSendRequest req) {
		String text = req.getContent().trim();
		if (text.isEmpty()) {
			throw new BusinessException(40001, "消息内容不能为空");
		}

		ChatSession session = resolveSession(req);

		ChatMessage userMsg = new ChatMessage();
		userMsg.setSessionId(session.getId());
		userMsg.setRoleType("user");
		userMsg.setContent(text);
		chatMessageService.save(userMsg);

		List<ChatMessage> history = loadHistoryForLlm(session.getId());
		Long productId = session.getProductId();
		String systemPrompt = buildCustomerSystemPrompt(text, productId);
		List<Map<String, String>> messages = buildLlmMessages(history, systemPrompt);

		DeepSeekChatClient.CompletionResult completion = deepSeekChatClient.complete(messages);

		ChatMessage assistantMsg = new ChatMessage();
		assistantMsg.setSessionId(session.getId());
		assistantMsg.setRoleType("assistant");
		assistantMsg.setContent(completion.content());
		if (completion.totalTokens() > 0) {
			assistantMsg.setTokenUsage(completion.totalTokens());
		}
		chatMessageService.save(assistantMsg);

		Date now = new Date();
		session.setLastMessageAt(now);
		if (!StringUtils.hasText(session.getTitle())) {
			session.setTitle(trimTitle(text));
		}
		chatSessionService.updateById(session);

		ChatSendResponse vo = new ChatSendResponse();
		vo.setSessionId(session.getId());
		vo.setReply(completion.content());
		vo.setUserMessageId(userMsg.getId());
		vo.setAssistantMessageId(assistantMsg.getId());
		return vo;
	}

	private ChatSession resolveSession(ChatSendRequest req) {
		if (req.getSessionId() != null) {
			ChatSession s = chatSessionService.getById(req.getSessionId());
			if (s == null) {
				throw new BusinessException(40404, "会话不存在");
			}
			if (s.getStatus() != null && s.getStatus() != 0) {
				throw new BusinessException(40003, "会话已结束，请发起新会话");
			}
			if (req.getUserId() != null && s.getUserId() != null && !s.getUserId().equals(req.getUserId())) {
				throw new BusinessException(40301, "无权操作该会话");
			}
			if (req.getProductId() != null && s.getProductId() != null && !s.getProductId().equals(req.getProductId())) {
				throw new BusinessException(40007, "会话已绑定其他商品，请使用新对话");
			}
			return s;
		}
		if (req.getUserId() != null && customerUserService.getById(req.getUserId()) == null) {
			throw new BusinessException(40004, "用户不存在");
		}
		ChatSession s = new ChatSession();
		s.setChannel(StringUtils.hasText(req.getChannel()) ? req.getChannel().trim() : "web");
		s.setUserId(req.getUserId());
		s.setAnonymousToken(req.getAnonymousToken());
		s.setStatus(0);
		if (req.getProductId() != null) {
			ShopProduct p = shopProductService.getById(req.getProductId());
			if (p == null || (p.getStatus() != null && p.getStatus() != PRODUCT_STATUS_ON)) {
				throw new BusinessException(40006, "商品不存在或已下架");
			}
			s.setProductId(req.getProductId());
			s.setRobotMode("product");
			s.setTitle("咨询：" + p.getName());
		} else {
			s.setRobotMode("general");
			s.setTitle(trimTitle(req.getContent().trim()));
		}
		chatSessionService.save(s);
		return s;
	}

	private List<ChatMessage> loadHistoryForLlm(Long sessionId) {
		int limit = Math.max(4, deepSeekProperties.getMaxHistoryMessages());
		List<ChatMessage> chunk = chatMessageService.lambdaQuery()
				.eq(ChatMessage::getSessionId, sessionId)
				.orderByDesc(ChatMessage::getId)
				.last("LIMIT " + limit)
				.list();
		Collections.reverse(chunk);
		return chunk;
	}

	/**
	 * 商品会话：仅注入当前商品信息，不检索通用知识库，避免答非所问。
	 */
	private String buildCustomerSystemPrompt(String userMessage, Long productId) {
		if (productId != null) {
			ShopProduct product = shopProductService.getById(productId);
			if (product != null && (product.getStatus() == null || product.getStatus() == PRODUCT_STATUS_ON)) {
				return buildProductScopedPrompt(product);
			}
		}
		return buildGeneralPrompt(userMessage);
	}

	private String buildProductScopedPrompt(ShopProduct product) {
		CustomerServiceProperties p = customerServiceProperties;
		StringBuilder sb = new StringBuilder();
		sb.append("你是「").append(p.getBrandName()).append("」的官方智能客服。\n\n");
		sb.append("【会话范围（必须遵守）】\n");
		sb.append("当前会话仅针对下列单一商品。用户若询问其他商品、订单查询、物流单号、退换货进度、与当前商品无关的闲聊或通用百科，你必须明确拒绝，并回复：本窗口仅解答「")
				.append(product.getName())
				.append("」相关问题；其他问题请返回商品列表选择对应商品或联系人工客服。禁止编造未在下方信息中出现的参数。\n\n");
		sb.append("【当前商品信息（唯一事实来源）】\n");
		sb.append("名称：").append(product.getName()).append("\n");
		sb.append("规格：").append(StringUtils.hasText(product.getSpecs()) ? product.getSpecs() : "—").append("\n");
		sb.append("价格：").append(product.getPrice() != null ? product.getPrice().toPlainString() : "—").append(" 元\n");
		sb.append("库存：").append(product.getStock() != null ? product.getStock() : 0).append("\n");
		sb.append("类型：").append(StringUtils.hasText(product.getType()) ? product.getType() : "—").append("\n");
		sb.append("图片参考：").append(StringUtils.hasText(product.getImageUrl()) ? product.getImageUrl() : "—").append("\n\n");
		sb.append("【店铺级政策】仅在用户问题与退换/保修/发货时效相关时，可简要结合以下说明；否则不要展开。\n");
		sb.append(p.getBusinessProfile().trim()).append("\n\n");
		sb.append("【回复要求】\n").append(p.getReplyPolicy().trim()).append("\n\n");
		if (StringUtils.hasText(deepSeekProperties.getSystemPrompt())) {
			sb.append("【语气与格式补充】").append(deepSeekProperties.getSystemPrompt().trim());
		}
		return trimToMax(sb.toString());
	}

	private String buildGeneralPrompt(String userMessage) {
		CustomerServiceProperties p = customerServiceProperties;
		StringBuilder sb = new StringBuilder();
		sb.append("你是「").append(p.getBrandName()).append("」的官方智能客服。\n\n");
		sb.append("【业务与政策说明】\n").append(p.getBusinessProfile().trim()).append("\n\n");
		sb.append("【回复要求】\n").append(p.getReplyPolicy().trim()).append("\n\n");
		List<KnowledgeDocument> docs = knowledgeContextService.retrieveForUserMessage(userMessage);
		String kb = knowledgeContextService.formatKnowledgeBlock(docs);
		if (StringUtils.hasText(kb)) {
			sb.append("【知识库摘录（作为事实依据；向用户表述时自然转述，勿朗读内部标题编号）】\n");
			sb.append(kb).append("\n\n");
		} else {
			sb.append("【说明】当前未从知识库中匹配到与问题直接相关的条目。请严格依据上述「业务与政策说明」作答；若仍无法解答，请明确说明并建议用户提供订单号或转人工，勿编造商品细节。\n\n");
		}
		if (StringUtils.hasText(deepSeekProperties.getSystemPrompt())) {
			sb.append("【语气与格式补充】").append(deepSeekProperties.getSystemPrompt().trim());
		}
		return trimToMax(sb.toString());
	}

	private static String trimToMax(String all) {
		if (all.length() <= MAX_SYSTEM_PROMPT_CHARS) {
			return all;
		}
		return all.substring(0, MAX_SYSTEM_PROMPT_CHARS) + "\n…（系统提示过长已截断）";
	}

	private List<Map<String, String>> buildLlmMessages(List<ChatMessage> history, String systemContent) {
		List<Map<String, String>> out = new ArrayList<>();
		Map<String, String> sys = new HashMap<>();
		sys.put("role", "system");
		sys.put("content", systemContent);
		out.add(sys);
		for (ChatMessage m : history) {
			String role = m.getRoleType();
			if (!"user".equals(role) && !"assistant".equals(role) && !"system".equals(role)) {
				continue;
			}
			Map<String, String> one = new HashMap<>();
			one.put("role", role);
			one.put("content", m.getContent() != null ? m.getContent() : "");
			out.add(one);
		}
		return out;
	}

	private static String trimTitle(String s) {
		if (s.length() <= 48) {
			return s;
		}
		return s.substring(0, 48) + "…";
	}
}
