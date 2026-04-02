package org.example.aikefu_bot02.dto.chat;

import io.swagger.v3.oas.annotations.media.Schema;

@Schema(description = "智能客服回复")
public class ChatSendResponse {

	private Long sessionId;
	private String reply;
	private Long userMessageId;
	private Long assistantMessageId;

	public Long getSessionId() {
		return sessionId;
	}

	public void setSessionId(Long sessionId) {
		this.sessionId = sessionId;
	}

	public String getReply() {
		return reply;
	}

	public void setReply(String reply) {
		this.reply = reply;
	}

	public Long getUserMessageId() {
		return userMessageId;
	}

	public void setUserMessageId(Long userMessageId) {
		this.userMessageId = userMessageId;
	}

	public Long getAssistantMessageId() {
		return assistantMessageId;
	}

	public void setAssistantMessageId(Long assistantMessageId) {
		this.assistantMessageId = assistantMessageId;
	}
}
