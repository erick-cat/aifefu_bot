package org.example.aikefu_bot02.controller.admin;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.example.aikefu_bot02.common.result.PageResult;
import org.example.aikefu_bot02.common.result.Result;
import org.example.aikefu_bot02.common.util.PageHelper;
import org.example.aikefu_bot02.entity.CustomerUser;
import org.example.aikefu_bot02.exception.BusinessException;
import org.example.aikefu_bot02.service.CustomerUserService;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/admin/customer-users")
@Tag(name = "AdminCustomerUser", description = "C端用户管理")
public class AdminCustomerUserController {

	private final CustomerUserService customerUserService;

	public AdminCustomerUserController(CustomerUserService customerUserService) {
		this.customerUserService = customerUserService;
	}

	@GetMapping("/page")
	@Operation(summary = "分页查询")
	public Result<PageResult<CustomerUser>> page(
			@RequestParam(defaultValue = "1") long current,
			@RequestParam(defaultValue = "10") long size,
			@RequestParam(required = false) String username) {
		long c = PageHelper.clampCurrent(current);
		long s = PageHelper.clampSize(size);
		LambdaQueryWrapper<CustomerUser> qw = new LambdaQueryWrapper<>();
		if (StringUtils.hasText(username)) {
			qw.like(CustomerUser::getUsername, username.trim());
		}
		qw.orderByDesc(CustomerUser::getId);
		long total = customerUserService.count(qw);
		qw.last(PageHelper.limitSql(c, s));
		return Result.ok(PageResult.of(customerUserService.list(qw), total, c, s));
	}

	@GetMapping("/{id}")
	public Result<CustomerUser> get(@PathVariable Long id) {
		CustomerUser e = customerUserService.getById(id);
		if (e == null) {
			throw new BusinessException(40404, "记录不存在");
		}
		return Result.ok(e);
	}

	@PostMapping
	public Result<CustomerUser> create(@RequestBody CustomerUser body) {
		customerUserService.save(body);
		return Result.ok(body);
	}

	@PutMapping("/{id}")
	public Result<CustomerUser> update(@PathVariable Long id, @RequestBody CustomerUser body) {
		body.setId(id);
		customerUserService.updateById(body);
		return Result.ok(body);
	}

	@DeleteMapping("/{id}")
	public Result<Void> delete(@PathVariable Long id) {
		customerUserService.removeById(id);
		return Result.ok(null);
	}
}
