package org.example.aikefu_bot02.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import java.util.Date;
import lombok.Data;

/**
 * 知识分类
 * @TableName knowledge_category
 */
@TableName(value ="knowledge_category")
@Data
public class KnowledgeCategory {
    /**
     * 
     */
    @TableId(type = IdType.AUTO)
    private Long id;

    /**
     * 父分类ID
     */
    private Long parentId;

    /**
     * 
     */
    private String name;

    /**
     * 
     */
    private Integer sortOrder;

    /**
     * 0启用 1停用
     */
    private Integer status;

    /**
     * 
     */
    private Date createdAt;
}