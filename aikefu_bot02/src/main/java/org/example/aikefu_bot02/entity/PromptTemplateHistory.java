package org.example.aikefu_bot02.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import java.util.Date;
import lombok.Data;

/**
 * Prompt版本历史
 * @TableName prompt_template_history
 */
@TableName(value ="prompt_template_history")
@Data
public class PromptTemplateHistory {
    /**
     * 
     */
    @TableId(type = IdType.AUTO)
    private Long id;

    /**
     * 
     */
    private Long templateId;

    /**
     * 
     */
    private Integer versionNo;

    /**
     * 
     */
    private String content;

    /**
     * 
     */
    private Long changedBy;

    /**
     * 
     */
    private Date changedAt;

    /**
     * 
     */
    private String remark;
}