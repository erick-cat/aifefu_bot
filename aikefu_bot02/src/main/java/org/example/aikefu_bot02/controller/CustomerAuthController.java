package org.example.aikefu_bot02.controller;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import org.example.aikefu_bot02.common.result.Result;
import org.example.aikefu_bot02.dto.CustomerUserVO;
import org.example.aikefu_bot02.dto.customer.CustomerLoginRequest;
import org.example.aikefu_bot02.dto.customer.CustomerLoginVO;
import org.example.aikefu_bot02.dto.customer.CustomerRegisterRequest;
import org.example.aikefu_bot02.exception.BusinessException;
import org.example.aikefu_bot02.security.JwtUtil;
import org.example.aikefu_bot02.service.CustomerUserService;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

/**
 * C 端注册 / 登录 / 当前用户
 */
@RestController
@RequestMapping("/api/v1/customer/auth")
@Tag(name = "CustomerAuth", description = "C端认证")
public class CustomerAuthController {

	private final CustomerUserService customerUserService;
	private final JwtUtil jwtUtil;

	public CustomerAuthController(CustomerUserService customerUserService, JwtUtil jwtUtil) {
		this.customerUserService = customerUserService;
		this.jwtUtil = jwtUtil;
	}

	@PostMapping("/register")
	@Operation(summary = "注册")
	public Result<CustomerLoginVO> register(@Valid @RequestBody CustomerRegisterRequest req) {
		return Result.ok(customerUserService.register(req));
	}

	@PostMapping("/login")
	@Operation(summary = "登录")
	public Result<CustomerLoginVO> login(@Valid @RequestBody CustomerLoginRequest req) {
		return Result.ok(customerUserService.login(req));
	}

	@GetMapping("/me")
	@Operation(summary = "当前登录用户（需 Bearer Token）")
	public Result<CustomerUserVO> me(@RequestHeader(value = "Authorization", required = false) String authorization) {
		Long id = jwtUtil.parseCustomerIdFromBearer(authorization);
		if (id == null) {
			throw new BusinessException(40103, "未登录或登录已失效");
		}
		return Result.ok(customerUserService.getPublicById(id));
	}
}
