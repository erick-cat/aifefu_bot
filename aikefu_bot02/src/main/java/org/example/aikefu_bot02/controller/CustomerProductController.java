package org.example.aikefu_bot02.controller;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.example.aikefu_bot02.common.result.PageResult;
import org.example.aikefu_bot02.common.result.Result;
import org.example.aikefu_bot02.common.util.PageHelper;
import org.example.aikefu_bot02.entity.ShopProduct;
import org.example.aikefu_bot02.exception.BusinessException;
import org.example.aikefu_bot02.service.ShopProductService;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

/**
 * C 端商品浏览（仅上架）
 */
@RestController
@RequestMapping("/api/v1/products")
@Tag(name = "CustomerProduct", description = "C端商品")
public class CustomerProductController {

	private static final int STATUS_ON = 0;

	private final ShopProductService shopProductService;

	public CustomerProductController(ShopProductService shopProductService) {
		this.shopProductService = shopProductService;
	}

	@GetMapping("/page")
	@Operation(summary = "分页查询上架商品")
	public Result<PageResult<ShopProduct>> page(
			@RequestParam(defaultValue = "1") long current,
			@RequestParam(defaultValue = "12") long size,
			@RequestParam(required = false) String type) {
		long c = PageHelper.clampCurrent(current);
		long s = PageHelper.clampSize(size);
		LambdaQueryWrapper<ShopProduct> qw = new LambdaQueryWrapper<>();
		qw.eq(ShopProduct::getStatus, STATUS_ON);
		if (StringUtils.hasText(type)) {
			qw.eq(ShopProduct::getType, type.trim());
		}
		qw.orderByDesc(ShopProduct::getId);
		long total = shopProductService.count(qw);
		qw.last(PageHelper.limitSql(c, s));
		return Result.ok(PageResult.of(shopProductService.list(qw), total, c, s));
	}

	@GetMapping("/{id}")
	@Operation(summary = "商品详情")
	public Result<ShopProduct> get(@PathVariable Long id) {
		ShopProduct p = shopProductService.getById(id);
		if (p == null || (p.getStatus() != null && p.getStatus() != STATUS_ON)) {
			throw new BusinessException(40404, "商品不存在或已下架");
		}
		return Result.ok(p);
	}
}
