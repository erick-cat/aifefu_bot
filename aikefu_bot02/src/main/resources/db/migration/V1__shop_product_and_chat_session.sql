-- 商城商品表、会话关联商品、示例数据（占位图 URL 与商品简称对应）

CREATE TABLE IF NOT EXISTS shop_product (
  id            BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  name          VARCHAR(256)   NOT NULL COMMENT '商品名称',
  specs         VARCHAR(512)   DEFAULT NULL COMMENT '规格',
  price         DECIMAL(12, 2) NOT NULL COMMENT '价格',
  stock         INT            NOT NULL DEFAULT 0 COMMENT '库存量',
  image_url     VARCHAR(1024)  DEFAULT NULL COMMENT '图片URL',
  type          VARCHAR(64)    DEFAULT NULL COMMENT '类型',
  status        TINYINT        NOT NULL DEFAULT 0 COMMENT '0上架 1下架',
  created_at    DATETIME       NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at    DATETIME       NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  KEY idx_sp_type (type),
  KEY idx_sp_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='商城商品';

-- 若 chat_session 不存在（尚未执行全量初始化）则跳过；若列已存在则跳过，避免重复部署失败
SET @tab_exists = (
  SELECT COUNT(*) FROM INFORMATION_SCHEMA.TABLES
  WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'chat_session'
);
SET @col_exists = (
  SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS
  WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'chat_session' AND COLUMN_NAME = 'product_id'
);
SET @sql = IF(@tab_exists > 0 AND @col_exists = 0,
  'ALTER TABLE chat_session ADD COLUMN product_id BIGINT UNSIGNED DEFAULT NULL COMMENT ''咨询关联商品'' AFTER user_id, ADD KEY idx_cs_product (product_id)',
  'SELECT 1');
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

INSERT INTO shop_product (id, name, specs, price, stock, image_url, type, status) VALUES
(1, '无线蓝牙耳机 Pro', '蓝牙5.3 / 主动降噪 / 续航30h', 299.00, 420, 'https://placehold.co/400x400/0f172a/5eead4?text=%E8%80%B3%E6%9C%BA', '数码影音', 0),
(2, '智能手环 X1', '1.47英寸 AMOLED / 血氧心率', 199.00, 880, 'https://placehold.co/400x400/134e4a/6ee7b7?text=%E6%89%8B%E7%8E%AF', '穿戴设备', 0),
(3, '氮化镓快充头 65W', '双口 Type-C / 折叠插脚', 89.00, 1200, 'https://placehold.co/400x400/78350f/fcd34d?text=%E5%BF%AB%E5%85%85', '配件', 0),
(4, '机械键盘 K8', '87键 / 热插拔 / RGB', 459.00, 156, 'https://placehold.co/400x400/312e81/c4b5fd?text=%E9%94%AE%E7%9B%98', '外设', 0),
(5, '便携显示器 15.6"', '1080P / 60Hz / Type-C一线通', 899.00, 75, 'https://placehold.co/400x400/1e293b/94a3b8?text=%E6%98%BE%E7%A4%BA', '显示设备', 0),
(6, '智能台灯 L2', '无频闪 / 色温可调 / APP控制', 159.00, 340, 'https://placehold.co/400x400/422006/fde68a?text=%E5%8F%B0%E7%81%AF', '智能家居', 0),
(7, 'USB-C 扩展坞', 'HDMI+USB3.0+读卡器', 129.00, 600, 'https://placehold.co/400x400/164e63/a5f3fc?text=%E6%89%A9%E5%B1%95', '配件', 0),
(8, '运动水壶 750ml', '不锈钢 / 保温12h', 79.00, 500, 'https://placehold.co/400x400/14532d/86efac?text=%E6%B0%B4%E5%A3%B6', '生活', 0),
(9, '迷你投影仪 P1', '720P / 自动对焦 / 内置音箱', 1299.00, 42, 'https://placehold.co/400x400/831843/fbcfe8?text=%E6%8A%95%E5%BD%B1', '数码影音', 0),
(10, '人体工学鼠标', '无线2.4G+蓝牙双模 / 静音按键', 169.00, 230, 'https://placehold.co/400x400/1e1b4b/a5b4fc?text=%E9%BC%A0%E6%A0%87', '外设', 0)
ON DUPLICATE KEY UPDATE
  name = VALUES(name),
  specs = VALUES(specs),
  price = VALUES(price),
  stock = VALUES(stock),
  image_url = VALUES(image_url),
  type = VALUES(type),
  status = VALUES(status);
