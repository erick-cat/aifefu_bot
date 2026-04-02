package org.example.aikefu_bot02.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import java.util.Date;
import lombok.Data;

/**
 * 知识切片
 * @TableName knowledge_chunk
 */
@TableName(value ="knowledge_chunk")
@Data
public class KnowledgeChunk {
    /**
     * 
     */
    @TableId(type = IdType.AUTO)
    private Long id;

    /**
     * 
     */
    private Long documentId;

    /**
     * 切片序号
     */
    private Integer chunkIndex;

    /**
     * 
     */
    private String content;

    /**
     * 
     */
    private Integer tokenCount;

    /**
     * 
     */
    private Date createdAt;
}