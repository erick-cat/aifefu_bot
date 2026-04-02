package org.example.aikefu_bot02.config;

import org.springframework.boot.context.properties.ConfigurationProperties;

/**
 * DeepSeek OpenAI 兼容 API 配置，见 <a href="https://api-docs.deepseek.com/zh-cn/">官方文档</a>。
 * <p>密钥请使用环境变量 {@code DEEPSEEK_API_KEY}，或本机 {@code application-local.properties}（已加入 .gitignore）。</p>
 */
@ConfigurationProperties(prefix = "app.deepseek")
public class DeepSeekProperties {

	/**
	 * 与官方 curl 示例一致：{@code https://api.deepseek.com}
	 */
	private String baseUrl = "https://api.deepseek.com";

	/**
	 * 对话补全路径，默认 {@code /chat/completions}
	 */
	private String completionsPath = "/chat/completions";

	private String model = "deepseek-chat";

	/** 从环境变量注入，勿提交到 Git */
	private String apiKey = "";

	private String systemPrompt = "你是专业、友好的智能客服助手。回答简洁、准确；不确定时请说明并建议用户联系人工客服。";

	private double temperature = 0.7;

	/** 参与上下文的最近消息条数（含本轮用户消息） */
	private int maxHistoryMessages = 24;

	/** HTTP 调用超时（秒） */
	private int timeoutSeconds = 120;

	public String getBaseUrl() {
		return baseUrl;
	}

	public void setBaseUrl(String baseUrl) {
		this.baseUrl = baseUrl;
	}

	public String getCompletionsPath() {
		return completionsPath;
	}

	public void setCompletionsPath(String completionsPath) {
		this.completionsPath = completionsPath;
	}

	public String getModel() {
		return model;
	}

	public void setModel(String model) {
		this.model = model;
	}

	public String getApiKey() {
		return apiKey;
	}

	public void setApiKey(String apiKey) {
		this.apiKey = apiKey;
	}

	public String getSystemPrompt() {
		return systemPrompt;
	}

	public void setSystemPrompt(String systemPrompt) {
		this.systemPrompt = systemPrompt;
	}

	public double getTemperature() {
		return temperature;
	}

	public void setTemperature(double temperature) {
		this.temperature = temperature;
	}

	public int getMaxHistoryMessages() {
		return maxHistoryMessages;
	}

	public void setMaxHistoryMessages(int maxHistoryMessages) {
		this.maxHistoryMessages = maxHistoryMessages;
	}

	public int getTimeoutSeconds() {
		return timeoutSeconds;
	}

	public void setTimeoutSeconds(int timeoutSeconds) {
		this.timeoutSeconds = timeoutSeconds;
	}
}
