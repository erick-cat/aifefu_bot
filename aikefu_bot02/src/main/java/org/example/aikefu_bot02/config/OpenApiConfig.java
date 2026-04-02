package org.example.aikefu_bot02.config;

import io.swagger.v3.oas.models.OpenAPI;
import io.swagger.v3.oas.models.info.Info;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

/**
 * OpenAPI 文档元信息（Swagger UI 标题等）
 */
@Configuration
public class OpenApiConfig {

	@Bean
	public OpenAPI openAPI() {
		return new OpenAPI().info(new Info()
				.title("智能客服 API")
				.version("0.0.1")
				.description("示例接口与 MyBatisX 生成入口"));
	}
}
