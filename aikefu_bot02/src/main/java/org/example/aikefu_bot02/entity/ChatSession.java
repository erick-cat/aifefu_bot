package org.example.aikefu_bot02.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import java.util.Date;
import lombok.Data;

/**
 * 聊天会话
 * @TableName chat_session
 */
@TableName(value ="chat_session")
@Data
public class ChatSession {
    /**
     * 
     */
    @TableId(type = IdType.AUTO)
    private Long id;

    /**
     * C端用户，匿名为空
     */
    private Long userId;

    /**
     * 咨询关联商品（从商品页进入时非空）
     */
    private Long productId;

    /**
     * 匿名访客标识
     */
    private String anonymousToken;

    /**
     * web/h5/mini
     */
    private String channel;

    /**
     * 0进行中 1已结束 2转人工中 3已关闭
     */
    private Integer status;

    /**
     * 会话标题/首句摘要
     */
    private String title;

    /**
     * rag/general
     */
    private String robotMode;

    /**
     * 
     */
    private Date startedAt;

    /**
     * 
     */
    private Date endedAt;

    /**
     * 
     */
    private Date lastMessageAt;
}