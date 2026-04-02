package org.example.aikefu_bot02.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import java.util.Date;
import lombok.Data;

/**
 * Prompt模板
 * @TableName prompt_template
 */
@TableName(value ="prompt_template")
@Data
public class PromptTemplate {
    /**
     * 
     */
    @TableId(type = IdType.AUTO)
    private Long id;

    /**
     * 场景编码
     */
    private String sceneCode;

    /**
     * 
     */
    private String name;

    /**
     * 
     */
    private String content;

    /**
     * 占位变量说明
     */
    private Object variablesJson;

    /**
     * 0启用 1停用
     */
    private Integer status;

    /**
     * 
     */
    private Integer currentVersion;

    /**
     * 
     */
    private Long createdBy;

    /**
     * 
     */
    private Date createdAt;

    /**
     * 
     */
    private Date updatedAt;
}