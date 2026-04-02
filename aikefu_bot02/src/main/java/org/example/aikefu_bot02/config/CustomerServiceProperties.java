package org.example.aikefu_bot02.config;

import org.springframework.boot.context.properties.ConfigurationProperties;

/**
 * C 端智能客服业务配置：品牌、政策与回复策略（与 DeepSeek 模型解耦）。
 */
@ConfigurationProperties(prefix = "app.customer-service")
public class CustomerServiceProperties {

	/** 对外展示的品牌 / 店铺名 */
	private String brandName = "智服商城";

	/**
	 * 业务与商品说明（多行文本）：主营类目、服务范围、发货、退换、营业时间等。
	 * 会作为系统提示的一部分注入模型。
	 */
	private String businessProfile = "主营数码配件与智能家居周边，提供订单查询、售后与使用咨询服务。\n"
			+ "发货：现货订单一般 48 小时内发出；预售以商品详情页为准。\n"
			+ "退换：支持 7 天无理由（商品完好）；质量问题可联系客服处理。\n"
			+ "人工客服时间：工作日 9:00–18:00。";

	/**
	 * 回复约束：如何避免幻觉、何时转人工等。
	 */
	private String replyPolicy = "你必须以「官方客服」身份回答，语气专业、友好。\n"
			+ "回答须优先依据下方「知识库摘录」与「业务与政策说明」；若资料未提及或不确定，请明确说明「根据当前资料无法确认」，并引导用户提供订单号或转人工，不得编造价格、库存、活动规则与法律承诺。";

	/** 是否从数据库 knowledge_document（已发布）中检索相关内容 */
	private boolean knowledgeRetrievalEnabled = true;

	/** 每次对话最多引用几条知识文档 */
	private int knowledgeMaxDocs = 5;

	/** 每条知识正文注入模型的最大字符数（防止撑爆上下文） */
	private int knowledgeSnippetMaxChars = 1200;

	/**
	 * 当用户问题未匹配到任何知识条目时，是否补充「最近更新的」若干条知识作为背景（可能略泛化）。
	 */
	private boolean knowledgeFallbackLatest = false;

	private int knowledgeFallbackCount = 3;

	public String getBrandName() {
		return brandName;
	}

	public void setBrandName(String brandName) {
		this.brandName = brandName;
	}

	public String getBusinessProfile() {
		return businessProfile;
	}

	public void setBusinessProfile(String businessProfile) {
		this.businessProfile = businessProfile;
	}

	public String getReplyPolicy() {
		return replyPolicy;
	}

	public void setReplyPolicy(String replyPolicy) {
		this.replyPolicy = replyPolicy;
	}

	public boolean isKnowledgeRetrievalEnabled() {
		return knowledgeRetrievalEnabled;
	}

	public void setKnowledgeRetrievalEnabled(boolean knowledgeRetrievalEnabled) {
		this.knowledgeRetrievalEnabled = knowledgeRetrievalEnabled;
	}

	public int getKnowledgeMaxDocs() {
		return knowledgeMaxDocs;
	}

	public void setKnowledgeMaxDocs(int knowledgeMaxDocs) {
		this.knowledgeMaxDocs = knowledgeMaxDocs;
	}

	public int getKnowledgeSnippetMaxChars() {
		return knowledgeSnippetMaxChars;
	}

	public void setKnowledgeSnippetMaxChars(int knowledgeSnippetMaxChars) {
		this.knowledgeSnippetMaxChars = knowledgeSnippetMaxChars;
	}

	public boolean isKnowledgeFallbackLatest() {
		return knowledgeFallbackLatest;
	}

	public void setKnowledgeFallbackLatest(boolean knowledgeFallbackLatest) {
		this.knowledgeFallbackLatest = knowledgeFallbackLatest;
	}

	public int getKnowledgeFallbackCount() {
		return knowledgeFallbackCount;
	}

	public void setKnowledgeFallbackCount(int knowledgeFallbackCount) {
		this.knowledgeFallbackCount = knowledgeFallbackCount;
	}
}
