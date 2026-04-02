package org.example.aikefu_bot02.service;

import org.example.aikefu_bot02.config.CustomerServiceProperties;
import org.example.aikefu_bot02.entity.KnowledgeDocument;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;

import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

/**
 * 从已发布知识库中为用户当前问题拼装可供 LLM 使用的文本片段（轻量检索，非向量检索）。
 */
@Service
public class KnowledgeContextService {

	private final KnowledgeDocumentService knowledgeDocumentService;
	private final CustomerServiceProperties customerServiceProperties;

	public KnowledgeContextService(
			KnowledgeDocumentService knowledgeDocumentService,
			CustomerServiceProperties customerServiceProperties) {
		this.knowledgeDocumentService = knowledgeDocumentService;
		this.customerServiceProperties = customerServiceProperties;
	}

	/**
	 * 检索与用户输入相关的已发布文档；若无命中且开启 fallback，则取最近更新的一批。
	 */
	public List<KnowledgeDocument> retrieveForUserMessage(String userMessage) {
		if (!customerServiceProperties.isKnowledgeRetrievalEnabled()) {
			return List.of();
		}
		int max = Math.max(1, customerServiceProperties.getKnowledgeMaxDocs());
		List<KnowledgeDocument> matched = knowledgeDocumentService.searchPublishedMatchingUserText(userMessage, max);
		if (!matched.isEmpty()) {
			return matched;
		}
		if (customerServiceProperties.isKnowledgeFallbackLatest()) {
			int fb = Math.max(1, customerServiceProperties.getKnowledgeFallbackCount());
			return knowledgeDocumentService.listLatestPublished(fb);
		}
		return List.of();
	}

	public String formatKnowledgeBlock(List<KnowledgeDocument> docs) {
		if (docs == null || docs.isEmpty()) {
			return "";
		}
		int cap = Math.max(200, customerServiceProperties.getKnowledgeSnippetMaxChars());
		List<String> parts = new ArrayList<>();
		for (KnowledgeDocument d : docs) {
			String title = StringUtils.hasText(d.getTitle()) ? d.getTitle() : "（无标题）";
			String body = d.getContent() != null ? d.getContent() : "";
			if (body.length() > cap) {
				body = body.substring(0, cap) + "…";
			}
			parts.add("【" + title + "】\n" + body.trim());
		}
		return parts.stream().collect(Collectors.joining("\n\n---\n\n"));
	}
}
