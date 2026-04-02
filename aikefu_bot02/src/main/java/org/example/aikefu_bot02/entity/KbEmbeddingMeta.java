package org.example.aikefu_bot02.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import java.util.Date;
import lombok.Data;

/**
 * 切片向量元数据
 * @TableName kb_embedding_meta
 */
@TableName(value ="kb_embedding_meta")
@Data
public class KbEmbeddingMeta {
    /**
     * 
     */
    @TableId(type = IdType.AUTO)
    private Long id;

    /**
     * 
     */
    private Long chunkId;

    /**
     * Embedding模型名
     */
    private String modelName;

    /**
     * 
     */
    private Integer embeddingDim;

    /**
     * 向量JSON(演示为短向量)
     */
    private Object vectorJson;

    /**
     * 
     */
    private Date createdAt;
}