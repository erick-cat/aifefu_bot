package org.example.aikefu_bot02.dto.customer;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Pattern;
import jakarta.validation.constraints.Size;

@Schema(description = "C 端用户注册")
public class CustomerRegisterRequest {

	@Schema(description = "登录名（字母数字下划线）", example = "zhang_san")
	@NotBlank(message = "请输入用户名")
	@Size(min = 3, max = 32, message = "用户名为 3～32 位")
	@Pattern(regexp = "^[a-zA-Z0-9_]+$", message = "用户名仅支持字母、数字、下划线")
	private String username;

	@Schema(description = "密码", example = "******")
	@NotBlank(message = "请输入密码")
	@Size(min = 6, max = 64, message = "密码为 6～64 位")
	private String password;

	@Schema(description = "昵称，默认同用户名")
	@Size(max = 64, message = "昵称过长")
	private String nickname;

	@Schema(description = "邮箱")
	@Size(max = 128)
	private String email;

	@Schema(description = "手机号")
	@Size(max = 20)
	private String phone;

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

	public String getNickname() {
		return nickname;
	}

	public void setNickname(String nickname) {
		this.nickname = nickname;
	}

	public String getEmail() {
		return email;
	}

	public void setEmail(String email) {
		this.email = email;
	}

	public String getPhone() {
		return phone;
	}

	public void setPhone(String phone) {
		this.phone = phone;
	}
}
