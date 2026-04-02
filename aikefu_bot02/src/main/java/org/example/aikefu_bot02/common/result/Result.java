package org.example.aikefu_bot02.common.result;

import io.swagger.v3.oas.annotations.media.Schema;

import java.io.Serializable;

/**
 * 统一 API 返回体（示例：后续可扩展 traceId、时间戳等）
 */
@Schema(description = "统一响应")
public class Result<T> implements Serializable {

	private static final long serialVersionUID = 1L;

	/** 业务码：0 表示成功 */
	@Schema(description = "业务码，0 成功")
	private int code;
	@Schema(description = "提示信息")
	private String message;
	@Schema(description = "业务数据")
	private T data;

	public Result() {
	}

	public Result(int code, String message, T data) {
		this.code = code;
		this.message = message;
		this.data = data;
	}

	public static <T> Result<T> ok(T data) {
		return new Result<>(0, "ok", data);
	}

	public static <T> Result<T> fail(int code, String message) {
		return new Result<>(code, message, null);
	}

	public int getCode() {
		return code;
	}

	public void setCode(int code) {
		this.code = code;
	}

	public String getMessage() {
		return message;
	}

	public void setMessage(String message) {
		this.message = message;
	}

	public T getData() {
		return data;
	}

	public void setData(T data) {
		this.data = data;
	}
}
