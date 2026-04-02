package org.example.aikefu_bot02.controller.admin;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.example.aikefu_bot02.common.result.PageResult;
import org.example.aikefu_bot02.common.result.Result;
import org.example.aikefu_bot02.common.util.PageHelper;
import org.example.aikefu_bot02.entity.LlmModelConfig;
import org.example.aikefu_bot02.exception.BusinessException;
import org.example.aikefu_bot02.service.LlmModelConfigService;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/admin/llm-model-configs")
@Tag(name = "AdminLlmModel", description = "大模型配置")
public class AdminLlmModelConfigController {

	private final LlmModelConfigService llmModelConfigService;

	public AdminLlmModelConfigController(LlmModelConfigService llmModelConfigService) {
		this.llmModelConfigService = llmModelConfigService;
	}

	@GetMapping("/page")
	@Operation(summary = "分页查询")
	public Result<PageResult<LlmModelConfig>> page(
			@RequestParam(defaultValue = "1") long current,
			@RequestParam(defaultValue = "10") long size,
			@RequestParam(required = false) String configName) {
		long c = PageHelper.clampCurrent(current);
		long s = PageHelper.clampSize(size);
		LambdaQueryWrapper<LlmModelConfig> qw = new LambdaQueryWrapper<>();
		if (StringUtils.hasText(configName)) {
			qw.like(LlmModelConfig::getConfigName, configName.trim());
		}
		qw.orderByDesc(LlmModelConfig::getId);
		long total = llmModelConfigService.count(qw);
		qw.last(PageHelper.limitSql(c, s));
		return Result.ok(PageResult.of(llmModelConfigService.list(qw), total, c, s));
	}

	@GetMapping("/{id}")
	public Result<LlmModelConfig> get(@PathVariable Long id) {
		LlmModelConfig e = llmModelConfigService.getById(id);
		if (e == null) {
			throw new BusinessException(40404, "记录不存在");
		}
		return Result.ok(e);
	}

	@PostMapping
	public Result<LlmModelConfig> create(@RequestBody LlmModelConfig body) {
		llmModelConfigService.save(body);
		return Result.ok(body);
	}

	@PutMapping("/{id}")
	public Result<LlmModelConfig> update(@PathVariable Long id, @RequestBody LlmModelConfig body) {
		body.setId(id);
		llmModelConfigService.updateById(body);
		return Result.ok(body);
	}

	@DeleteMapping("/{id}")
	public Result<Void> delete(@PathVariable Long id) {
		llmModelConfigService.removeById(id);
		return Result.ok(null);
	}
}
