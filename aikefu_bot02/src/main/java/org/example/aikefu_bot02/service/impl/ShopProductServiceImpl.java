package org.example.aikefu_bot02.service.impl;

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import org.example.aikefu_bot02.entity.ShopProduct;
import org.example.aikefu_bot02.mapper.ShopProductMapper;
import org.example.aikefu_bot02.service.ShopProductService;
import org.springframework.stereotype.Service;

@Service
public class ShopProductServiceImpl extends ServiceImpl<ShopProductMapper, ShopProduct> implements ShopProductService {
}
