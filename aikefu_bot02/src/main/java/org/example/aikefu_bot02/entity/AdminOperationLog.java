package org.example.aikefu_bot02.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import java.util.Date;
import lombok.Data;

/**
 * 管理端操作日志
 * @TableName admin_operation_log
 */
@TableName(value ="admin_operation_log")
@Data
public class AdminOperationLog {
    /**
     * 
     */
    @TableId(type = IdType.AUTO)
    private Long id;

    /**
     * 
     */
    private Long adminId;

    /**
     * 
     */
    private String module;

    /**
     * 
     */
    private String action;

    /**
     * 
     */
    private String resourceType;

    /**
     * 
     */
    private String resourceId;

    /**
     * 
     */
    private String ip;

    /**
     * 
     */
    private Object beforeJson;

    /**
     * 
     */
    private Object afterJson;

    /**
     * 
     */
    private Date createdAt;
}