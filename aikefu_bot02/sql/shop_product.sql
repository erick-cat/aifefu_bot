-- 商品表 + 会话关联商品（在已有 aikefu_bot 库执行）
-- 若 chat_session 已有数据，ALTER 前请备份

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

-- 会话关联当前咨询商品（可为空表示通用咨询）
ALTER TABLE chat_session
  ADD COLUMN product_id BIGINT UNSIGNED DEFAULT NULL COMMENT '咨询关联商品' AFTER user_id,
  ADD KEY idx_cs_product (product_id);

INSERT INTO shop_product (id, name, specs, price, stock, image_url, type, status) VALUES
(1, '无线蓝牙耳机 Pro', '蓝牙5.3 / 主动降噪 / 续航30h', 299.00, 420, 'https://picsum.photos/seed/earpro/400/400', '数码影音', 0),
(2, '智能手环 X1', '1.47英寸 AMOLED / 血氧心率', 199.00, 880, 'https://picsum.photos/seed/bandx1/400/400', '穿戴设备', 0),
(3, '氮化镓快充头 65W', '双口 Type-C / 折叠插脚', 89.00, 1200, 'https://picsum.photos/seed/gan65/400/400', '配件', 0),
(4, '机械键盘 K8', '87键 / 热插拔 / RGB', 459.00, 156, 'https://picsum.photos/seed/kb8/400/400', '外设', 0),
(5, '便携显示器 15.6"', '1080P / 60Hz / Type-C一线通', 899.00, 75, 'https://picsum.photos/seed/monitor15/400/400', '显示设备', 0),
(6, '智能台灯 L2', '无频闪 / 色温可调 / APP控制', 159.00, 340, 'https://picsum.photos/seed/lamp2/400/400', '智能家居', 0),
(7, 'USB-C 扩展坞', 'HDMI+USB3.0+读卡器', 129.00, 600, 'https://picsum.photos/seed/dockc/400/400', '配件', 0),
(8, '运动水壶 750ml', '不锈钢 / 保温12h', 79.00, 500, 'https://picsum.photos/seed/bottle750/400/400', '生活', 0),
(9, '迷你投影仪 P1', '720P / 自动对焦 / 内置音箱', 1299.00, 42, 'https://picsum.photos/seed/proj1/400/400', '数码影音', 0),
(10, '人体工学鼠标', '无线2.4G+蓝牙双模 / 静音按键', 169.00, 230, 'https://picsum.photos/seed/mouseergo/400/400', '外设', 0);
