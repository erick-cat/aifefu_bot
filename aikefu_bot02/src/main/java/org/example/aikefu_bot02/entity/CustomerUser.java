package org.example.aikefu_bot02.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import java.util.Date;
import lombok.Data;

/**
 * C端用户
 * @TableName customer_user
 */
@TableName(value ="customer_user")
@Data
public class CustomerUser {
    /**
     * 主键
     */
    @TableId(type = IdType.AUTO)
    private Long id;

    /**
     * 登录名
     */
    private String username;

    /**
     * 手机号
     */
    private String phone;

    /**
     * 邮箱
     */
    private String email;

    /**
     * 密码哈希
     */
    private String passwordHash;

    /**
     * 昵称
     */
    private String nickname;

    /**
     * 头像URL
     */
    private String avatarUrl;

    /**
     * 0正常 1冻结 2注销
     */
    private Integer status;

    /**
     * 注册来源
     */
    private String registerSource;

    /**
     * 0未验证 1已验证
     */
    private Integer phoneVerified;

    /**
     * 最近登录时间
     */
    private Date lastLoginAt;

    /**
     * 
     */
    private Date createdAt;

    /**
     * 
     */
    private Date updatedAt;

    /**
     * 0否 1逻辑删除
     */
    private Integer deleted;
}