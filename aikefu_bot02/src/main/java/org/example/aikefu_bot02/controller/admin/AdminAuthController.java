package org.example.aikefu_bot02.controller.admin;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.example.aikefu_bot02.common.result.Result;
import org.example.aikefu_bot02.dto.admin.AdminLoginRequest;
import org.example.aikefu_bot02.dto.admin.AdminLoginVO;
import org.example.aikefu_bot02.entity.AdminUser;
import org.example.aikefu_bot02.exception.BusinessException;
import org.example.aikefu_bot02.security.JwtUtil;
import org.example.aikefu_bot02.service.AdminUserService;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/admin/auth")
@Tag(name = "AdminAuth", description = "管理端登录")
public class AdminAuthController {

	private final AdminUserService adminUserService;
	private final PasswordEncoder passwordEncoder;
	private final JwtUtil jwtUtil;

	public AdminAuthController(AdminUserService adminUserService, PasswordEncoder passwordEncoder, JwtUtil jwtUtil) {
		this.adminUserService = adminUserService;
		this.passwordEncoder = passwordEncoder;
		this.jwtUtil = jwtUtil;
	}

	@PostMapping("/login")
	@Operation(summary = "管理员登录")
	public Result<AdminLoginVO> login(@RequestBody AdminLoginRequest req) {
		if (req.getUsername() == null || req.getUsername().isBlank()) {
			throw new BusinessException(40001, "请输入用户名");
		}
		if (req.getPassword() == null || req.getPassword().isEmpty()) {
			throw new BusinessException(40002, "请输入密码");
		}
		AdminUser u = adminUserService.lambdaQuery()
				.eq(AdminUser::getUsername, req.getUsername().trim())
				.one();
		if (u == null || (u.getStatus() != null && u.getStatus() != 0)) {
			throw new BusinessException(40101, "用户不存在或已禁用");
		}
		if (u.getPasswordHash() == null || !passwordEncoder.matches(req.getPassword(), u.getPasswordHash())) {
			throw new BusinessException(40102, "密码错误");
		}
		AdminLoginVO vo = new AdminLoginVO();
		vo.setToken(jwtUtil.generate(u.getId(), u.getUsername()));
		vo.setUsername(u.getUsername());
		vo.setRealName(u.getRealName());
		return Result.ok(vo);
	}
}
