package org.example.aikefu_bot02.service.impl;

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import org.example.aikefu_bot02.entity.AdminUser;
import org.example.aikefu_bot02.service.AdminUserService;
import org.example.aikefu_bot02.mapper.AdminUserMapper;
import org.springframework.stereotype.Service;

/**
* @author 24229
* @description 针对表【admin_user(后台管理员)】的数据库操作Service实现
* @createDate 2026-04-01 13:50:54
*/
@Service
public class AdminUserServiceImpl extends ServiceImpl<AdminUserMapper, AdminUser>
    implements AdminUserService{

}




