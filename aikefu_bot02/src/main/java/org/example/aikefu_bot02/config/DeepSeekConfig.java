package org.example.aikefu_bot02.config;

import com.fasterxml.jackson.databind.ObjectMapper;
import org.springframework.boot.context.properties.EnableConfigurationProperties;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.client.reactive.ReactorClientHttpConnector;
import org.springframework.web.reactive.function.client.WebClient;
import reactor.netty.http.client.HttpClient;

import java.time.Duration;

@Configuration
@EnableConfigurationProperties(DeepSeekProperties.class)
public class DeepSeekConfig {

	/**
	 * Spring Boot 4 使用 webmvc 时若未自动注册 Jackson，需显式提供 {@link ObjectMapper}，
	 * 供 {@link org.example.aikefu_bot02.llm.DeepSeekChatClient} 等组件注入。
	 */
	@Bean
	public ObjectMapper objectMapper() {
		return new ObjectMapper().findAndRegisterModules();
	}

	@Bean
	public WebClient deepSeekWebClient(DeepSeekProperties props) {
		HttpClient httpClient = HttpClient.create()
				.responseTimeout(Duration.ofSeconds(props.getTimeoutSeconds()));
		return WebClient.builder()
				.baseUrl(props.getBaseUrl())
				.clientConnector(new ReactorClientHttpConnector(httpClient))
				.build();
	}
}
