package org.example.aikefu_bot02.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.math.BigDecimal;
import java.util.Date;

/**
 * 商城商品
 */
@TableName(value = "shop_product")
@Data
public class ShopProduct {

	@TableId(type = IdType.AUTO)
	private Long id;

	private String name;

	private String specs;

	private BigDecimal price;

	private Integer stock;

	private String imageUrl;

	/** 类型/类目 */
	private String type;

	/** 0 上架 1 下架 */
	private Integer status;

	private Date createdAt;

	private Date updatedAt;
}
