# SQL 脚本说明

## 随应用自动执行的迁移（推荐）

增量 DDL/DML 已放在 **`src/main/resources/db/migration/`**，由 [Flyway](https://flywaydb.org/) 在 Spring Boot 启动时执行：

| 文件 | 说明 |
|------|------|
| `V1__shop_product_and_chat_session.sql` | 商品表、`chat_session.product_id`、示例商品数据 |
| `V2__portal_customer_chat_prompt.sql` | 门户对话提示词 `portal_customer_chat` |
| `V3__update_shop_product_placeholder_images.sql` | 将 1～10 号商品 `image_url` 更新为 placehold.co（国内常不可用，已由 V4 覆盖） |
| `V4__shop_product_image_urls_picsum.sql` | 将商品图改为 `picsum.photos` 固定 seed（国内可访问性更好；每 id 唯一种子） |

部署新版本 jar 后，服务器启动会自动检测未执行的版本并执行对应 SQL。

## 全量建库（首次或空库）

本仓库根目录下的 `aikefu_init.sql`、`aikefu_bot.sql` 为**完整/参考**脚本，需在空库或首次初始化时**手动**执行（或按运维流程导入）。  
Flyway 的 V1 依赖 **`chat_session` 等表已存在**，因此常规流程是：先执行全量初始化，再长期依赖 Flyway 做增量变更。

## 本地关闭 Flyway（可选）

在 `application-local.properties` 中：

```properties
spring.flyway.enabled=false
```

## 已有库、曾手动跑过旧版 SQL

已配置 `spring.flyway.baseline-on-migrate=true`：若库中已有表但尚无 `flyway_schema_history`，首次启动会**打基线到版本 1**，**不会执行 V1 脚本**，因此旧数据（如商品图仍为 picsum）需靠后续迁移（如 **V3**）修正。
