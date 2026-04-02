package org.example.aikefu_bot02.controller.admin;

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
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/admin/shop-products")
@Tag(name = "AdminShopProduct", description = "商品管理")
public class AdminShopProductController {

	private final ShopProductService shopProductService;

	public AdminShopProductController(ShopProductService shopProductService) {
		this.shopProductService = shopProductService;
	}

	@GetMapping("/page")
	@Operation(summary = "分页查询")
	public Result<PageResult<ShopProduct>> page(
			@RequestParam(defaultValue = "1") long current,
			@RequestParam(defaultValue = "10") long size,
			@RequestParam(required = false) String name,
			@RequestParam(required = false) Integer status) {
		long c = PageHelper.clampCurrent(current);
		long s = PageHelper.clampSize(size);
		LambdaQueryWrapper<ShopProduct> qw = new LambdaQueryWrapper<>();
		if (StringUtils.hasText(name)) {
			qw.like(ShopProduct::getName, name.trim());
		}
		if (status != null) {
			qw.eq(ShopProduct::getStatus, status);
		}
		qw.orderByDesc(ShopProduct::getId);
		long total = shopProductService.count(qw);
		qw.last(PageHelper.limitSql(c, s));
		return Result.ok(PageResult.of(shopProductService.list(qw), total, c, s));
	}

	@GetMapping("/{id}")
	public Result<ShopProduct> get(@PathVariable Long id) {
		ShopProduct e = shopProductService.getById(id);
		if (e == null) {
			throw new BusinessException(40404, "记录不存在");
		}
		return Result.ok(e);
	}

	@PostMapping
	public Result<ShopProduct> create(@RequestBody ShopProduct body) {
		shopProductService.save(body);
		return Result.ok(body);
	}

	@PutMapping("/{id}")
	public Result<ShopProduct> update(@PathVariable Long id, @RequestBody ShopProduct body) {
		body.setId(id);
		shopProductService.updateById(body);
		return Result.ok(body);
	}

	@DeleteMapping("/{id}")
	public Result<Void> delete(@PathVariable Long id) {
		shopProductService.removeById(id);
		return Result.ok(null);
	}
}
