-- placehold.co 在国内常无法访问，导致前端图片全部失败；改为 picsum 固定 seed（每商品唯一、可稳定复现）
UPDATE shop_product SET image_url = 'https://picsum.photos/seed/aikefu-prod-01-earbud/400/400' WHERE id = 1;
UPDATE shop_product SET image_url = 'https://picsum.photos/seed/aikefu-prod-02-smartband/400/400' WHERE id = 2;
UPDATE shop_product SET image_url = 'https://picsum.photos/seed/aikefu-prod-03-gan65w/400/400' WHERE id = 3;
UPDATE shop_product SET image_url = 'https://picsum.photos/seed/aikefu-prod-04-keyboard/400/400' WHERE id = 4;
UPDATE shop_product SET image_url = 'https://picsum.photos/seed/aikefu-prod-05-monitor/400/400' WHERE id = 5;
UPDATE shop_product SET image_url = 'https://picsum.photos/seed/aikefu-prod-06-lamp/400/400' WHERE id = 6;
UPDATE shop_product SET image_url = 'https://picsum.photos/seed/aikefu-prod-07-dock/400/400' WHERE id = 7;
UPDATE shop_product SET image_url = 'https://picsum.photos/seed/aikefu-prod-08-bottle/400/400' WHERE id = 8;
UPDATE shop_product SET image_url = 'https://picsum.photos/seed/aikefu-prod-09-projector/400/400' WHERE id = 9;
UPDATE shop_product SET image_url = 'https://picsum.photos/seed/aikefu-prod-10-mouse/400/400' WHERE id = 10;
