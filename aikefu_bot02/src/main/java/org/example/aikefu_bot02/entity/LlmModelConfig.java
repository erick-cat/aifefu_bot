package org.example.aikefu_bot02.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import java.math.BigDecimal;
import java.util.Date;
import lombok.Data;

/**
 * LLM与Embedding配置
 * @TableName llm_model_config
 */
@TableName(value ="llm_model_config")
@Data
public class LlmModelConfig {
    /**
     * 
     */
    @TableId(type = IdType.AUTO)
    private Long id;

    /**
     * 配置名称
     */
    private String configName;

    /**
     * openai/azure/local等
     */
    private String provider;

    /**
     * 
     */
    private String modelName;

    /**
     * 密钥引用/脱敏ID，非明文
     */
    private String apiKeyRef;

    /**
     * 
     */
    private String embeddingModel;

    /**
     * 
     */
    private BigDecimal temperature;

    /**
     * 
     */
    private BigDecimal topP;

    /**
     * 
     */
    private Integer maxTokens;

    /**
     * 
     */
    private Integer timeoutMs;

    /**
     * 
     */
    private Integer isDefaultChat;

    /**
     * 
     */
    private Integer isDefaultEmbed;

    /**
     * 0启用 1停用
     */
    private Integer status;

    /**
     * 
     */
    private Date createdAt;

    /**
     * 
     */
    private Date updatedAt;
}