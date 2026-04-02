package org.example.aikefu_bot02.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import java.util.Date;
import lombok.Data;

/**
 * 聊天消息
 * @TableName chat_message
 */
@TableName(value ="chat_message")
@Data
public class ChatMessage {
    /**
     * 
     */
    @TableId(type = IdType.AUTO)
    private Long id;

    /**
     * 
     */
    private Long sessionId;

    /**
     * user/assistant/system/agent
     */
    private String roleType;

    /**
     * 
     */
    private String content;

    /**
     * 引用来源、工具调用等
     */
    private Object metadataJson;

    /**
     * 
     */
    private Integer tokenUsage;

    /**
     * 
     */
    private Date createdAt;
}