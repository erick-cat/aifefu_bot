package org.example.aikefu_bot02.config;

import org.springframework.boot.context.properties.EnableConfigurationProperties;
import org.springframework.context.annotation.Configuration;

@Configuration
@EnableConfigurationProperties(CustomerServiceProperties.class)
public class CustomerServiceConfig {
}
