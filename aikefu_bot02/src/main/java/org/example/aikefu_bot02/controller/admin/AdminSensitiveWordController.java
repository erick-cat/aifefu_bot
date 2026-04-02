package org.example.aikefu_bot02.controller.admin;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.example.aikefu_bot02.common.result.PageResult;
import org.example.aikefu_bot02.common.result.Result;
import org.example.aikefu_bot02.common.util.PageHelper;
import org.example.aikefu_bot02.entity.SensitiveWord;
import org.example.aikefu_bot02.exception.BusinessException;
import org.example.aikefu_bot02.service.SensitiveWordService;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/admin/sensitive-words")
@Tag(name = "AdminSensitiveWord", description = "敏感词")
public class AdminSensitiveWordController {

	private final SensitiveWordService sensitiveWordService;

	public AdminSensitiveWordController(SensitiveWordService sensitiveWordService) {
		this.sensitiveWordService = sensitiveWordService;
	}

	@GetMapping("/page")
	@Operation(summary = "分页查询")
	public Result<PageResult<SensitiveWord>> page(
			@RequestParam(defaultValue = "1") long current,
			@RequestParam(defaultValue = "10") long size,
			@RequestParam(required = false) String word) {
		long c = PageHelper.clampCurrent(current);
		long s = PageHelper.clampSize(size);
		LambdaQueryWrapper<SensitiveWord> qw = new LambdaQueryWrapper<>();
		if (StringUtils.hasText(word)) {
			qw.like(SensitiveWord::getWord, word.trim());
		}
		qw.orderByDesc(SensitiveWord::getId);
		long total = sensitiveWordService.count(qw);
		qw.last(PageHelper.limitSql(c, s));
		return Result.ok(PageResult.of(sensitiveWordService.list(qw), total, c, s));
	}

	@GetMapping("/{id}")
	public Result<SensitiveWord> get(@PathVariable Long id) {
		SensitiveWord e = sensitiveWordService.getById(id);
		if (e == null) {
			throw new BusinessException(40404, "记录不存在");
		}
		return Result.ok(e);
	}

	@PostMapping
	public Result<SensitiveWord> create(@RequestBody SensitiveWord body) {
		sensitiveWordService.save(body);
		return Result.ok(body);
	}

	@PutMapping("/{id}")
	public Result<SensitiveWord> update(@PathVariable Long id, @RequestBody SensitiveWord body) {
		body.setId(id);
		sensitiveWordService.updateById(body);
		return Result.ok(body);
	}

	@DeleteMapping("/{id}")
	public Result<Void> delete(@PathVariable Long id) {
		sensitiveWordService.removeById(id);
		return Result.ok(null);
	}
}
