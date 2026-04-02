package org.example.aikefu_bot02.controller.admin;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.example.aikefu_bot02.common.result.PageResult;
import org.example.aikefu_bot02.common.result.Result;
import org.example.aikefu_bot02.common.util.PageHelper;
import org.example.aikefu_bot02.entity.StatDailySummary;
import org.example.aikefu_bot02.service.StatDailySummaryService;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/admin/stat-daily")
@Tag(name = "AdminStat", description = "日统计")
public class AdminStatDailySummaryController {

	private final StatDailySummaryService statDailySummaryService;

	public AdminStatDailySummaryController(StatDailySummaryService statDailySummaryService) {
		this.statDailySummaryService = statDailySummaryService;
	}

	@GetMapping("/page")
	@Operation(summary = "分页查询")
	public Result<PageResult<StatDailySummary>> page(
			@RequestParam(defaultValue = "1") long current,
			@RequestParam(defaultValue = "10") long size,
			@RequestParam(required = false) String channel) {
		long c = PageHelper.clampCurrent(current);
		long s = PageHelper.clampSize(size);
		LambdaQueryWrapper<StatDailySummary> qw = new LambdaQueryWrapper<>();
		if (StringUtils.hasText(channel)) {
			qw.eq(StatDailySummary::getChannel, channel.trim());
		}
		qw.orderByDesc(StatDailySummary::getStatDate);
		long total = statDailySummaryService.count(qw);
		qw.last(PageHelper.limitSql(c, s));
		return Result.ok(PageResult.of(statDailySummaryService.list(qw), total, c, s));
	}
}
