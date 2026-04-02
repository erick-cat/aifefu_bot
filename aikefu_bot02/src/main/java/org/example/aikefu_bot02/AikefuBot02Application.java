package org.example.aikefu_bot02;

import org.mybatis.spring.annotation.MapperScan;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.data.redis.autoconfigure.DataRedisAutoConfiguration;

@SpringBootApplication(exclude = { DataRedisAutoConfiguration.class })
@MapperScan("org.example.aikefu_bot02.mapper")
public class AikefuBot02Application {

	public static void main(String[] args) {
		SpringApplication.run(AikefuBot02Application.class, args);
	}

}
