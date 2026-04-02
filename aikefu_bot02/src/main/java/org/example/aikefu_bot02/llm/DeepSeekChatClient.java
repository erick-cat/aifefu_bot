package org.example.aikefu_bot02.llm;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.example.aikefu_bot02.config.DeepSeekProperties;
import org.example.aikefu_bot02.exception.BusinessException;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Component;
import org.springframework.web.reactive.function.client.WebClient;
import org.springframework.web.reactive.function.client.WebClientResponseException;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 调用 DeepSeek Chat Completions（与 OpenAI 兼容），文档：https://api-docs.deepseek.com/zh-cn/
 */
@Component
public class DeepSeekChatClient {

	private final WebClient deepSeekWebClient;
	private final DeepSeekProperties props;
	private final ObjectMapper objectMapper;

	public DeepSeekChatClient(WebClient deepSeekWebClient, DeepSeekProperties props, ObjectMapper objectMapper) {
		this.deepSeekWebClient = deepSeekWebClient;
		this.props = props;
		this.objectMapper = objectMapper;
	}

	public CompletionResult complete(List<Map<String, String>> messages) {
		if (props.getApiKey() == null || props.getApiKey().isBlank()) {
			throw new BusinessException(50001,
					"未配置 DeepSeek API Key：请设置环境变量 DEEPSEEK_API_KEY，或在 application-local.properties 中配置 app.deepseek.api-key（勿提交到 Git）");
		}
		Map<String, Object> body = new HashMap<>();
		body.put("model", props.getModel());
		body.put("messages", messages);
		body.put("stream", false);
		body.put("temperature", props.getTemperature());

		String raw;
		try {
			raw = deepSeekWebClient.post()
					.uri(props.getCompletionsPath())
					.header(HttpHeaders.AUTHORIZATION, "Bearer " + props.getApiKey().trim())
					.contentType(MediaType.APPLICATION_JSON)
					.bodyValue(body)
					.retrieve()
					.bodyToMono(String.class)
					.block(java.time.Duration.ofSeconds(props.getTimeoutSeconds()));
		} catch (WebClientResponseException ex) {
			String hint = ex.getResponseBodyAsString();
			throw new BusinessException(50002, "DeepSeek 请求失败: " + ex.getStatusCode() + " " + hint);
		} catch (Exception ex) {
			throw new BusinessException(50002, "DeepSeek 调用异常: " + ex.getMessage());
		}

		if (raw == null || raw.isBlank()) {
			throw new BusinessException(50002, "DeepSeek 返回空响应");
		}

		try {
			JsonNode root = objectMapper.readTree(raw);
			JsonNode err = root.path("error");
			if (!err.isMissingNode() && !err.isNull()) {
				String msg = err.path("message").asText(err.toString());
				throw new BusinessException(50002, "DeepSeek 错误: " + msg);
			}
			String content = root.path("choices").path(0).path("message").path("content").asText(null);
			if (content == null || content.isEmpty()) {
				throw new BusinessException(50002, "DeepSeek 未返回有效内容");
			}
			int totalTokens = root.path("usage").path("total_tokens").asInt(0);
			return new CompletionResult(content, totalTokens);
		} catch (BusinessException ex) {
			throw ex;
		} catch (Exception ex) {
			throw new BusinessException(50002, "解析 DeepSeek 响应失败: " + ex.getMessage());
		}
	}

	public record CompletionResult(String content, int totalTokens) {
	}
}
