package org.example.aikefu_bot02.dto.admin;

import io.swagger.v3.oas.annotations.media.Schema;

import java.io.Serializable;

@Schema(description = "管理员登录")
public class AdminLoginRequest implements Serializable {

	@Schema(description = "用户名")
	private String username;
	@Schema(description = "密码")
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
