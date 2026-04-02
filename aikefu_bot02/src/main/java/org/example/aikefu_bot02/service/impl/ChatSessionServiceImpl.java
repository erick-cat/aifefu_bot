package org.example.aikefu_bot02.service.impl;

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import org.example.aikefu_bot02.entity.ChatSession;
import org.example.aikefu_bot02.service.ChatSessionService;
import org.example.aikefu_bot02.mapper.ChatSessionMapper;
import org.springframework.stereotype.Service;

/**
* @author 24229
* @description 针对表【chat_session(聊天会话)】的数据库操作Service实现
* @createDate 2026-04-01 13:50:55
*/
@Service
public class ChatSessionServiceImpl extends ServiceImpl<ChatSessionMapper, ChatSession>
    implements ChatSessionService{

}




