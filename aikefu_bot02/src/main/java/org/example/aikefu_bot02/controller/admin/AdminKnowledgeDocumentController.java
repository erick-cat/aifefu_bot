package org.example.aikefu_bot02.controller.admin;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.example.aikefu_bot02.common.result.PageResult;
import org.example.aikefu_bot02.common.result.Result;
import org.example.aikefu_bot02.common.util.PageHelper;
import org.example.aikefu_bot02.entity.KnowledgeDocument;
import org.example.aikefu_bot02.exception.BusinessException;
import org.example.aikefu_bot02.service.KnowledgeDocumentService;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/admin/knowledge-documents")
@Tag(name = "AdminKnowledge", description = "知识库文档")
public class AdminKnowledgeDocumentController {

	private final KnowledgeDocumentService knowledgeDocumentService;

	public AdminKnowledgeDocumentController(KnowledgeDocumentService knowledgeDocumentService) {
		this.knowledgeDocumentService = knowledgeDocumentService;
	}

	@GetMapping("/page")
	@Operation(summary = "分页查询")
	public Result<PageResult<KnowledgeDocument>> page(
			@RequestParam(defaultValue = "1") long current,
			@RequestParam(defaultValue = "10") long size,
			@RequestParam(required = false) String title) {
		long c = PageHelper.clampCurrent(current);
		long s = PageHelper.clampSize(size);
		LambdaQueryWrapper<KnowledgeDocument> qw = new LambdaQueryWrapper<>();
		if (StringUtils.hasText(title)) {
			qw.like(KnowledgeDocument::getTitle, title.trim());
		}
		qw.orderByDesc(KnowledgeDocument::getId);
		long total = knowledgeDocumentService.count(qw);
		qw.last(PageHelper.limitSql(c, s));
		List<KnowledgeDocument> records = knowledgeDocumentService.list(qw);
		return Result.ok(PageResult.of(records, total, c, s));
	}

	@GetMapping("/{id}")
	@Operation(summary = "详情")
	public Result<KnowledgeDocument> get(@PathVariable Long id) {
		KnowledgeDocument e = knowledgeDocumentService.getById(id);
		if (e == null) {
			throw new BusinessException(40404, "记录不存在");
		}
		return Result.ok(e);
	}

	@PostMapping
	@Operation(summary = "新增")
	public Result<KnowledgeDocument> create(@RequestBody KnowledgeDocument body) {
		knowledgeDocumentService.save(body);
		return Result.ok(body);
	}

	@PutMapping("/{id}")
	@Operation(summary = "更新")
	public Result<KnowledgeDocument> update(@PathVariable Long id, @RequestBody KnowledgeDocument body) {
		body.setId(id);
		knowledgeDocumentService.updateById(body);
		return Result.ok(body);
	}

	@DeleteMapping("/{id}")
	@Operation(summary = "删除")
	public Result<Void> delete(@PathVariable Long id) {
		knowledgeDocumentService.removeById(id);
		return Result.ok(null);
	}
}
