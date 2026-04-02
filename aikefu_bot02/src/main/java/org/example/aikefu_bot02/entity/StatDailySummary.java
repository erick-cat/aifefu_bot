package org.example.aikefu_bot02.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import java.math.BigDecimal;
import java.util.Date;
import lombok.Data;

/**
 * 日汇总统计
 * @TableName stat_daily_summary
 */
@TableName(value ="stat_daily_summary")
@Data
public class StatDailySummary {
    /**
     * 
     */
    @TableId(type = IdType.AUTO)
    private Long id;

    /**
     * 
     */
    private Date statDate;

    /**
     * 
     */
    private String channel;

    /**
     * 
     */
    private Integer sessionCount;

    /**
     * 
     */
    private Integer messageCount;

    /**
     * 
     */
    private Integer userMessageCount;

    /**
     * 
     */
    private Integer transferCount;

    /**
     * 
     */
    private Integer avgResponseMs;

    /**
     * 平均分
     */
    private BigDecimal satisfactionAvg;

    /**
     * 
     */
    private Date createdAt;
}