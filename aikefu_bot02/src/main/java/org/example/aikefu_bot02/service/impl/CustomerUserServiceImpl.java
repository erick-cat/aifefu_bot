package org.example.aikefu_bot02.service.impl;

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import org.example.aikefu_bot02.dto.CustomerUserVO;
import org.example.aikefu_bot02.dto.customer.CustomerLoginRequest;
import org.example.aikefu_bot02.dto.customer.CustomerLoginVO;
import org.example.aikefu_bot02.dto.customer.CustomerRegisterRequest;
import org.example.aikefu_bot02.entity.CustomerUser;
import org.example.aikefu_bot02.exception.BusinessException;
import org.example.aikefu_bot02.mapper.CustomerUserMapper;
import org.example.aikefu_bot02.security.JwtUtil;
import org.example.aikefu_bot02.service.CustomerUserService;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.StringUtils;

import java.time.LocalDateTime;
import java.time.ZoneId;
import java.util.Date;

/**
 * @author 24229
 * @description 针对表【customer_user(C端用户)】的数据库操作Service实现
 * @createDate 2026-04-01 13:50:55
 */
@Service
public class CustomerUserServiceImpl extends ServiceImpl<CustomerUserMapper, CustomerUser>
		implements CustomerUserService {

	private final PasswordEncoder passwordEncoder;
	private final JwtUtil jwtUtil;

	public CustomerUserServiceImpl(PasswordEncoder passwordEncoder, JwtUtil jwtUtil) {
		this.passwordEncoder = passwordEncoder;
		this.jwtUtil = jwtUtil;
	}

	@Override
	public CustomerUserVO getPublicById(Long id) {
		CustomerUser entity = getById(id);
		if (entity == null) {
			throw new BusinessException(40404, "用户不存在");
		}
		return toVo(entity);
	}

	@Override
	@Transactional(rollbackFor = Exception.class)
	public CustomerLoginVO register(CustomerRegisterRequest req) {
		String username = req.getUsername().trim();
		long exists = lambdaQuery().eq(CustomerUser::getUsername, username).count();
		if (exists > 0) {
			throw new BusinessException(40005, "用户名已被占用");
		}
		Date now = new Date();
		CustomerUser u = new CustomerUser();
		u.setUsername(username);
		u.setPasswordHash(passwordEncoder.encode(req.getPassword()));
		u.setNickname(StringUtils.hasText(req.getNickname()) ? req.getNickname().trim() : username);
		u.setEmail(StringUtils.hasText(req.getEmail()) ? req.getEmail().trim() : null);
		u.setPhone(StringUtils.hasText(req.getPhone()) ? req.getPhone().trim() : null);
		u.setStatus(0);
		u.setRegisterSource("portal");
		u.setPhoneVerified(0);
		u.setDeleted(0);
		u.setCreatedAt(now);
		u.setUpdatedAt(now);
		save(u);
		return buildLoginVo(u);
	}

	@Override
	@Transactional(rollbackFor = Exception.class)
	public CustomerLoginVO login(CustomerLoginRequest req) {
		String username = req.getUsername().trim();
		CustomerUser u = lambdaQuery().eq(CustomerUser::getUsername, username).one();
		if (u == null) {
			throw new BusinessException(40101, "用户名或密码错误");
		}
		if (u.getStatus() != null && u.getStatus() != 0) {
			throw new BusinessException(40102, "账号已冻结或已注销");
		}
		if (u.getPasswordHash() == null || !passwordEncoder.matches(req.getPassword(), u.getPasswordHash())) {
			throw new BusinessException(40101, "用户名或密码错误");
		}
		u.setLastLoginAt(new Date());
		u.setUpdatedAt(new Date());
		updateById(u);
		return buildLoginVo(u);
	}

	private CustomerLoginVO buildLoginVo(CustomerUser u) {
		CustomerLoginVO vo = new CustomerLoginVO();
		vo.setToken(jwtUtil.generateForCustomer(u.getId(), u.getUsername()));
		vo.setUser(toVo(u));
		return vo;
	}

	private static CustomerUserVO toVo(CustomerUser u) {
		CustomerUserVO vo = new CustomerUserVO();
		vo.setId(u.getId());
		vo.setUsername(u.getUsername());
		vo.setPhone(u.getPhone());
		vo.setEmail(u.getEmail());
		vo.setNickname(u.getNickname());
		vo.setAvatarUrl(u.getAvatarUrl());
		vo.setStatus(u.getStatus());
		vo.setRegisterSource(u.getRegisterSource());
		vo.setPhoneVerified(u.getPhoneVerified());
		vo.setLastLoginAt(toLocalDateTime(u.getLastLoginAt()));
		vo.setCreatedAt(toLocalDateTime(u.getCreatedAt()));
		return vo;
	}

	private static LocalDateTime toLocalDateTime(Date d) {
		if (d == null) {
			return null;
		}
		return d.toInstant().atZone(ZoneId.systemDefault()).toLocalDateTime();
	}
}

