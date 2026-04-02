package org.example.aikefu_bot02.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import java.util.Date;
import lombok.Data;

/**
 * 知识文档
 * @TableName knowledge_document
 */
@TableName(value ="knowledge_document")
@Data
public class KnowledgeDocument {
    /**
     * 
     */
    @TableId(type = IdType.AUTO)
    private Long id;

    /**
     * 
     */
    private Long categoryId;

    /**
     * 
     */
    private String title;

    /**
     * faq/file/html
     */
    private String docType;

    /**
     * 正文或摘要
     */
    private String content;

    /**
     * 
     */
    private String fileUrl;

    /**
     * 0草稿 1已发布 2下线
     */
    private Integer status;

    /**
     * 
     */
    private Integer versionNo;

    /**
     * 
     */
    private Date publishedAt;

    /**
     * 管理员ID
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