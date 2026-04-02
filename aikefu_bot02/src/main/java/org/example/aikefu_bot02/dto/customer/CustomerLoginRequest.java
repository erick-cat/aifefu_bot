package org.example.aikefu_bot02.dto.customer;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.NotBlank;

@Schema(description = "C 端用户登录")
public class CustomerLoginRequest {

	@NotBlank(message = "请输入用户名")
	private String username;

	@NotBlank(message = "请输入密码")
	private String password;

	public String getUsername() {
		return username;
	}

	public void setUsername(String username) {
		this.username = username;
	}

	public String getPassword() {
		return password;
	}

	public void setPassword(String password) {
		this.password = password;
	}
}
