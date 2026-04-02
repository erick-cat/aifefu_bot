package org.example.aikefu_bot02.dto.admin;

import io.swagger.v3.oas.annotations.media.Schema;

import java.io.Serializable;

@Schema(description = "管理员登录结果")
public class AdminLoginVO implements Serializable {

	@Schema(description = "JWT（开发环境后端未强校验，前端可存 localStorage）")
	private String token;
	private String username;
	private String realName;

	public String getToken() {
		return token;
	}

	public void setToken(String token) {
		this.token = token;
	}

	public String getUsername() {
		return username;
	}

	public void setUsername(String username) {
		this.username = username;
	}

	public String getRealName() {
		return realName;
	}

	public void setRealName(String realName) {
		this.realName = realName;
	}
}
