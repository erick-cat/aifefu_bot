package org.example.aikefu_bot02.dto;

import java.io.Serializable;
import java.time.LocalDateTime;

/**
 * 对外展示的用户信息（不含密码等敏感字段）
 */
public class CustomerUserVO implements Serializable {

	private static final long serialVersionUID = 1L;

	private Long id;
	private String username;
	private String phone;
	private String email;
	private String nickname;
	private String avatarUrl;
	private Integer status;
	private String registerSource;
	private Integer phoneVerified;
	private LocalDateTime lastLoginAt;
	private LocalDateTime createdAt;

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public String getUsername() {
		return username;
	}

	public void setUsername(String username) {
		this.username = username;
	}

	public String getPhone() {
		return phone;
	}

	public void setPhone(String phone) {
		this.phone = phone;
	}

	public String getEmail() {
		return email;
	}

	public void setEmail(String email) {
		this.email = email;
	}

	public String getNickname() {
		return nickname;
	}

	public void setNickname(String nickname) {
		this.nickname = nickname;
	}

	public String getAvatarUrl() {
		return avatarUrl;
	}

	public void setAvatarUrl(String avatarUrl) {
		this.avatarUrl = avatarUrl;
	}

	public Integer getStatus() {
		return status;
	}

	public void setStatus(Integer status) {
		this.status = status;
	}

	public String getRegisterSource() {
		return registerSource;
	}

	public void setRegisterSource(String registerSource) {
		this.registerSource = registerSource;
	}

	public Integer getPhoneVerified() {
		return phoneVerified;
	}

	public void setPhoneVerified(Integer phoneVerified) {
		this.phoneVerified = phoneVerified;
	}

	public LocalDateTime getLastLoginAt() {
		return lastLoginAt;
	}

	public void setLastLoginAt(LocalDateTime lastLoginAt) {
		this.lastLoginAt = lastLoginAt;
	}

	public LocalDateTime getCreatedAt() {
		return createdAt;
	}

	public void setCreatedAt(LocalDateTime createdAt) {
		this.createdAt = createdAt;
	}
}
