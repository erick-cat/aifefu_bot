package org.example.aikefu_bot02.controller.admin;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.example.aikefu_bot02.common.result.PageResult;
import org.example.aikefu_bot02.common.result.Result;
import org.example.aikefu_bot02.common.util.PageHelper;
import org.example.aikefu_bot02.entity.ChatSession;
import org.example.aikefu_bot02.exception.BusinessException;
import org.example.aikefu_bot02.service.ChatSessionService;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/admin/chat-sessions")
@Tag(name = "AdminChatSession", description = "会话监控")
public class AdminChatSessionController {

	private final ChatSessionService chatSessionService;

	public AdminChatSessionController(ChatSessionService chatSessionService) {
		this.chatSessionService = chatSessionService;
	}

	@GetMapping("/page")
	@Operation(summary = "分页查询会话")
	public Result<PageResult<ChatSession>> page(
			@RequestParam(defaultValue = "1") long current,
			@RequestParam(defaultValue = "10") long size,
			@RequestParam(required = false) Long userId,
			@RequestParam(required = false) String channel) {
		long c = PageHelper.clampCurrent(current);
		long s = PageHelper.clampSize(size);
		LambdaQueryWrapper<ChatSession> qw = new LambdaQueryWrapper<>();
		if (userId != null) {
			qw.eq(ChatSession::getUserId, userId);
		}
		if (channel != null && !channel.isBlank()) {
			qw.eq(ChatSession::getChannel, channel.trim());
		}
		qw.orderByDesc(ChatSession::getStartedAt);
		long total = chatSessionService.count(qw);
		qw.last(PageHelper.limitSql(c, s));
		return Result.ok(PageResult.of(chatSessionService.list(qw), total, c, s));
	}

	@GetMapping("/{id}")
	public Result<ChatSession> get(@PathVariable Long id) {
		ChatSession e = chatSessionService.getById(id);
		if (e == null) {
			throw new BusinessException(40404, "记录不存在");
		}
		return Result.ok(e);
	}
}
