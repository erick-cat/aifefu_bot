package org.example.aikefu_bot02.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import java.util.Date;
import lombok.Data;

/**
 * 管理员-角色
 * @TableName admin_user_role
 */
@TableName(value ="admin_user_role")
@Data
public class AdminUserRole {
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
    private Long roleId;

    /**
     * 
     */
    private Date createdAt;
}