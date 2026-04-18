-- 针对「基线跳过 V1」或早期手动导入仍使用 picsum 的库，统一更新为带商品简称的占位图
UPDATE shop_product SET image_url = 'https://placehold.co/400x400/0f172a/5eead4?text=%E8%80%B3%E6%9C%BA' WHERE id = 1;
UPDATE shop_product SET image_url = 'https://placehold.co/400x400/134e4a/6ee7b7?text=%E6%89%8B%E7%8E%AF' WHERE id = 2;
UPDATE shop_product SET image_url = 'https://placehold.co/400x400/78350f/fcd34d?text=%E5%BF%AB%E5%85%85' WHERE id = 3;
UPDATE shop_product SET image_url = 'https://placehold.co/400x400/312e81/c4b5fd?text=%E9%94%AE%E7%9B%98' WHERE id = 4;
UPDATE shop_product SET image_url = 'https://placehold.co/400x400/1e293b/94a3b8?text=%E6%98%BE%E7%A4%BA' WHERE id = 5;
UPDATE shop_product SET image_url = 'https://placehold.co/400x400/422006/fde68a?text=%E5%8F%B0%E7%81%AF' WHERE id = 6;
UPDATE shop_product SET image_url = 'https://placehold.co/400x400/164e63/a5f3fc?text=%E6%89%A9%E5%B1%95' WHERE id = 7;
UPDATE shop_product SET image_url = 'https://placehold.co/400x400/14532d/86efac?text=%E6%B0%B4%E5%A3%B6' WHERE id = 8;
UPDATE shop_product SET image_url = 'https://placehold.co/400x400/831843/fbcfe8?text=%E6%8A%95%E5%BD%B1' WHERE id = 9;
UPDATE shop_product SET image_url = 'https://placehold.co/400x400/1e1b4b/a5b4fc?text=%E9%BC%A0%E6%A0%87' WHERE id = 10;
