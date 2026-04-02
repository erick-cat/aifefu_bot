package org.example.aikefu_bot02.service.impl;

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import org.example.aikefu_bot02.entity.ChatMessage;
import org.example.aikefu_bot02.service.ChatMessageService;
import org.example.aikefu_bot02.mapper.ChatMessageMapper;
import org.springframework.stereotype.Service;

/**
* @author 24229
* @description 针对表【chat_message(聊天消息)】的数据库操作Service实现
* @createDate 2026-04-01 13:50:55
*/
@Service
public class ChatMessageServiceImpl extends ServiceImpl<ChatMessageMapper, ChatMessage>
    implements ChatMessageService{

}




