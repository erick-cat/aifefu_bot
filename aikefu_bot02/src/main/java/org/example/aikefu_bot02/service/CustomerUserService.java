package org.example.aikefu_bot02.service;

import com.baomidou.mybatisplus.extension.service.IService;
import org.example.aikefu_bot02.dto.CustomerUserVO;
import org.example.aikefu_bot02.dto.customer.CustomerLoginRequest;
import org.example.aikefu_bot02.dto.customer.CustomerLoginVO;
import org.example.aikefu_bot02.dto.customer.CustomerRegisterRequest;
import org.example.aikefu_bot02.entity.CustomerUser;

/**
 * @author 24229
 * @description 针对表【customer_user(C端用户)】的数据库操作Service
 * @createDate 2026-04-01 13:50:55
 */
public interface CustomerUserService extends IService<CustomerUser> {

	/**
	 * 按主键查询可对外展示的用户信息（示例接口）
	 */
	CustomerUserVO getPublicById(Long id);

	CustomerLoginVO register(CustomerRegisterRequest req);

	CustomerLoginVO login(CustomerLoginRequest req);
}
