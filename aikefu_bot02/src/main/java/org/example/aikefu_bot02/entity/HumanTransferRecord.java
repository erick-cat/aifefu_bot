package org.example.aikefu_bot02.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import java.util.Date;
import lombok.Data;

/**
 * 转人工记录
 * @TableName human_transfer_record
 */
@TableName(value ="human_transfer_record")
@Data
public class HumanTransferRecord {
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
    private Long agentId;

    /**
     * 
     */
    private Integer queuePosition;

    /**
     * queued/picked/closed/cancel
     */
    private String status;

    /**
     * 
     */
    private String reason;

    /**
     * 
     */
    private Date createdAt;

    /**
     * 
     */
    private Date pickedAt;

    /**
     * 
     */
    private Date closedAt;
}