package org.example.aikefu_bot02.dto.customer;

import io.swagger.v3.oas.annotations.media.Schema;
import org.example.aikefu_bot02.dto.CustomerUserVO;

import java.io.Serializable;

@Schema(description = "C 端登录结果")
public class CustomerLoginVO implements Serializable {

	private static final long serialVersionUID = 1L;

	private String token;
	private CustomerUserVO user;

	public String getToken() {
		return token;
	}

	public void setToken(String token) {
		this.token = token;
	}

	public CustomerUserVO getUser() {
		return user;
	}

	public void setUser(CustomerUserVO user) {
		this.user = user;
	}
}
