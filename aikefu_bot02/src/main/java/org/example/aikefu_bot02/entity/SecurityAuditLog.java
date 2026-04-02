package org.example.aikefu_bot02.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import java.util.Date;
import lombok.Data;

/**
 * 安全审计日志
 * @TableName security_audit_log
 */
@TableName(value ="security_audit_log")
@Data
public class SecurityAuditLog {
    /**
     * 
     */
    @TableId(type = IdType.AUTO)
    private Long id;

    /**
     * customer/admin/agent
     */
    private String userType;

    /**
     * 
     */
    private Long userId;

    /**
     * login/logout/fail等
     */
    private String eventType;

    /**
     * 
     */
    private String ip;

    /**
     * 
     */
    private String userAgent;

    /**
     * 
     */
    private String result;

    /**
     * 
     */
    private Object detailJson;

    /**
     * 
     */
    private Date createdAt;
}