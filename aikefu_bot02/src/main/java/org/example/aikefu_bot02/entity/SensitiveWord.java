package org.example.aikefu_bot02.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import java.util.Date;
import lombok.Data;

/**
 * 敏感词
 * @TableName sensitive_word
 */
@TableName(value ="sensitive_word")
@Data
public class SensitiveWord {
    /**
     * 
     */
    @TableId(type = IdType.AUTO)
    private Long id;

    /**
     * 
     */
    private String word;

    /**
     * 分类
     */
    private String category;

    /**
     * 1低 2中 3高
     */
    private Integer level;

    /**
     * block/replace/warn/transfer
     */
    private String action;

    /**
     * 
     */
    private String replaceTo;

    /**
     * 
     */
    private Integer status;

    /**
     * 
     */
    private Date createdAt;
}