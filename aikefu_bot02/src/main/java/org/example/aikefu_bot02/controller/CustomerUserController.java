package org.example.aikefu_bot02.controller;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.media.Content;
import io.swagger.v3.oas.annotations.media.Schema;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.example.aikefu_bot02.common.result.Result;
import org.example.aikefu_bot02.dto.CustomerUserVO;
import org.example.aikefu_bot02.service.CustomerUserService;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

/**
 * C 端用户接口（示例：单条 GET，用于联调与 MyBatisX 扩展）
 */
@RestController
@RequestMapping("/api/v1/customer-users")
@Tag(name = "CustomerUser", description = "C端用户示例")
public class CustomerUserController {

	private final CustomerUserService customerUserService;

	public CustomerUserController(CustomerUserService customerUserService) {
		this.customerUserService = customerUserService;
	}

	@GetMapping("/{id}")
	@Operation(summary = "按ID查询用户（示例）")
	@ApiResponse(
			responseCode = "200",
			description = "成功",
			content = @Content(
					mediaType = "application/json",
					schema = @Schema(implementation = CustomerUserVO.class)))
	public Result<CustomerUserVO> getById(@PathVariable("id") Long id) {
		return Result.ok(customerUserService.getPublicById(id));
	}
}
