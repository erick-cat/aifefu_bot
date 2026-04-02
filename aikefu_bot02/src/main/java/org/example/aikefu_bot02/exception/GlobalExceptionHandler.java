package org.example.aikefu_bot02.exception;

import org.example.aikefu_bot02.common.result.Result;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.RestControllerAdvice;

/**
 * 全局异常 -> 统一返回（示例）
 * <p>仅作用于本业务包，避免拦截 SpringDoc 的 /v3/api-docs 等文档端点，
 * 否则文档接口异常时会被包装成 Result JSON。</p>
 */
@RestControllerAdvice(basePackages = "org.example.aikefu_bot02.controller")
public class GlobalExceptionHandler {

	@ExceptionHandler(BusinessException.class)
	@ResponseStatus(HttpStatus.OK)
	public Result<Void> handleBusiness(BusinessException ex) {
		return Result.fail(ex.getCode(), ex.getMessage());
	}

	@ExceptionHandler(MethodArgumentNotValidException.class)
	@ResponseStatus(HttpStatus.OK)
	public Result<Void> handleValid(MethodArgumentNotValidException ex) {
		String msg = ex.getBindingResult().getFieldErrors().stream()
				.findFirst()
				.map(f -> f.getDefaultMessage() != null ? f.getDefaultMessage() : "参数错误")
				.orElse("参数错误");
		return Result.fail(40001, msg);
	}

	@ExceptionHandler(Exception.class)
	@ResponseStatus(HttpStatus.INTERNAL_SERVER_ERROR)
	public Result<Void> handleOther(Exception ex) {
		return Result.fail(500, ex.getMessage() != null ? ex.getMessage() : "服务器内部错误");
	}
}
