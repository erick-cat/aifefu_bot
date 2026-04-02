package org.example.aikefu_bot02.dto.chat;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.NotBlank;

@Schema(description = "C 端发送聊天消息")
public class ChatSendRequest {

	@Schema(description = "用户输入", requiredMode = Schema.RequiredMode.REQUIRED)
	@NotBlank(message = "消息内容不能为空")
	private String content;

	@Schema(description = "已有会话 ID，不传则新建会话")
	private Long sessionId;

	@Schema(description = "渠道：web/h5/mini", example = "web")
	private String channel = "web";

	@Schema(description = "已登录 C 端用户 ID（匿名不传）")
	private Long userId;

	@Schema(description = "匿名访客标识")
	private String anonymousToken;

	@Schema(description = "从商品页进入咨询时传入商品 ID，与 sessionId 二选一续聊时以会话已绑定商品为准")
	private Long productId;

	public String getContent() {
		return content;
	}

	public void setContent(String content) {
		this.content = content;
	}

	public Long getSessionId() {
		return sessionId;
	}

	public void setSessionId(Long sessionId) {
		this.sessionId = sessionId;
	}

	public String getChannel() {
		return channel;
	}

	public void setChannel(String channel) {
		this.channel = channel;
	}

	public Long getUserId() {
		return userId;
	}

	public void setUserId(Long userId) {
		this.userId = userId;
	}

	public String getAnonymousToken() {
		return anonymousToken;
	}

	public void setAnonymousToken(String anonymousToken) {
		this.anonymousToken = anonymousToken;
	}

	public Long getProductId() {
		return productId;
	}

	public void setProductId(Long productId) {
		this.productId = productId;
	}
}
