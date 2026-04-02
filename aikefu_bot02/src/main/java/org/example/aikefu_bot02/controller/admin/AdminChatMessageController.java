package org.example.aikefu_bot02.controller.admin;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.example.aikefu_bot02.common.result.PageResult;
import org.example.aikefu_bot02.common.result.Result;
import org.example.aikefu_bot02.common.util.PageHelper;
import org.example.aikefu_bot02.entity.ChatMessage;
import org.example.aikefu_bot02.service.ChatMessageService;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/admin/chat-messages")
@Tag(name = "AdminChatMessage", description = "会话消息")
public class AdminChatMessageController {

	private final ChatMessageService chatMessageService;

	public AdminChatMessageController(ChatMessageService chatMessageService) {
		this.chatMessageService = chatMessageService;
	}

	@GetMapping("/page")
	@Operation(summary = "按会话分页查询消息")
	public Result<PageResult<ChatMessage>> page(
			@RequestParam Long sessionId,
			@RequestParam(defaultValue = "1") long current,
			@RequestParam(defaultValue = "20") long size) {
		long c = PageHelper.clampCurrent(current);
		long s = PageHelper.clampSize(size);
		LambdaQueryWrapper<ChatMessage> qw = new LambdaQueryWrapper<>();
		qw.eq(ChatMessage::getSessionId, sessionId);
		qw.orderByAsc(ChatMessage::getId);
		long total = chatMessageService.count(qw);
		qw.last(PageHelper.limitSql(c, s));
		return Result.ok(PageResult.of(chatMessageService.list(qw), total, c, s));
	}
}
