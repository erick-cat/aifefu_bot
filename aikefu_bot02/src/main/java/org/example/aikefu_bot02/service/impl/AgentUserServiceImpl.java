package org.example.aikefu_bot02.service.impl;

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import org.example.aikefu_bot02.entity.AgentUser;
import org.example.aikefu_bot02.service.AgentUserService;
import org.example.aikefu_bot02.mapper.AgentUserMapper;
import org.springframework.stereotype.Service;

/**
* @author 24229
* @description 针对表【agent_user(人工客服坐席)】的数据库操作Service实现
* @createDate 2026-04-01 13:50:54
*/
@Service
public class AgentUserServiceImpl extends ServiceImpl<AgentUserMapper, AgentUser>
    implements AgentUserService{

}




