package org.example.aikefu_bot02.controller.admin;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.example.aikefu_bot02.common.result.PageResult;
import org.example.aikefu_bot02.common.result.Result;
import org.example.aikefu_bot02.common.util.PageHelper;
import org.example.aikefu_bot02.entity.PromptTemplate;
import org.example.aikefu_bot02.exception.BusinessException;
import org.example.aikefu_bot02.service.PromptTemplateService;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/admin/prompt-templates")
@Tag(name = "AdminPrompt", description = "Prompt 模板")
public class AdminPromptTemplateController {

	private final PromptTemplateService promptTemplateService;

	public AdminPromptTemplateController(PromptTemplateService promptTemplateService) {
		this.promptTemplateService = promptTemplateService;
	}

	@GetMapping("/page")
	@Operation(summary = "分页查询")
	public Result<PageResult<PromptTemplate>> page(
			@RequestParam(defaultValue = "1") long current,
			@RequestParam(defaultValue = "10") long size,
			@RequestParam(required = false) String sceneCode) {
		long c = PageHelper.clampCurrent(current);
		long s = PageHelper.clampSize(size);
		LambdaQueryWrapper<PromptTemplate> qw = new LambdaQueryWrapper<>();
		if (StringUtils.hasText(sceneCode)) {
			qw.eq(PromptTemplate::getSceneCode, sceneCode.trim());
		}
		qw.orderByDesc(PromptTemplate::getId);
		long total = promptTemplateService.count(qw);
		qw.last(PageHelper.limitSql(c, s));
		return Result.ok(PageResult.of(promptTemplateService.list(qw), total, c, s));
	}

	@GetMapping("/{id}")
	public Result<PromptTemplate> get(@PathVariable Long id) {
		PromptTemplate e = promptTemplateService.getById(id);
		if (e == null) {
			throw new BusinessException(40404, "记录不存在");
		}
		return Result.ok(e);
	}

	@PostMapping
	public Result<PromptTemplate> create(@RequestBody PromptTemplate body) {
		promptTemplateService.save(body);
		return Result.ok(body);
	}

	@PutMapping("/{id}")
	public Result<PromptTemplate> update(@PathVariable Long id, @RequestBody PromptTemplate body) {
		body.setId(id);
		promptTemplateService.updateById(body);
		return Result.ok(body);
	}

	@DeleteMapping("/{id}")
	public Result<Void> delete(@PathVariable Long id) {
		promptTemplateService.removeById(id);
		return Result.ok(null);
	}
}
