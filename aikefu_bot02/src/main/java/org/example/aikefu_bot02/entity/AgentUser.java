package org.example.aikefu_bot02.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import java.util.Date;
import lombok.Data;

/**
 * 人工客服坐席
 * @TableName agent_user
 */
@TableName(value ="agent_user")
@Data
public class AgentUser {
    /**
     * 
     */
    @TableId(type = IdType.AUTO)
    private Long id;

    /**
     * 工号
     */
    private String workNo;

    /**
     * 显示名
     */
    private String displayName;

    /**
     * 关联管理员ID
     */
    private Long bindAdminId;

    /**
     * 技能组
     */
    private String skillGroup;

    /**
     * 0在职 1停用
     */
    private Integer status;

    /**
     * 0离线 1在线 2忙碌
     */
    private Integer onlineStatus;

    /**
     * 最大并发会话数
     */
    private Integer maxConcurrent;

    /**
     * 
     */
    private Date createdAt;
}