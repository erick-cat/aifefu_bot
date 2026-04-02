package org.example.aikefu_bot02.controller;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import org.example.aikefu_bot02.common.result.Result;
import org.example.aikefu_bot02.dto.chat.ChatSendRequest;
import org.example.aikefu_bot02.dto.chat.ChatSendResponse;
import org.example.aikefu_bot02.security.JwtUtil;
import org.example.aikefu_bot02.service.CustomerChatService;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

/**
 * C 端智能客服对话（DeepSeek）
 */
@RestController
@RequestMapping("/api/v1/chat")
@Tag(name = "CustomerChat", description = "C端智能客服对话")
public class CustomerChatController {

	private final CustomerChatService customerChatService;
	private final JwtUtil jwtUtil;

	public CustomerChatController(CustomerChatService customerChatService, JwtUtil jwtUtil) {
		this.customerChatService = customerChatService;
		this.jwtUtil = jwtUtil;
	}

	@PostMapping("/messages")
	@Operation(summary = "发送消息并获取 AI 回复（DeepSeek）；携带 C 端登录 Token 时自动绑定用户")
	public Result<ChatSendResponse> send(
			@Valid @RequestBody ChatSendRequest req,
			@RequestHeader(value = "Authorization", required = false) String authorization) {
		Long uid = jwtUtil.parseCustomerIdFromBearer(authorization);
		if (uid != null) {
			req.setUserId(uid);
		}
		return Result.ok(customerChatService.send(req));
	}
}
