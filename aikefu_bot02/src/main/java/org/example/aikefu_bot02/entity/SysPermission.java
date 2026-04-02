package org.example.aikefu_bot02.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import java.util.Date;
import lombok.Data;

/**
 * 权限
 * @TableName sys_permission
 */
@TableName(value ="sys_permission")
@Data
public class SysPermission {
    /**
     * 
     */
    @TableId(type = IdType.AUTO)
    private Long id;

    /**
     * 权限标识
     */
    private String permCode;

    /**
     * 权限名称
     */
    private String permName;

    /**
     * 父级ID
     */
    private Long parentId;

    /**
     * 1菜单 2按钮 3接口
     */
    private Integer permType;

    /**
     * 
     */
    private Integer sortOrder;

    /**
     * 
     */
    private Date createdAt;
}