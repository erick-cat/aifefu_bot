package org.example.aikefu_bot02.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import java.util.Date;
import lombok.Data;

/**
 * 用户评价
 * @TableName customer_feedback
 */
@TableName(value ="customer_feedback")
@Data
public class CustomerFeedback {
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
     * 
     */
    private Long userId;

    /**
     * 1-5星
     */
    private Integer rating;

    /**
     * 
     */
    private String comment;

    /**
     * 逗号分隔标签
     */
    private String tags;

    /**
     * 
     */
    private Date createdAt;
}