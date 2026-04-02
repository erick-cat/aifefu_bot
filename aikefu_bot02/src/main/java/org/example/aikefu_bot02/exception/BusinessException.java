package org.example.aikefu_bot02.exception;

/**
 * 业务异常（示例）
 */
public class BusinessException extends RuntimeException {

	private final int code;

	public BusinessException(int code, String message) {
		super(message);
		this.code = code;
	}

	public int getCode() {
		return code;
	}
}
