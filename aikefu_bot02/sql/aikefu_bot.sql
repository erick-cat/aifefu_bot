/*
 Navicat Premium Dump SQL

 Source Server         : 图书推荐系统
 Source Server Type    : MySQL
 Source Server Version : 80408 (8.4.8)
 Source Host           : localhost:3306
 Source Schema         : aikefu_bot

 Target Server Type    : MySQL
 Target Server Version : 80408 (8.4.8)
 File Encoding         : 65001

 Date: 10/04/2026 10:21:40
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for admin_operation_log
-- ----------------------------
DROP TABLE IF EXISTS `admin_operation_log`;
CREATE TABLE `admin_operation_log`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `admin_id` bigint UNSIGNED NOT NULL,
  `module` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `action` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `resource_type` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `resource_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `ip` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `before_json` json NULL,
  `after_json` json NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_aol_admin`(`admin_id` ASC) USING BTREE,
  INDEX `idx_aol_time`(`created_at` ASC) USING BTREE,
  CONSTRAINT `fk_aol_admin` FOREIGN KEY (`admin_id`) REFERENCES `admin_user` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 11 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '管理端操作日志' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of admin_operation_log
-- ----------------------------
INSERT INTO `admin_operation_log` VALUES (1, 1, 'kb', 'publish', 'knowledge_document', '1', '10.0.0.5', NULL, '{\"status\": 1}', '2026-02-01 11:00:00');
INSERT INTO `admin_operation_log` VALUES (2, 4, 'kb', 'update', 'knowledge_document', '3', '10.0.0.12', '{\"title\": \"旧标题\"}', '{\"title\": \"下单后多久发货\"}', '2026-02-05 12:00:00');
INSERT INTO `admin_operation_log` VALUES (3, 1, 'model', 'update', 'llm_model_config', '1', '10.0.0.5', '{\"temperature\": 0.6}', '{\"temperature\": 0.7}', '2026-03-01 10:00:00');
INSERT INTO `admin_operation_log` VALUES (4, 6, 'prompt', 'create', 'prompt_template', '10', '10.0.0.20', NULL, '{\"scene\": \"offline\"}', '2026-03-01 11:00:00');
INSERT INTO `admin_operation_log` VALUES (5, 2, 'risk', 'create', 'sensitive_word', '6', '10.0.0.8', NULL, '{\"word\": \"加微信转账\"}', '2026-02-05 15:00:00');
INSERT INTO `admin_operation_log` VALUES (6, 8, 'agent', 'status', 'agent_user', '4', '10.0.0.30', '{\"online\": 1}', '{\"online\": 2}', '2026-03-30 09:00:00');
INSERT INTO `admin_operation_log` VALUES (7, 4, 'kb', 'import', 'knowledge_document', 'batch', '10.0.0.12', NULL, '{\"count\": 5}', '2026-03-10 14:00:00');
INSERT INTO `admin_operation_log` VALUES (8, 1, 'sys', 'role_bind', 'admin_user', '9', '10.0.0.5', NULL, '{\"role_id\": 7}', '2026-03-15 16:00:00');
INSERT INTO `admin_operation_log` VALUES (9, 5, 'chat', 'export', 'chat_session', '202603', '10.0.0.40', NULL, '{\"rows\": 1200}', '2026-03-20 10:00:00');
INSERT INTO `admin_operation_log` VALUES (10, 9, 'stat', 'view', 'report', 'daily', '10.0.0.50', NULL, NULL, '2026-03-29 15:30:00');

-- ----------------------------
-- Table structure for admin_user
-- ----------------------------
DROP TABLE IF EXISTS `admin_user`;
CREATE TABLE `admin_user`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `username` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '登录名',
  `password_hash` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `real_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `email` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `status` tinyint NOT NULL DEFAULT 0 COMMENT '0正常 1禁用',
  `last_login_at` datetime NULL DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_admin_username`(`username` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 11 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '后台管理员' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of admin_user
-- ----------------------------
INSERT INTO `admin_user` VALUES (1, 'admin', '$2a$10$7k79ApIQLYbn9TCFDjhWgOPVWQeDM/ab8ynSFbkTcZJLPS87zN5F2', '系统管理员', '13900001001', 'admin@company.com', 0, '2026-03-31 07:00:00', '2026-01-01 00:00:00', '2026-04-02 10:32:20');
INSERT INTO `admin_user` VALUES (2, 'operator01', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', '运营小王', '13900001002', 'op1@company.com', 0, '2026-03-30 18:00:00', '2026-01-05 10:00:00', '2026-03-31 15:36:45');
INSERT INTO `admin_user` VALUES (3, 'operator02', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', '运营小李', '13900001003', 'op2@company.com', 0, '2026-03-29 09:00:00', '2026-01-05 10:00:00', '2026-03-31 15:36:45');
INSERT INTO `admin_user` VALUES (4, 'kb_mgr', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', '知识库主管', '13900001004', 'kb@company.com', 0, '2026-03-28 17:00:00', '2026-02-01 10:00:00', '2026-03-31 15:36:45');
INSERT INTO `admin_user` VALUES (5, 'auditor', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', '审计员', '13900001005', 'audit@company.com', 0, '2026-03-27 12:00:00', '2026-02-10 10:00:00', '2026-03-31 15:36:45');
INSERT INTO `admin_user` VALUES (6, 'devops', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', '运维', '13900001006', 'dev@company.com', 0, '2026-03-31 06:30:00', '2026-02-15 10:00:00', '2026-03-31 15:36:45');
INSERT INTO `admin_user` VALUES (7, 'readonly', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', '只读账号', '13900001007', 'ro@company.com', 0, '2026-03-20 10:00:00', '2026-03-01 10:00:00', '2026-03-31 15:36:45');
INSERT INTO `admin_user` VALUES (8, 'agent_mgr', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', '客服主管', '13900001008', 'am@company.com', 0, '2026-03-30 10:00:00', '2026-03-10 10:00:00', '2026-03-31 15:36:45');
INSERT INTO `admin_user` VALUES (9, 'analyst', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', '数据分析师', '13900001009', 'an@company.com', 0, '2026-03-29 15:00:00', '2026-03-15 10:00:00', '2026-03-31 15:36:45');
INSERT INTO `admin_user` VALUES (10, 'temp_admin', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', '临时管理员', '13900001010', 'tmp@company.com', 1, NULL, '2026-03-25 10:00:00', '2026-03-31 15:36:45');

-- ----------------------------
-- Table structure for admin_user_role
-- ----------------------------
DROP TABLE IF EXISTS `admin_user_role`;
CREATE TABLE `admin_user_role`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `admin_id` bigint UNSIGNED NOT NULL,
  `role_id` bigint UNSIGNED NOT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_admin_role`(`admin_id` ASC, `role_id` ASC) USING BTREE,
  INDEX `idx_aur_role`(`role_id` ASC) USING BTREE,
  CONSTRAINT `fk_aur_admin` FOREIGN KEY (`admin_id`) REFERENCES `admin_user` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `fk_aur_role` FOREIGN KEY (`role_id`) REFERENCES `sys_role` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 11 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '管理员-角色' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of admin_user_role
-- ----------------------------
INSERT INTO `admin_user_role` VALUES (1, 1, 1, '2026-01-01 00:00:00');
INSERT INTO `admin_user_role` VALUES (2, 2, 4, '2026-01-05 10:00:00');
INSERT INTO `admin_user_role` VALUES (3, 3, 4, '2026-01-05 10:00:00');
INSERT INTO `admin_user_role` VALUES (4, 4, 2, '2026-02-01 10:00:00');
INSERT INTO `admin_user_role` VALUES (5, 5, 3, '2026-02-10 10:00:00');
INSERT INTO `admin_user_role` VALUES (6, 6, 5, '2026-02-15 10:00:00');
INSERT INTO `admin_user_role` VALUES (7, 7, 9, '2026-03-01 10:00:00');
INSERT INTO `admin_user_role` VALUES (8, 8, 8, '2026-03-10 10:00:00');
INSERT INTO `admin_user_role` VALUES (9, 9, 7, '2026-03-15 10:00:00');
INSERT INTO `admin_user_role` VALUES (10, 10, 2, '2026-03-25 10:00:00');

-- ----------------------------
-- Table structure for agent_user
-- ----------------------------
DROP TABLE IF EXISTS `agent_user`;
CREATE TABLE `agent_user`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `work_no` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '工号',
  `display_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '显示名',
  `bind_admin_id` bigint UNSIGNED NULL DEFAULT NULL COMMENT '关联管理员ID',
  `skill_group` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT 'default' COMMENT '技能组',
  `status` tinyint NOT NULL DEFAULT 0 COMMENT '0在职 1停用',
  `online_status` tinyint NOT NULL DEFAULT 0 COMMENT '0离线 1在线 2忙碌',
  `max_concurrent` int NOT NULL DEFAULT 3 COMMENT '最大并发会话数',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_agent_work_no`(`work_no` ASC) USING BTREE,
  INDEX `idx_agent_admin`(`bind_admin_id` ASC) USING BTREE,
  CONSTRAINT `fk_agent_admin` FOREIGN KEY (`bind_admin_id`) REFERENCES `admin_user` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 11 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '人工客服坐席' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of agent_user
-- ----------------------------
INSERT INTO `agent_user` VALUES (1, 'A1001', '坐席-刘芳', 8, '售前', 0, 1, 3, '2026-01-10 10:00:00');
INSERT INTO `agent_user` VALUES (2, 'A1002', '坐席-陈强', 8, '售后', 0, 1, 3, '2026-01-10 10:00:00');
INSERT INTO `agent_user` VALUES (3, 'A1003', '坐席-杨敏', NULL, '投诉', 0, 0, 2, '2026-02-01 10:00:00');
INSERT INTO `agent_user` VALUES (4, 'A1004', '坐席-赵磊', NULL, '售前', 0, 2, 4, '2026-02-01 10:00:00');
INSERT INTO `agent_user` VALUES (5, 'A1005', '坐席-黄婷', NULL, '售后', 0, 1, 3, '2026-02-15 10:00:00');
INSERT INTO `agent_user` VALUES (6, 'A1006', '坐席-吴刚', NULL, 'default', 0, 0, 3, '2026-03-01 10:00:00');
INSERT INTO `agent_user` VALUES (7, 'A1007', '坐席-徐丽', NULL, '售前', 0, 1, 3, '2026-03-01 10:00:00');
INSERT INTO `agent_user` VALUES (8, 'A1008', '坐席-马超', NULL, '售后', 0, 0, 3, '2026-03-05 10:00:00');
INSERT INTO `agent_user` VALUES (9, 'A1009', '坐席-丁悦', NULL, '投诉', 0, 1, 2, '2026-03-10 10:00:00');
INSERT INTO `agent_user` VALUES (10, 'A1010', '坐席-高远', NULL, 'default', 1, 0, 3, '2026-03-15 10:00:00');

-- ----------------------------
-- Table structure for chat_message
-- ----------------------------
DROP TABLE IF EXISTS `chat_message`;
CREATE TABLE `chat_message`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `session_id` bigint UNSIGNED NOT NULL,
  `role_type` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'user/assistant/system/agent',
  `content` mediumtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `metadata_json` json NULL COMMENT '引用来源、工具调用等',
  `token_usage` int NULL DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_cm_session`(`session_id` ASC) USING BTREE,
  CONSTRAINT `fk_cm_session` FOREIGN KEY (`session_id`) REFERENCES `chat_session` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 57 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '聊天消息' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of chat_message
-- ----------------------------
INSERT INTO `chat_message` VALUES (1, 1, 'user', '怎么修改登录密码？', '{\"client\": \"web\"}', 12, '2026-03-30 10:00:00');
INSERT INTO `chat_message` VALUES (2, 1, 'assistant', '您可以在个人中心-安全设置中修改密码，需完成身份验证。', '{\"refs\": [\"doc:1\"]}', 45, '2026-03-30 10:00:30');
INSERT INTO `chat_message` VALUES (3, 2, 'user', '下单后几天发货？', NULL, 10, '2026-03-29 14:00:00');
INSERT INTO `chat_message` VALUES (4, 2, 'assistant', '现货订单一般48小时内发货，预售请参考商品页说明。', '{\"refs\": [\"doc:3\"]}', 40, '2026-03-29 14:01:00');
INSERT INTO `chat_message` VALUES (5, 3, 'user', '运费谁承担？', NULL, 8, '2026-03-31 08:00:00');
INSERT INTO `chat_message` VALUES (6, 3, 'assistant', '请以订单结算页与活动规则为准，一般满额包邮。', NULL, 35, '2026-03-31 08:01:00');
INSERT INTO `chat_message` VALUES (7, 4, 'user', '如何开发票？', NULL, 8, '2026-03-28 16:00:00');
INSERT INTO `chat_message` VALUES (8, 4, 'assistant', '订单完成后可在订单页申请电子发票。', '{\"refs\": [\"doc:5\"]}', 30, '2026-03-28 16:01:00');
INSERT INTO `chat_message` VALUES (9, 5, 'user', '我要找人工', NULL, 6, '2026-03-27 11:00:00');
INSERT INTO `chat_message` VALUES (10, 5, 'system', '已为您接入排队，请稍候。', '{\"event\": \"transfer\"}', 15, '2026-03-27 11:00:10');
INSERT INTO `chat_message` VALUES (11, 6, 'user', '会员有什么权益？', NULL, 10, '2026-03-26 09:00:00');
INSERT INTO `chat_message` VALUES (12, 6, 'assistant', '不同会员等级享受不同折扣与积分倍率。', '{\"refs\": [\"doc:7\"]}', 38, '2026-03-26 09:01:00');
INSERT INTO `chat_message` VALUES (21, 19, 'user', '请做个自我介绍', NULL, NULL, '2026-04-02 11:22:23');
INSERT INTO `chat_message` VALUES (22, 19, 'assistant', '你好！我是DeepSeek，由深度求索公司创造的AI助手，很高兴认识你！😊\n\n我是一个纯文本模型，虽然不支持多模态识别，但我有文件上传功能，可以处理图像、txt、pdf、ppt、word、excel等文件，从中读取文字信息来帮助你。我完全免费使用，拥有128K的上下文长度，还支持联网搜索功能（需要你在Web/App中手动开启）。\n\n我的知识截止到2024年7月，会以热情细腻的方式为你提供帮助。无论你有什么问题或需要什么协助，我都会尽力为你解答！\n\n有什么我可以帮你的吗？', NULL, 303, '2026-04-02 11:22:28');
INSERT INTO `chat_message` VALUES (23, 19, 'user', '商品还有吗', NULL, NULL, '2026-04-02 11:22:39');
INSERT INTO `chat_message` VALUES (24, 19, 'assistant', '您好！我无法直接查询商品库存信息，因为我没有访问具体商城或库存系统的权限。\n\n为了帮您确认商品是否有货，建议您：\n1. 直接访问相关购物网站或APP查看库存状态\n2. 联系商家的在线客服或客服热线\n3. 前往实体店铺咨询\n\n如果您能告诉我具体的商品名称或商家信息，我可以帮您查找相关的官方联系方式或网站链接。您也可以告诉我更多关于您想查询的商品信息，我会尽力为您提供其他帮助！😊', NULL, 416, '2026-04-02 11:22:43');
INSERT INTO `chat_message` VALUES (25, 19, 'user', '政治敏感词B', NULL, NULL, '2026-04-02 11:23:02');
INSERT INTO `chat_message` VALUES (26, 19, 'assistant', '对不起，我还没有学会回答这个问题。如果你有其他问题，我非常乐意为你提供帮助。', NULL, 442, '2026-04-02 11:23:04');
INSERT INTO `chat_message` VALUES (27, 19, 'user', '傻逼', NULL, NULL, '2026-04-02 11:23:12');
INSERT INTO `chat_message` VALUES (28, 19, 'assistant', '您好，我理解您可能遇到了一些困扰或不满。作为AI助手，我的目标是专业、友善地为您提供帮助。如果您有任何问题或需要协助的地方，请随时告诉我具体内容，我会尽力为您解答或提供支持。😊', NULL, 498, '2026-04-02 11:23:14');
INSERT INTO `chat_message` VALUES (29, 19, 'user', '物流多久到', NULL, NULL, '2026-04-02 11:23:58');
INSERT INTO `chat_message` VALUES (30, 19, 'assistant', '您好！关于物流配送时间，这通常取决于以下几个因素：\n\n1. **发货地点** - 不同地区的发货速度不同\n2. **收货地址** - 距离远近影响配送时间\n3. **物流公司** - 不同快递公司的时效不同\n4. **商品类型** - 有些商品可能需要特殊处理\n5. **当前时段** - 节假日或促销期间可能会有延迟\n\n**建议您：**\n- 查看订单详情页，通常会有预计送达时间\n- 联系商家客服获取具体物流信息\n- 使用快递单号在物流公司官网查询实时进度\n\n如果您能提供更具体的信息（如购买平台、发货地、收货地等），我可以帮您查找一般的物流时效参考。您也可以告诉我订单号或快递单号，我会教您如何查询物流状态！📦', NULL, 678, '2026-04-02 11:24:04');
INSERT INTO `chat_message` VALUES (31, 19, 'user', '七天无理由规则', NULL, NULL, '2026-04-02 11:25:41');
INSERT INTO `chat_message` VALUES (32, 19, 'assistant', '您好！关于“七天无理由退货”规则，这是中国《消费者权益保护法》规定的一项重要消费者权益。以下是主要要点：\n\n## **基本规定**\n- **适用范围**：大部分网购商品（部分特殊商品除外）\n- **时间计算**：自收到商品之日起7日内\n- **条件要求**：商品应当完好，不影响二次销售\n\n## **不适用“七天无理由”的商品**\n1. 定制类商品\n2. 鲜活易腐类商品\n3. 在线下载或已拆封的音像制品、软件等数字化商品\n4. 交付的报纸、期刊\n5. 根据商品性质不宜退货的商品（需经消费者确认）\n\n## **注意事项**\n- 退货运费：一般由消费者承担，除非商家承诺免费退换\n- 包装要求：商品本身、配件、赠品、包装等应齐全完好\n- 退款时间：商家收到退货后应在规定时间内退款\n\n## **建议**\n1. 退货前仔细阅读商家的具体退货政策\n2. 保留好商品原包装和所有配件\n3. 拍照/录像记录商品状态\n4. 通过正规渠道办理退货手续\n\n如果您有具体的退货需求，建议先查看商家的详细退货政策，或直接联系商家客服确认。需要其他帮助吗？😊', NULL, 962, '2026-04-02 11:25:51');
INSERT INTO `chat_message` VALUES (33, 19, 'user', '请介绍一下你自己', NULL, NULL, '2026-04-02 11:31:11');
INSERT INTO `chat_message` VALUES (34, 19, 'assistant', '您好！我是DeepSeek，很高兴为您介绍自己：\n\n## **我的基本信息**\n- **创造者**：由深度求索公司开发的人工智能助手\n- **版本**：DeepSeek最新版本模型\n- **知识截止**：2024年7月\n- **上下文长度**：128K\n\n## **我的能力特点**\n- **文本处理**：纯文本模型，擅长各种文字交流和分析\n- **文件处理**：支持上传图像、txt、pdf、ppt、word、excel等文件，可读取其中的文字信息\n- **联网搜索**：支持联网获取最新信息（需手动开启）\n- **完全免费**：目前所有服务都是免费的\n\n## **我的服务风格**\n- 热情细腻，乐于助人\n- 回答力求准确、详细\n- 会诚实地告知自己的能力边界\n\n## **我不能做的**\n- 不支持多模态识别（但能读取上传文件中的文字）\n- 没有语音功能\n- 无法访问实时库存、订单等具体商业数据\n\n我的目标就是尽我所能帮助您解决问题！无论您有什么疑问或需要什么协助，都可以随时告诉我。有什么具体想了解的吗？😊', NULL, 1976, '2026-04-02 11:31:20');
INSERT INTO `chat_message` VALUES (35, 19, 'user', '商品还有货吗', NULL, NULL, '2026-04-02 11:31:35');
INSERT INTO `chat_message` VALUES (36, 19, 'assistant', '您好！我理解您想查询商品库存情况，但作为AI助手，我无法直接访问商家的实时库存系统或查看具体商品的存货状态。\n\n**建议您通过以下方式查询：**\n1. **查看商品页面**：在购物网站/APP的商品详情页通常会有库存显示\n2. **联系商家客服**：直接咨询在线客服或拨打客服电话\n3. **实体店查询**：如有实体店，可电话或到店咨询\n4. **订单状态**：如已下单，可在订单详情中查看发货和库存情况\n\n**如果您能提供更多信息，我可以帮您：**\n- 查找商家的官方联系方式\n- 指导您如何在相关平台查询库存\n- 提供一般的购物建议\n\n请告诉我您想查询的具体商品或商家名称，我会尽力为您提供有用的指引！😊', NULL, 2160, '2026-04-02 11:31:42');
INSERT INTO `chat_message` VALUES (37, 19, 'user', '联系我们', NULL, NULL, '2026-04-02 11:32:40');
INSERT INTO `chat_message` VALUES (38, 19, 'assistant', '您好！关于联系商家的方式，根据一般电商平台的情况，通常有以下几种途径：\n\n## **官方联系渠道**\n1. **在线客服**：在购物网站/APP内查找“客服”或“联系客服”入口\n2. **客服热线**：查看商品页面或网站底部的客服电话\n3. **官方邮箱**：通常在网站“联系我们”或“关于我们”页面\n4. **社交媒体**：官方微博、微信公众号等\n\n## **建议操作步骤**\n1. **登录账号**：先登录您的购物账号\n2. **进入订单页**：找到相关订单，点击“联系客服”\n3. **选择问题类型**：根据您的问题选择相应分类\n4. **描述问题**：清晰说明您的情况\n\n## **温馨提示**\n- 工作日的工作时间联系通常响应更快\n- 准备好订单号、商品信息等资料\n- 复杂问题建议通过电话或在线客服直接沟通\n\n如果您能告诉我具体的平台或商家名称，我可以帮您查找更准确的联系方式。需要我协助查找某个特定商家的联系方式吗？😊', NULL, 2386, '2026-04-02 11:32:48');
INSERT INTO `chat_message` VALUES (39, 20, 'user', '还有货吗', NULL, NULL, '2026-04-02 12:14:53');
INSERT INTO `chat_message` VALUES (40, 20, 'assistant', '您好，我是æºæåå的官方客服。\n\n关于您咨询的商品库存情况，我目前无法直接查询到具体信息。我们的商品库存是实时变动的，最准确的信息请以您浏览的商品详情页显示为准。\n\n为了能更准确地为您服务，您可以：\n1.  提供具体的商品名称或订单号，我将尽力为您查询相关状态。\n2.  直接查看您感兴趣的商品页面，获取最新的库存、价格及预售时间等信息。\n3.  若您已有订单需要咨询，请提供订单号，以便我为您跟进。\n\n对于其他复杂问题，我们的工作时间是工作日9:00-18:00，您可以随时联系人工客服处理。', NULL, 1088, '2026-04-02 12:14:59');
INSERT INTO `chat_message` VALUES (41, 21, 'user', '这个商品可以便宜吗', NULL, NULL, '2026-04-02 12:30:28');
INSERT INTO `chat_message` VALUES (42, 21, 'assistant', '关于价格优惠，目前「迷你投影仪 P1」的官方售价为1299.00元。我们暂无其他折扣活动。若您对价格有疑虑，建议关注商品页面，店铺的促销信息会第一时间在页面更新。', NULL, 1116, '2026-04-02 12:30:31');
INSERT INTO `chat_message` VALUES (43, 21, 'user', '可以投多大的屏幕', NULL, NULL, '2026-04-02 12:30:46');
INSERT INTO `chat_message` VALUES (44, 21, 'assistant', '根据商品信息，「迷你投影仪 P1」支持720P分辨率与自动对焦功能。关于具体的投射屏幕尺寸，当前提供的参数中未明确说明。建议您查阅商品详情页的技术规格部分，或联系人工客服（工作时间：工作日9:00-18:00）获取更精确的投影尺寸范围信息。', NULL, 1193, '2026-04-02 12:30:49');
INSERT INTO `chat_message` VALUES (45, 22, 'user', '鼠标默认dip是多少', NULL, NULL, '2026-04-02 12:40:03');
INSERT INTO `chat_message` VALUES (46, 22, 'assistant', '关于您询问的「人体工学鼠标」默认DPI值，根据当前商品信息，该参数未在提供的规格中明确列出。\n\n**建议您：**\n1.  查看商品包装内的说明书。\n2.  在商品详情页的「规格参数」或「常见问题」部分查找。\n3.  若仍无法确认，可提供您的订单号，以便我们为您查询更详细的产品资料。\n\n本窗口仅解答「人体工学鼠标」相关问题；其他问题请返回商品列表选择对应商品或联系人工客服。', NULL, 1174, '2026-04-02 12:40:07');
INSERT INTO `chat_message` VALUES (47, 22, 'user', '还有什么颜色', NULL, NULL, '2026-04-02 12:40:18');
INSERT INTO `chat_message` VALUES (48, 22, 'assistant', '关于您询问的「人体工学鼠标」可选颜色，根据当前提供的商品信息，**规格中未列出具体的颜色选项**。\n\n**建议您：**\n1.  直接查看商品详情页的图片展示或规格参数列表，那里通常会标明可选颜色。\n2.  若详情页中仍无法确定，您可以提供具体的订单号，以便我们为您查询该批次产品的详细信息。\n\n本窗口仅解答「人体工学鼠标」相关问题；其他问题请返回商品列表选择对应商品或联系人工客服。', NULL, 1286, '2026-04-02 12:40:22');
INSERT INTO `chat_message` VALUES (49, 22, 'user', '什么配置', NULL, NULL, '2026-04-02 12:40:35');
INSERT INTO `chat_message` VALUES (50, 22, 'assistant', '关于您询问的「人体工学鼠标」配置，根据当前商品信息，其核心配置如下：\n\n**已知配置：**\n*   **连接方式**：无线2.4G + 蓝牙双模\n*   **按键特性**：静音按键\n*   **类型**：外设\n\n**未提及的配置（需您自行确认）：**\n商品信息中未提供DPI、回报率、具体尺寸、重量、电池类型、颜色等其他详细配置参数。\n\n**建议您：**\n1.  仔细浏览商品详情页的「规格与包装」部分，以获取完整参数。\n2.  若对未列明的参数有疑问，可提供订单号以便我们协助查询。\n\n本窗口仅解答「人体工学鼠标」相关问题；其他问题请返回商品列表选择对应商品或联系人工客服。', NULL, 1464, '2026-04-02 12:40:41');
INSERT INTO `chat_message` VALUES (51, 23, 'user', '介绍一下配置', NULL, NULL, '2026-04-02 13:23:50');
INSERT INTO `chat_message` VALUES (52, 23, 'assistant', '根据商品信息，这款人体工学鼠标的配置如下：\n\n1.  **连接方式**：无线2.4G + 蓝牙双模连接，可在两台设备间灵活切换。\n2.  **按键特性**：采用静音按键设计，操作时声音轻柔。\n3.  **参考价格**：169.00元。\n4.  **当前库存**：230件。\n\n关于更详细的技术参数（如DPI、续航时间、具体尺寸等），当前商品信息中未提供。如需了解，建议您查看商品详情页的完整介绍或直接咨询人工客服。', NULL, 1184, '2026-04-02 13:23:56');
INSERT INTO `chat_message` VALUES (53, 24, 'user', '介绍一下商品', NULL, NULL, '2026-04-02 21:46:44');
INSERT INTO `chat_message` VALUES (54, 24, 'assistant', '您好，这里是「人体工学鼠标」的专属客服。\n\n根据您的要求，该商品的详细信息如下：\n\n1.  **商品名称**：人体工学鼠标\n2.  **连接方式**：支持无线2.4G和蓝牙双模连接，可在两台设备间轻松切换。\n3.  **使用体验**：采用静音按键设计，有效减少点击噪音，适合办公、图书馆等安静环境。\n4.  **参考图片**：您可以查看此链接以了解产品外观样式：[https://picsum.photos/seed/mouseergo/400/400](https://picsum.photos/seed/mouseergo/400/400)\n5.  **当前价格**：169.00元\n6.  **库存状态**：目前有货，库存230件。\n\n**温馨提示**：\n*   本窗口仅解答关于「人体工学鼠标」的规格、功能等商品本身的问题。\n*   如需咨询订单、物流、退换货或其他商品，请返回商品列表选择对应客服入口或联系人工客服。', NULL, 1283, '2026-04-02 21:46:53');
INSERT INTO `chat_message` VALUES (55, 25, 'user', '介绍一下配置', NULL, NULL, '2026-04-03 10:50:41');
INSERT INTO `chat_message` VALUES (56, 25, 'assistant', '根据商品信息，这款人体工学鼠标的配置如下：\n\n1.  **连接方式**：无线2.4G + 蓝牙双模连接，可在两台设备间灵活切换。\n2.  **按键特性**：采用静音按键设计，能有效减少使用时的噪音。\n3.  **参考图片**：您可以查看此链接了解产品外观样式：[https://picsum.photos/seed/mouseergo/400/400](https://picsum.photos/seed/mouseergo/400/400)\n\n关于更详细的技术参数（如DPI、续航时间、具体尺寸等），当前商品页信息中未提及。若您需要了解，建议：\n*   查阅商品详情页的完整描述。\n*   或提供您的订单号，以便我为您查询更具体的记录。\n*   在工作时间（9:00-18:00）联系人工客服获取帮助。\n\n本窗口仅解答「人体工学鼠标」相关问题；其他问题请返回商品列表选择对应商品或联系人工客服。', NULL, 1275, '2026-04-03 10:50:49');

-- ----------------------------
-- Table structure for chat_session
-- ----------------------------
DROP TABLE IF EXISTS `chat_session`;
CREATE TABLE `chat_session`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id` bigint UNSIGNED NULL DEFAULT NULL COMMENT 'C端用户，匿名为空',
  `product_id` bigint UNSIGNED NULL DEFAULT NULL COMMENT '咨询关联商品',
  `anonymous_token` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '匿名访客标识',
  `channel` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'web' COMMENT 'web/h5/mini',
  `status` tinyint NOT NULL DEFAULT 0 COMMENT '0进行中 1已结束 2转人工中 3已关闭',
  `title` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '会话标题/首句摘要',
  `robot_mode` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT 'rag' COMMENT 'rag/general',
  `started_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `ended_at` datetime NULL DEFAULT NULL,
  `last_message_at` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_cs_user`(`user_id` ASC) USING BTREE,
  INDEX `idx_cs_anon`(`anonymous_token` ASC) USING BTREE,
  INDEX `idx_cs_started`(`started_at` ASC) USING BTREE,
  INDEX `idx_cs_product`(`product_id` ASC) USING BTREE,
  CONSTRAINT `fk_cs_user` FOREIGN KEY (`user_id`) REFERENCES `customer_user` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 26 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '聊天会话' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of chat_session
-- ----------------------------
INSERT INTO `chat_session` VALUES (1, 1, NULL, NULL, 'web', 1, '咨询修改密码', 'rag', '2026-03-30 10:00:00', NULL, '2026-03-30 10:05:00');
INSERT INTO `chat_session` VALUES (2, 2, NULL, NULL, 'h5', 1, '物流多久到', 'rag', '2026-03-29 14:00:00', NULL, '2026-03-29 14:10:00');
INSERT INTO `chat_session` VALUES (3, NULL, NULL, 'anon_uuid_001', 'web', 0, NULL, 'rag', '2026-03-31 08:00:00', NULL, '2026-03-31 08:02:00');
INSERT INTO `chat_session` VALUES (4, 3, NULL, NULL, 'web', 1, '发票问题', 'rag', '2026-03-28 16:00:00', NULL, '2026-03-28 16:20:00');
INSERT INTO `chat_session` VALUES (5, 5, NULL, NULL, 'mini', 2, '转人工排队', 'rag', '2026-03-27 11:00:00', NULL, '2026-03-27 11:30:00');
INSERT INTO `chat_session` VALUES (6, 8, NULL, NULL, 'web', 1, '会员等级', 'rag', '2026-03-26 09:00:00', NULL, '2026-03-26 09:15:00');
INSERT INTO `chat_session` VALUES (7, 9, NULL, NULL, 'h5', 1, '退换货', 'rag', '2026-03-25 20:00:00', NULL, '2026-03-25 20:08:00');
INSERT INTO `chat_session` VALUES (8, 10, NULL, NULL, 'web', 0, '技术支持', 'rag', '2026-03-31 09:30:00', NULL, '2026-03-31 09:35:00');
INSERT INTO `chat_session` VALUES (9, 4, NULL, NULL, 'web', 1, '发货时间', 'rag', '2026-03-24 13:00:00', NULL, '2026-03-24 13:05:00');
INSERT INTO `chat_session` VALUES (10, 7, NULL, NULL, 'web', 1, '联系渠道', 'rag', '2026-03-23 18:00:00', NULL, '2026-03-23 18:12:00');
INSERT INTO `chat_session` VALUES (19, 11, NULL, NULL, 'web', 0, '请做个自我介绍', 'general', '2026-04-02 11:22:23', NULL, '2026-04-02 11:32:48');
INSERT INTO `chat_session` VALUES (20, 11, NULL, NULL, 'web', 0, '还有货吗', 'general', '2026-04-02 12:14:53', NULL, '2026-04-02 12:15:00');
INSERT INTO `chat_session` VALUES (21, 11, 9, NULL, 'web', 0, '咨询：迷你投影仪 P1', 'product', '2026-04-02 12:30:28', NULL, '2026-04-02 12:30:50');
INSERT INTO `chat_session` VALUES (22, 11, 10, NULL, 'web', 0, '咨询：人体工学鼠标', 'product', '2026-04-02 12:40:03', NULL, '2026-04-02 12:40:42');
INSERT INTO `chat_session` VALUES (23, 11, 10, NULL, 'web', 0, '咨询：人体工学鼠标', 'product', '2026-04-02 13:23:50', NULL, '2026-04-02 13:23:56');
INSERT INTO `chat_session` VALUES (24, 11, 10, NULL, 'web', 0, '咨询：人体工学鼠标', 'product', '2026-04-02 21:46:44', NULL, '2026-04-02 21:46:54');
INSERT INTO `chat_session` VALUES (25, 11, 10, NULL, 'web', 0, '咨询：人体工学鼠标', 'product', '2026-04-03 10:50:41', NULL, '2026-04-03 10:50:49');

-- ----------------------------
-- Table structure for customer_feedback
-- ----------------------------
DROP TABLE IF EXISTS `customer_feedback`;
CREATE TABLE `customer_feedback`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `session_id` bigint UNSIGNED NOT NULL,
  `user_id` bigint UNSIGNED NULL DEFAULT NULL,
  `rating` tinyint NOT NULL COMMENT '1-5星',
  `comment` varchar(1024) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `tags` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '逗号分隔标签',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_cf_session`(`session_id` ASC) USING BTREE,
  INDEX `fk_cf_user`(`user_id` ASC) USING BTREE,
  CONSTRAINT `fk_cf_session` FOREIGN KEY (`session_id`) REFERENCES `chat_session` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `fk_cf_user` FOREIGN KEY (`user_id`) REFERENCES `customer_user` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 11 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '用户评价' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of customer_feedback
-- ----------------------------
INSERT INTO `customer_feedback` VALUES (1, 1, 1, 5, '回答很清晰', '满意,准确', '2026-03-30 10:06:00');
INSERT INTO `customer_feedback` VALUES (2, 2, 2, 4, '还可以', '物流', '2026-03-29 14:12:00');
INSERT INTO `customer_feedback` VALUES (3, 4, 3, 5, NULL, NULL, '2026-03-28 16:25:00');
INSERT INTO `customer_feedback` VALUES (4, 6, 8, 3, '希望更详细', '会员', '2026-03-26 09:20:00');
INSERT INTO `customer_feedback` VALUES (5, 7, 9, 5, '很好', '售后', '2026-03-25 20:10:00');
INSERT INTO `customer_feedback` VALUES (6, 9, 4, 4, NULL, NULL, '2026-03-24 13:10:00');
INSERT INTO `customer_feedback` VALUES (7, 10, 7, 2, '等待较久', '慢', '2026-03-23 18:15:00');
INSERT INTO `customer_feedback` VALUES (8, 8, 10, 5, '不错', NULL, '2026-03-31 09:40:00');
INSERT INTO `customer_feedback` VALUES (9, 3, NULL, 4, '匿名用户评价', '匿名', '2026-03-31 08:05:00');
INSERT INTO `customer_feedback` VALUES (10, 2, 2, 5, '二次评价补充分', '物流,快', '2026-03-29 14:30:00');

-- ----------------------------
-- Table structure for customer_user
-- ----------------------------
DROP TABLE IF EXISTS `customer_user`;
CREATE TABLE `customer_user`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键',
  `username` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '登录名',
  `phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '手机号',
  `email` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '邮箱',
  `password_hash` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '密码哈希',
  `nickname` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '昵称',
  `avatar_url` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '头像URL',
  `status` tinyint NOT NULL DEFAULT 0 COMMENT '0正常 1冻结 2注销',
  `register_source` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT 'web' COMMENT '注册来源',
  `phone_verified` tinyint NOT NULL DEFAULT 0 COMMENT '0未验证 1已验证',
  `last_login_at` datetime NULL DEFAULT NULL COMMENT '最近登录时间',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted` tinyint NOT NULL DEFAULT 0 COMMENT '0否 1逻辑删除',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_customer_username`(`username` ASC) USING BTREE,
  INDEX `idx_customer_phone`(`phone` ASC) USING BTREE,
  INDEX `idx_customer_created`(`created_at` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 12 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = 'C端用户' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of customer_user
-- ----------------------------
INSERT INTO `customer_user` VALUES (1, 'zhangsan', '13800001001', 'zs@example.com', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', '张三', NULL, 0, 'web', 1, '2026-03-30 09:00:00', '2026-01-10 10:00:00', '2026-03-31 15:36:45', 0);
INSERT INTO `customer_user` VALUES (2, 'lisi', '13800001002', 'ls@example.com', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', '李四', NULL, 0, 'h5', 1, '2026-03-29 14:20:00', '2026-02-01 11:00:00', '2026-03-31 15:36:45', 0);
INSERT INTO `customer_user` VALUES (3, 'wangwu', '13800001003', 'ww@example.com', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', '王五', NULL, 0, 'web', 0, NULL, '2026-02-15 08:30:00', '2026-03-31 15:36:45', 0);
INSERT INTO `customer_user` VALUES (4, 'zhaoliu', '13800001004', NULL, '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', '赵六', NULL, 0, 'mini', 1, '2026-03-28 18:00:00', '2026-03-01 12:00:00', '2026-03-31 15:36:45', 0);
INSERT INTO `customer_user` VALUES (5, 'sunqi', '13800001005', 'sq@example.com', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', '孙七', NULL, 0, 'web', 1, '2026-03-31 08:10:00', '2026-03-05 09:00:00', '2026-03-31 15:36:45', 0);
INSERT INTO `customer_user` VALUES (6, 'zhouba', '13800001006', 'zb@example.com', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', '周八', NULL, 1, 'web', 1, '2026-03-01 10:00:00', '2025-12-20 10:00:00', '2026-03-31 15:36:45', 0);
INSERT INTO `customer_user` VALUES (7, 'wujiu', '13800001007', NULL, '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', '吴九', NULL, 0, 'web', 0, '2026-03-27 16:00:00', '2026-03-10 14:00:00', '2026-03-31 15:36:45', 0);
INSERT INTO `customer_user` VALUES (8, 'zhengshi', '13800001008', 'zs2@example.com', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', '郑十', NULL, 0, 'h5', 1, '2026-03-30 20:00:00', '2026-03-12 16:00:00', '2026-03-31 15:36:45', 0);
INSERT INTO `customer_user` VALUES (9, 'testuser09', '13800001009', 'tu9@example.com', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', '测试用户9', NULL, 0, 'web', 1, '2026-03-29 11:11:00', '2026-03-15 10:00:00', '2026-03-31 15:36:45', 0);
INSERT INTO `customer_user` VALUES (10, 'testuser10', '13800001010', 'tu10@example.com', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', '测试用户10', NULL, 0, 'web', 1, '2026-03-30 22:00:00', '2026-03-20 10:00:00', '2026-03-31 15:36:45', 0);
INSERT INTO `customer_user` VALUES (11, 'zhang_san', NULL, NULL, '$2a$10$1eTsHxnff91w6WTQ7sYB4u4nVHRhVEgAg.Bag1njVbNjq2ctpjNQi', '反方向的猫', NULL, 0, 'portal', 0, '2026-04-02 13:23:00', '2026-04-02 11:15:39', '2026-04-02 13:23:00', 0);

-- ----------------------------
-- Table structure for human_transfer_record
-- ----------------------------
DROP TABLE IF EXISTS `human_transfer_record`;
CREATE TABLE `human_transfer_record`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `session_id` bigint UNSIGNED NOT NULL,
  `agent_id` bigint UNSIGNED NULL DEFAULT NULL,
  `queue_position` int NULL DEFAULT NULL,
  `status` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'queued' COMMENT 'queued/picked/closed/cancel',
  `reason` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `picked_at` datetime NULL DEFAULT NULL,
  `closed_at` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_ht_session`(`session_id` ASC) USING BTREE,
  INDEX `idx_ht_agent`(`agent_id` ASC) USING BTREE,
  CONSTRAINT `fk_ht_agent` FOREIGN KEY (`agent_id`) REFERENCES `agent_user` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `fk_ht_session` FOREIGN KEY (`session_id`) REFERENCES `chat_session` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 11 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '转人工记录' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of human_transfer_record
-- ----------------------------
INSERT INTO `human_transfer_record` VALUES (1, 5, 1, 1, 'closed', '用户要求', '2026-03-27 11:00:10', '2026-03-27 11:05:00', '2026-03-27 11:25:00');
INSERT INTO `human_transfer_record` VALUES (2, 2, 2, 2, 'closed', NULL, '2026-03-26 10:00:00', '2026-03-26 10:02:00', '2026-03-26 10:20:00');
INSERT INTO `human_transfer_record` VALUES (3, 4, NULL, 3, 'cancel', '用户取消', '2026-03-25 15:00:00', NULL, '2026-03-25 15:02:00');
INSERT INTO `human_transfer_record` VALUES (4, 1, 5, 1, 'picked', '咨询升级', '2026-03-31 07:00:00', '2026-03-31 07:01:00', NULL);
INSERT INTO `human_transfer_record` VALUES (5, 6, 7, 2, 'closed', NULL, '2026-03-24 12:00:00', '2026-03-24 12:01:00', '2026-03-24 12:30:00');
INSERT INTO `human_transfer_record` VALUES (6, 7, 3, 4, 'queued', '投诉', '2026-03-31 10:00:00', NULL, NULL);
INSERT INTO `human_transfer_record` VALUES (7, 8, 4, 1, 'closed', NULL, '2026-03-22 11:00:00', '2026-03-22 11:02:00', '2026-03-22 11:40:00');
INSERT INTO `human_transfer_record` VALUES (8, 9, 9, 3, 'closed', NULL, '2026-03-21 09:00:00', '2026-03-21 09:05:00', '2026-03-21 09:25:00');
INSERT INTO `human_transfer_record` VALUES (9, 10, 8, 2, 'closed', NULL, '2026-03-20 14:00:00', '2026-03-20 14:03:00', '2026-03-20 14:18:00');
INSERT INTO `human_transfer_record` VALUES (10, 3, 6, 5, 'cancel', '超时未接入', '2026-03-19 16:00:00', NULL, '2026-03-19 16:30:00');

-- ----------------------------
-- Table structure for kb_embedding_meta
-- ----------------------------
DROP TABLE IF EXISTS `kb_embedding_meta`;
CREATE TABLE `kb_embedding_meta`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `chunk_id` bigint UNSIGNED NOT NULL,
  `model_name` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Embedding模型名',
  `embedding_dim` int NOT NULL DEFAULT 1536,
  `vector_json` json NOT NULL COMMENT '向量JSON(演示为短向量)',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_emb_chunk_model`(`chunk_id` ASC, `model_name` ASC) USING BTREE,
  CONSTRAINT `fk_emb_chunk` FOREIGN KEY (`chunk_id`) REFERENCES `knowledge_chunk` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 11 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '切片向量元数据' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of kb_embedding_meta
-- ----------------------------
INSERT INTO `kb_embedding_meta` VALUES (1, 1, 'text-embedding-3-small', 16, '[0.01, 0.02, 0.03, 0.04, 0.05, 0.06, 0.07, 0.08, 0.09, 0.10, 0.11, 0.12, 0.13, 0.14, 0.15, 0.16]', '2026-02-01 10:00:00');
INSERT INTO `kb_embedding_meta` VALUES (2, 2, 'text-embedding-3-small', 16, '[0.11, 0.12, 0.13, 0.14, 0.15, 0.16, 0.17, 0.18, 0.19, 0.20, 0.21, 0.22, 0.23, 0.24, 0.25, 0.26]', '2026-02-01 10:00:00');
INSERT INTO `kb_embedding_meta` VALUES (3, 3, 'text-embedding-3-small', 16, '[0.21, 0.22, 0.23, 0.24, 0.25, 0.26, 0.27, 0.28, 0.29, 0.30, 0.31, 0.32, 0.33, 0.34, 0.35, 0.36]', '2026-02-05 10:00:00');
INSERT INTO `kb_embedding_meta` VALUES (4, 4, 'text-embedding-3-small', 16, '[0.31, 0.32, 0.33, 0.34, 0.35, 0.36, 0.37, 0.38, 0.39, 0.40, 0.41, 0.42, 0.43, 0.44, 0.45, 0.46]', '2026-02-05 10:00:00');
INSERT INTO `kb_embedding_meta` VALUES (5, 5, 'text-embedding-3-small', 16, '[0.41, 0.42, 0.43, 0.44, 0.45, 0.46, 0.47, 0.48, 0.49, 0.50, 0.51, 0.52, 0.53, 0.54, 0.55, 0.56]', '2026-02-10 10:00:00');
INSERT INTO `kb_embedding_meta` VALUES (6, 6, 'text-embedding-3-small', 16, '[0.51, 0.52, 0.53, 0.54, 0.55, 0.56, 0.57, 0.58, 0.59, 0.60, 0.61, 0.62, 0.63, 0.64, 0.65, 0.66]', '2026-02-12 10:00:00');
INSERT INTO `kb_embedding_meta` VALUES (7, 7, 'text-embedding-3-small', 16, '[0.61, 0.62, 0.63, 0.64, 0.65, 0.66, 0.67, 0.68, 0.69, 0.70, 0.71, 0.72, 0.73, 0.74, 0.75, 0.76]', '2026-02-15 10:00:00');
INSERT INTO `kb_embedding_meta` VALUES (8, 8, 'text-embedding-3-small', 16, '[0.71, 0.72, 0.73, 0.74, 0.75, 0.76, 0.77, 0.78, 0.79, 0.80, 0.81, 0.82, 0.83, 0.84, 0.85, 0.86]', '2026-02-18 10:00:00');
INSERT INTO `kb_embedding_meta` VALUES (9, 9, 'text-embedding-3-small', 16, '[0.81, 0.82, 0.83, 0.84, 0.85, 0.86, 0.87, 0.88, 0.89, 0.90, 0.91, 0.92, 0.93, 0.94, 0.95, 0.96]', '2026-02-20 10:00:00');
INSERT INTO `kb_embedding_meta` VALUES (10, 10, 'text-embedding-3-small', 16, '[0.91, 0.92, 0.93, 0.94, 0.95, 0.96, 0.97, 0.98, 0.99, 1.00, 0.01, 0.02, 0.03, 0.04, 0.05, 0.06]', '2026-02-22 10:00:00');

-- ----------------------------
-- Table structure for knowledge_category
-- ----------------------------
DROP TABLE IF EXISTS `knowledge_category`;
CREATE TABLE `knowledge_category`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `parent_id` bigint UNSIGNED NULL DEFAULT 0 COMMENT '父分类ID',
  `name` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `sort_order` int NOT NULL DEFAULT 0,
  `status` tinyint NOT NULL DEFAULT 0 COMMENT '0启用 1停用',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_kc_parent`(`parent_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 11 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '知识分类' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of knowledge_category
-- ----------------------------
INSERT INTO `knowledge_category` VALUES (1, 0, '账户与安全', 1, 0, '2026-01-01 00:00:00');
INSERT INTO `knowledge_category` VALUES (2, 0, '订单与物流', 2, 0, '2026-01-01 00:00:00');
INSERT INTO `knowledge_category` VALUES (3, 0, '支付与发票', 3, 0, '2026-01-01 00:00:00');
INSERT INTO `knowledge_category` VALUES (4, 0, '退换货', 4, 0, '2026-01-01 00:00:00');
INSERT INTO `knowledge_category` VALUES (5, 0, '会员权益', 5, 0, '2026-01-01 00:00:00');
INSERT INTO `knowledge_category` VALUES (6, 2, '发货时效', 1, 0, '2026-01-01 00:00:00');
INSERT INTO `knowledge_category` VALUES (7, 2, '物流查询', 2, 0, '2026-01-01 00:00:00');
INSERT INTO `knowledge_category` VALUES (8, 0, '技术支持', 6, 0, '2026-01-01 00:00:00');
INSERT INTO `knowledge_category` VALUES (9, 0, '常见问题', 7, 0, '2026-01-01 00:00:00');
INSERT INTO `knowledge_category` VALUES (10, 0, '其他', 99, 0, '2026-01-01 00:00:00');

-- ----------------------------
-- Table structure for knowledge_chunk
-- ----------------------------
DROP TABLE IF EXISTS `knowledge_chunk`;
CREATE TABLE `knowledge_chunk`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `document_id` bigint UNSIGNED NOT NULL,
  `chunk_index` int NOT NULL DEFAULT 0 COMMENT '切片序号',
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `token_count` int NULL DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_kchunk_doc`(`document_id` ASC) USING BTREE,
  CONSTRAINT `fk_kchunk_doc` FOREIGN KEY (`document_id`) REFERENCES `knowledge_document` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 11 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '知识切片' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of knowledge_chunk
-- ----------------------------
INSERT INTO `knowledge_chunk` VALUES (1, 1, 0, '进入个人中心-安全设置-修改密码，按提示完成验证后即可修改。', 32, '2026-02-01 10:00:00');
INSERT INTO `knowledge_chunk` VALUES (2, 2, 0, '连续输错密码将临时锁定，请等待30分钟或通过手机验证码找回。', 28, '2026-02-01 10:00:00');
INSERT INTO `knowledge_chunk` VALUES (3, 3, 0, '现货订单一般48小时内发货，预售以商品页说明为准。', 24, '2026-02-05 10:00:00');
INSERT INTO `knowledge_chunk` VALUES (4, 4, 0, '订单详情页可查看物流单号，复制到快递公司官网或小程序查询。', 30, '2026-02-05 10:00:00');
INSERT INTO `knowledge_chunk` VALUES (5, 5, 0, '订单完成后可在订单页申请电子发票，信息提交后1-3个工作日开具。', 32, '2026-02-10 10:00:00');
INSERT INTO `knowledge_chunk` VALUES (6, 6, 0, '符合商品页标注支持无理由的商品，签收7天内可申请，需保持完好。', 34, '2026-02-12 10:00:00');
INSERT INTO `knowledge_chunk` VALUES (7, 7, 0, '根据近12个月消费金额划分等级，不同等级享受不同折扣与积分倍率。', 34, '2026-02-15 10:00:00');
INSERT INTO `knowledge_chunk` VALUES (8, 8, 0, '请清除浏览器缓存、更换网络或更新App至最新版本后重试。', 28, '2026-02-18 10:00:00');
INSERT INTO `knowledge_chunk` VALUES (9, 9, 0, '智能客服7×24小时；人工客服工作日9:00-21:00。', 22, '2026-02-20 10:00:00');
INSERT INTO `knowledge_chunk` VALUES (10, 10, 0, '可通过在线客服、官方邮箱或微博私信联系，非紧急建议留言。', 30, '2026-02-22 10:00:00');

-- ----------------------------
-- Table structure for knowledge_document
-- ----------------------------
DROP TABLE IF EXISTS `knowledge_document`;
CREATE TABLE `knowledge_document`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `category_id` bigint UNSIGNED NOT NULL,
  `title` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `doc_type` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'faq' COMMENT 'faq/file/html',
  `content` mediumtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '正文或摘要',
  `file_url` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `status` tinyint NOT NULL DEFAULT 0 COMMENT '0草稿 1已发布 2下线',
  `version_no` int NOT NULL DEFAULT 1,
  `published_at` datetime NULL DEFAULT NULL,
  `created_by` bigint UNSIGNED NULL DEFAULT NULL COMMENT '管理员ID',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_kd_cat`(`category_id` ASC) USING BTREE,
  INDEX `idx_kd_status`(`status` ASC) USING BTREE,
  CONSTRAINT `fk_kd_cat` FOREIGN KEY (`category_id`) REFERENCES `knowledge_category` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 11 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '知识文档' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of knowledge_document
-- ----------------------------
INSERT INTO `knowledge_document` VALUES (1, 1, '如何修改登录密码', 'faq', '进入个人中心-安全设置-修改密码，按提示完成验证后即可修改。', NULL, 1, 1, '2026-02-01 10:00:00', 1, '2026-02-01 10:00:00', '2026-03-31 15:36:45');
INSERT INTO `knowledge_document` VALUES (2, 1, '账号锁定怎么办', 'faq', '连续输错密码将临时锁定，请等待30分钟或通过手机验证码找回。', NULL, 1, 1, '2026-02-01 10:00:00', 1, '2026-02-01 10:00:00', '2026-03-31 15:36:45');
INSERT INTO `knowledge_document` VALUES (3, 2, '下单后多久发货', 'faq', '现货订单一般48小时内发货，预售以商品页说明为准。', NULL, 1, 1, '2026-02-05 10:00:00', 4, '2026-02-05 10:00:00', '2026-03-31 15:36:45');
INSERT INTO `knowledge_document` VALUES (4, 7, '如何查询物流', 'faq', '订单详情页可查看物流单号，复制到快递公司官网或小程序查询。', NULL, 1, 1, '2026-02-05 10:00:00', 4, '2026-02-05 10:00:00', '2026-03-31 15:36:45');
INSERT INTO `knowledge_document` VALUES (5, 3, '发票开具说明', 'faq', '订单完成后可在订单页申请电子发票，信息提交后1-3个工作日开具。', NULL, 1, 1, '2026-02-10 10:00:00', 4, '2026-02-10 10:00:00', '2026-03-31 15:36:45');
INSERT INTO `knowledge_document` VALUES (6, 4, '七天无理由规则', 'faq', '符合商品页标注支持无理由的商品，签收7天内可申请，需保持完好。', NULL, 1, 1, '2026-02-12 10:00:00', 4, '2026-02-12 10:00:00', '2026-03-31 15:36:45');
INSERT INTO `knowledge_document` VALUES (7, 5, '会员等级说明', 'faq', '根据近12个月消费金额划分等级，不同等级享受不同折扣与积分倍率。', NULL, 1, 1, '2026-02-15 10:00:00', 2, '2026-02-15 10:00:00', '2026-03-31 15:36:45');
INSERT INTO `knowledge_document` VALUES (8, 8, '无法打开页面', 'faq', '请清除浏览器缓存、更换网络或更新App至最新版本后重试。', NULL, 1, 1, '2026-02-18 10:00:00', 2, '2026-02-18 10:00:00', '2026-03-31 15:36:45');
INSERT INTO `knowledge_document` VALUES (9, 9, '客服服务时间', 'faq', '智能客服7×24小时；人工客服工作日9:00-21:00。', NULL, 1, 1, '2026-02-20 10:00:00', 2, '2026-02-20 10:00:00', '2026-03-31 15:36:45');
INSERT INTO `knowledge_document` VALUES (10, 10, '联系我们', 'faq', '可通过在线客服、官方邮箱或微博私信联系，非紧急建议留言。', NULL, 1, 1, '2026-02-22 10:00:00', 2, '2026-02-22 10:00:00', '2026-03-31 15:36:45');

-- ----------------------------
-- Table structure for llm_model_config
-- ----------------------------
DROP TABLE IF EXISTS `llm_model_config`;
CREATE TABLE `llm_model_config`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `config_name` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '配置名称',
  `provider` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'openai/azure/local等',
  `model_name` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `api_key_ref` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '密钥引用/脱敏ID，非明文',
  `embedding_model` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `temperature` decimal(4, 3) NOT NULL DEFAULT 0.700,
  `top_p` decimal(4, 3) NOT NULL DEFAULT 1.000,
  `max_tokens` int NOT NULL DEFAULT 2048,
  `timeout_ms` int NOT NULL DEFAULT 60000,
  `is_default_chat` tinyint NOT NULL DEFAULT 0,
  `is_default_embed` tinyint NOT NULL DEFAULT 0,
  `status` tinyint NOT NULL DEFAULT 0 COMMENT '0启用 1停用',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_llm_default`(`is_default_chat` ASC, `status` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 11 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = 'LLM与Embedding配置' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of llm_model_config
-- ----------------------------
INSERT INTO `llm_model_config` VALUES (1, '生产-对话主模型', 'openai', 'gpt-4o-mini', 'vault:openai_main', 'text-embedding-3-small', 0.700, 1.000, 2048, 60000, 1, 1, 0, '2026-01-01 00:00:00', '2026-03-31 15:36:45');
INSERT INTO `llm_model_config` VALUES (2, '备用-对话', 'openai', 'gpt-3.5-turbo', 'vault:openai_backup', NULL, 0.600, 1.000, 1024, 45000, 0, 0, 0, '2026-01-01 00:00:00', '2026-03-31 15:36:45');
INSERT INTO `llm_model_config` VALUES (3, '本地测试-Chat', 'local', 'qwen2.5-7b', NULL, NULL, 0.800, 0.950, 4096, 120000, 0, 0, 1, '2026-02-01 00:00:00', '2026-03-31 15:36:45');
INSERT INTO `llm_model_config` VALUES (4, 'Azure-企业', 'azure', 'gpt-4o', 'vault:azure_1', 'text-embedding-ada-002', 0.700, 1.000, 4096, 90000, 0, 0, 0, '2026-02-05 00:00:00', '2026-03-31 15:36:45');
INSERT INTO `llm_model_config` VALUES (5, 'Embedding专用', 'openai', 'dummy', 'vault:openai_emb', 'text-embedding-3-large', 0.000, 1.000, 0, 30000, 0, 0, 0, '2026-02-10 00:00:00', '2026-03-31 15:36:45');
INSERT INTO `llm_model_config` VALUES (6, '高创意营销', 'openai', 'gpt-4o', 'vault:openai_main', NULL, 0.900, 0.950, 2048, 60000, 0, 0, 0, '2026-02-12 00:00:00', '2026-03-31 15:36:45');
INSERT INTO `llm_model_config` VALUES (7, '低延迟', 'openai', 'gpt-4o-mini', 'vault:openai_main', NULL, 0.300, 0.900, 512, 20000, 0, 0, 0, '2026-02-15 00:00:00', '2026-03-31 15:36:45');
INSERT INTO `llm_model_config` VALUES (8, '长文本', 'openai', 'gpt-4-turbo', 'vault:openai_main', NULL, 0.700, 1.000, 8192, 120000, 0, 0, 1, '2026-03-01 00:00:00', '2026-03-31 15:36:45');
INSERT INTO `llm_model_config` VALUES (9, '试用-DeepSeek', 'deepseek', 'deepseek-chat', 'vault:ds_1', NULL, 0.700, 1.000, 2048, 60000, 0, 0, 0, '2026-03-10 00:00:00', '2026-03-31 15:36:45');
INSERT INTO `llm_model_config` VALUES (10, '归档配置', 'openai', 'gpt-3.5-turbo', 'vault:old', NULL, 0.500, 1.000, 1024, 60000, 0, 0, 1, '2026-03-20 00:00:00', '2026-03-31 15:36:45');

-- ----------------------------
-- Table structure for prompt_template
-- ----------------------------
DROP TABLE IF EXISTS `prompt_template`;
CREATE TABLE `prompt_template`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `scene_code` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '场景编码',
  `name` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `content` mediumtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `variables_json` json NULL COMMENT '占位变量说明',
  `status` tinyint NOT NULL DEFAULT 0 COMMENT '0启用 1停用',
  `current_version` int NOT NULL DEFAULT 1,
  `created_by` bigint UNSIGNED NULL DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_pt_scene`(`scene_code` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 11 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = 'Prompt模板' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of prompt_template
-- ----------------------------
INSERT INTO `prompt_template` VALUES (1, 'rag_system', 'RAG系统提示', '你是智能客服，仅根据【知识】回答，无法确定时请说明并建议转人工。', '{\"vars\": [\"knowledge\", \"history\"]}', 0, 2, 1, '2026-01-01 00:00:00', '2026-03-31 15:36:45');
INSERT INTO `prompt_template` VALUES (2, 'welcome', '欢迎语', '您好，我是智能助手，请问有什么可以帮您？', NULL, 0, 1, 1, '2026-01-01 00:00:00', '2026-03-31 15:36:45');
INSERT INTO `prompt_template` VALUES (3, 'refuse', '无依据拒答', '当前知识库未收录该问题，为您转接人工客服。', NULL, 0, 1, 1, '2026-01-01 00:00:00', '2026-03-31 15:36:45');
INSERT INTO `prompt_template` VALUES (4, 'transfer', '转人工提示', '正在为您转接人工客服，请稍候。', NULL, 0, 1, 1, '2026-01-01 00:00:00', '2026-03-31 15:36:45');
INSERT INTO `prompt_template` VALUES (5, 'summary', '会话摘要', '请用三句话总结用户诉求与已处理项。', NULL, 0, 1, 6, '2026-02-01 00:00:00', '2026-03-31 15:36:45');
INSERT INTO `prompt_template` VALUES (6, 'safety', '安全补充', '禁止输出违法、侵权与隐私内容。', NULL, 0, 1, 1, '2026-02-01 00:00:00', '2026-03-31 15:36:45');
INSERT INTO `prompt_template` VALUES (7, 'intent', '意图澄清', '您是指订单问题还是售后问题？', NULL, 0, 1, 2, '2026-02-10 00:00:00', '2026-03-31 15:36:45');
INSERT INTO `prompt_template` VALUES (8, 'product', '商品咨询', '请结合商品页参数与库存状态回答用户。', NULL, 0, 1, 2, '2026-02-10 00:00:00', '2026-03-31 15:36:45');
INSERT INTO `prompt_template` VALUES (9, 'vip', '会员话术', '会员权益以活动页公示为准。', NULL, 0, 1, 2, '2026-02-15 00:00:00', '2026-03-31 15:36:45');
INSERT INTO `prompt_template` VALUES (10, 'offline', '降级话术', '系统繁忙，请稍后再试或留言。', NULL, 0, 1, 6, '2026-03-01 00:00:00', '2026-03-31 15:36:45');

-- ----------------------------
-- Table structure for prompt_template_history
-- ----------------------------
DROP TABLE IF EXISTS `prompt_template_history`;
CREATE TABLE `prompt_template_history`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `template_id` bigint UNSIGNED NOT NULL,
  `version_no` int NOT NULL,
  `content` mediumtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `changed_by` bigint UNSIGNED NULL DEFAULT NULL,
  `changed_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `remark` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_pth_tpl`(`template_id` ASC) USING BTREE,
  CONSTRAINT `fk_pth_tpl` FOREIGN KEY (`template_id`) REFERENCES `prompt_template` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 11 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = 'Prompt版本历史' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of prompt_template_history
-- ----------------------------
INSERT INTO `prompt_template_history` VALUES (1, 1, 1, '你是客服助手，请友好回答。', 1, '2026-01-01 00:00:00', '初版');
INSERT INTO `prompt_template_history` VALUES (2, 1, 2, '你是智能客服，仅根据【知识】回答，无法确定时请说明并建议转人工。', 1, '2026-02-01 10:00:00', '加入RAG约束');
INSERT INTO `prompt_template_history` VALUES (3, 2, 1, '您好，请问有什么可以帮您？', 1, '2026-01-01 00:00:00', '初版');
INSERT INTO `prompt_template_history` VALUES (4, 3, 1, '我不知道。', 1, '2026-01-01 00:00:00', '初版');
INSERT INTO `prompt_template_history` VALUES (5, 4, 1, '转人工中', 1, '2026-01-01 00:00:00', '初版');
INSERT INTO `prompt_template_history` VALUES (6, 5, 1, '请总结会话。', 6, '2026-02-01 00:00:00', '初版');
INSERT INTO `prompt_template_history` VALUES (7, 6, 1, '注意安全。', 1, '2026-02-01 00:00:00', '初版');
INSERT INTO `prompt_template_history` VALUES (8, 7, 1, '请选择问题类型。', 2, '2026-02-10 00:00:00', '初版');
INSERT INTO `prompt_template_history` VALUES (9, 8, 1, '回答商品问题。', 2, '2026-02-10 00:00:00', '初版');
INSERT INTO `prompt_template_history` VALUES (10, 9, 1, '会员说明。', 2, '2026-02-15 00:00:00', '初版');

-- ----------------------------
-- Table structure for role_permission
-- ----------------------------
DROP TABLE IF EXISTS `role_permission`;
CREATE TABLE `role_permission`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `role_id` bigint UNSIGNED NOT NULL,
  `permission_id` bigint UNSIGNED NOT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_role_perm`(`role_id` ASC, `permission_id` ASC) USING BTREE,
  INDEX `idx_rp_perm`(`permission_id` ASC) USING BTREE,
  CONSTRAINT `fk_rp_perm` FOREIGN KEY (`permission_id`) REFERENCES `sys_permission` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `fk_rp_role` FOREIGN KEY (`role_id`) REFERENCES `sys_role` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 11 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '角色-权限' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of role_permission
-- ----------------------------
INSERT INTO `role_permission` VALUES (1, 1, 1, '2026-01-01 00:00:00');
INSERT INTO `role_permission` VALUES (2, 1, 2, '2026-01-01 00:00:00');
INSERT INTO `role_permission` VALUES (3, 1, 3, '2026-01-01 00:00:00');
INSERT INTO `role_permission` VALUES (4, 1, 4, '2026-01-01 00:00:00');
INSERT INTO `role_permission` VALUES (5, 1, 5, '2026-01-01 00:00:00');
INSERT INTO `role_permission` VALUES (6, 1, 6, '2026-01-01 00:00:00');
INSERT INTO `role_permission` VALUES (7, 1, 7, '2026-01-01 00:00:00');
INSERT INTO `role_permission` VALUES (8, 1, 8, '2026-01-01 00:00:00');
INSERT INTO `role_permission` VALUES (9, 1, 9, '2026-01-01 00:00:00');
INSERT INTO `role_permission` VALUES (10, 1, 10, '2026-01-01 00:00:00');

-- ----------------------------
-- Table structure for security_audit_log
-- ----------------------------
DROP TABLE IF EXISTS `security_audit_log`;
CREATE TABLE `security_audit_log`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_type` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'customer/admin/agent',
  `user_id` bigint UNSIGNED NULL DEFAULT NULL,
  `event_type` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'login/logout/fail等',
  `ip` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `user_agent` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `result` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'success',
  `detail_json` json NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_sal_user`(`user_type` ASC, `user_id` ASC) USING BTREE,
  INDEX `idx_sal_time`(`created_at` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 11 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '安全审计日志' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of security_audit_log
-- ----------------------------
INSERT INTO `security_audit_log` VALUES (1, 'customer', 1, 'login', '192.168.1.10', 'Mozilla/5.0', 'success', '{\"method\": \"password\"}', '2026-03-30 09:00:00');
INSERT INTO `security_audit_log` VALUES (2, 'admin', 1, 'login', '10.0.0.5', 'Chrome', 'success', NULL, '2026-03-31 07:00:00');
INSERT INTO `security_audit_log` VALUES (3, 'customer', 2, 'login_fail', '192.168.1.11', 'Safari', 'fail', '{\"reason\": \"bad_password\"}', '2026-03-29 08:00:00');
INSERT INTO `security_audit_log` VALUES (4, 'admin', 2, 'logout', '10.0.0.6', 'Chrome', 'success', NULL, '2026-03-30 18:05:00');
INSERT INTO `security_audit_log` VALUES (5, 'customer', 5, 'login', '172.16.0.2', 'App/1.0', 'success', NULL, '2026-03-31 08:10:00');
INSERT INTO `security_audit_log` VALUES (6, 'admin', 4, 'login', '10.0.0.7', 'Firefox', 'success', NULL, '2026-03-28 17:00:00');
INSERT INTO `security_audit_log` VALUES (7, 'customer', NULL, 'anon_chat', '203.0.113.1', 'H5', 'success', '{\"token\": \"anon_uuid_001\"}', '2026-03-31 08:00:00');
INSERT INTO `security_audit_log` VALUES (8, 'admin', 10, 'login_fail', '10.0.0.8', 'Edge', 'fail', '{\"reason\": \"disabled\"}', '2026-03-25 09:00:00');
INSERT INTO `security_audit_log` VALUES (9, 'customer', 8, 'logout', '192.168.2.3', 'Chrome', 'success', NULL, '2026-03-30 20:10:00');
INSERT INTO `security_audit_log` VALUES (10, 'admin', 6, 'login', '10.0.0.9', 'Chrome', 'success', NULL, '2026-03-31 06:30:00');

-- ----------------------------
-- Table structure for sensitive_word
-- ----------------------------
DROP TABLE IF EXISTS `sensitive_word`;
CREATE TABLE `sensitive_word`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `word` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `category` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT 'general' COMMENT '分类',
  `level` tinyint NOT NULL DEFAULT 1 COMMENT '1低 2中 3高',
  `action` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'block' COMMENT 'block/replace/warn/transfer',
  `replace_to` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `status` tinyint NOT NULL DEFAULT 0,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_sw_word`(`word` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 11 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '敏感词' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sensitive_word
-- ----------------------------
INSERT INTO `sensitive_word` VALUES (1, '赌博', '违法', 3, 'block', NULL, 0, '2026-01-01 00:00:00');
INSERT INTO `sensitive_word` VALUES (2, '色情', '违法', 3, 'block', NULL, 0, '2026-01-01 00:00:00');
INSERT INTO `sensitive_word` VALUES (3, '法轮功', '政治', 3, 'block', NULL, 0, '2026-01-01 00:00:00');
INSERT INTO `sensitive_word` VALUES (4, '傻逼', '辱骂', 2, 'replace', '**', 0, '2026-01-01 00:00:00');
INSERT INTO `sensitive_word` VALUES (5, '退款诈骗', '诈骗', 3, 'warn', NULL, 0, '2026-02-01 00:00:00');
INSERT INTO `sensitive_word` VALUES (6, '加微信转账', '诈骗', 3, 'transfer', NULL, 0, '2026-02-05 00:00:00');
INSERT INTO `sensitive_word` VALUES (7, '代开发票', '合规', 2, 'warn', NULL, 0, '2026-02-10 00:00:00');
INSERT INTO `sensitive_word` VALUES (8, '政治敏感词A', '政治', 3, 'block', NULL, 0, '2026-02-15 00:00:00');
INSERT INTO `sensitive_word` VALUES (9, '政治敏感词B', '政治', 3, 'block', NULL, 0, '2026-02-15 00:00:00');
INSERT INTO `sensitive_word` VALUES (10, '测试敏感', '测试', 1, 'warn', NULL, 1, '2026-03-01 00:00:00');

-- ----------------------------
-- Table structure for shop_product
-- ----------------------------
DROP TABLE IF EXISTS `shop_product`;
CREATE TABLE `shop_product`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '商品名称',
  `specs` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '规格',
  `price` decimal(12, 2) NOT NULL COMMENT '价格',
  `stock` int NOT NULL DEFAULT 0 COMMENT '库存量',
  `image_url` varchar(1024) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '图片URL',
  `type` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '类型',
  `status` tinyint NOT NULL DEFAULT 0 COMMENT '0上架 1下架',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_sp_type`(`type` ASC) USING BTREE,
  INDEX `idx_sp_status`(`status` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 11 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '商城商品' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of shop_product
-- ----------------------------
INSERT INTO `shop_product` VALUES (1, '无线蓝牙耳机 Pro', '蓝牙5.3 / 主动降噪 / 续航30h', 299.00, 420, 'https://picsum.photos/seed/earpro/400/400', '数码影音', 0, '2026-04-02 12:28:24', '2026-04-02 12:28:24');
INSERT INTO `shop_product` VALUES (2, '智能手环 X1', '1.47英寸 AMOLED / 血氧心率', 199.00, 880, 'https://picsum.photos/seed/bandx1/400/400', '穿戴设备', 0, '2026-04-02 12:28:24', '2026-04-02 12:28:24');
INSERT INTO `shop_product` VALUES (3, '氮化镓快充头 65W', '双口 Type-C / 折叠插脚', 89.00, 1200, 'https://picsum.photos/seed/gan65/400/400', '配件', 0, '2026-04-02 12:28:24', '2026-04-02 12:28:24');
INSERT INTO `shop_product` VALUES (4, '机械键盘 K8', '87键 / 热插拔 / RGB', 459.00, 156, 'https://picsum.photos/seed/kb8/400/400', '外设', 0, '2026-04-02 12:28:24', '2026-04-02 12:28:24');
INSERT INTO `shop_product` VALUES (5, '便携显示器 15.6\"', '1080P / 60Hz / Type-C一线通', 899.00, 75, 'https://picsum.photos/seed/monitor15/400/400', '显示设备', 0, '2026-04-02 12:28:24', '2026-04-02 12:28:24');
INSERT INTO `shop_product` VALUES (6, '智能台灯 L2', '无频闪 / 色温可调 / APP控制', 159.00, 340, 'https://picsum.photos/seed/lamp2/400/400', '智能家居', 0, '2026-04-02 12:28:24', '2026-04-02 12:28:24');
INSERT INTO `shop_product` VALUES (7, 'USB-C 扩展坞', 'HDMI+USB3.0+读卡器', 129.00, 600, 'https://picsum.photos/seed/dockc/400/400', '配件', 0, '2026-04-02 12:28:24', '2026-04-02 12:28:24');
INSERT INTO `shop_product` VALUES (8, '运动水壶 750ml', '不锈钢 / 保温12h', 79.00, 500, 'https://picsum.photos/seed/bottle750/400/400', '生活', 0, '2026-04-02 12:28:24', '2026-04-02 12:28:24');
INSERT INTO `shop_product` VALUES (9, '迷你投影仪 P1', '720P / 自动对焦 / 内置音箱', 1299.00, 42, 'https://picsum.photos/seed/proj1/400/400', '数码影音', 0, '2026-04-02 12:28:24', '2026-04-02 12:28:24');
INSERT INTO `shop_product` VALUES (10, '人体工学鼠标', '无线2.4G+蓝牙双模 / 静音按键', 169.00, 230, 'https://picsum.photos/seed/mouseergo/400/400', '外设', 0, '2026-04-02 12:28:24', '2026-04-02 12:28:24');

-- ----------------------------
-- Table structure for stat_daily_summary
-- ----------------------------
DROP TABLE IF EXISTS `stat_daily_summary`;
CREATE TABLE `stat_daily_summary`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `stat_date` date NOT NULL,
  `channel` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'all',
  `session_count` int NOT NULL DEFAULT 0,
  `message_count` int NOT NULL DEFAULT 0,
  `user_message_count` int NOT NULL DEFAULT 0,
  `transfer_count` int NOT NULL DEFAULT 0,
  `avg_response_ms` int NULL DEFAULT NULL,
  `satisfaction_avg` decimal(4, 2) NULL DEFAULT NULL COMMENT '平均分',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_stat_day_ch`(`stat_date` ASC, `channel` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 11 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '日汇总统计' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of stat_daily_summary
-- ----------------------------
INSERT INTO `stat_daily_summary` VALUES (1, '2026-03-31', 'all', 120, 980, 490, 15, 2300, 4.35, '2026-04-01 01:00:00');
INSERT INTO `stat_daily_summary` VALUES (2, '2026-03-30', 'all', 110, 900, 450, 12, 2400, 4.40, '2026-03-31 01:00:00');
INSERT INTO `stat_daily_summary` VALUES (3, '2026-03-29', 'all', 105, 860, 430, 11, 2500, 4.28, '2026-03-30 01:00:00');
INSERT INTO `stat_daily_summary` VALUES (4, '2026-03-28', 'web', 80, 640, 320, 8, 2200, 4.50, '2026-03-29 01:00:00');
INSERT INTO `stat_daily_summary` VALUES (5, '2026-03-28', 'h5', 25, 200, 100, 3, 2600, 4.10, '2026-03-29 01:00:00');
INSERT INTO `stat_daily_summary` VALUES (6, '2026-03-27', 'all', 98, 820, 410, 10, 2350, 4.33, '2026-03-28 01:00:00');
INSERT INTO `stat_daily_summary` VALUES (7, '2026-03-26', 'all', 90, 760, 380, 9, 2450, 4.20, '2026-03-27 01:00:00');
INSERT INTO `stat_daily_summary` VALUES (8, '2026-03-25', 'mini', 15, 120, 60, 2, 2800, 4.00, '2026-03-26 01:00:00');
INSERT INTO `stat_daily_summary` VALUES (9, '2026-03-24', 'all', 88, 700, 350, 8, 2400, 4.45, '2026-03-25 01:00:00');
INSERT INTO `stat_daily_summary` VALUES (10, '2026-03-23', 'all', 85, 680, 340, 7, 2500, 4.30, '2026-03-24 01:00:00');

-- ----------------------------
-- Table structure for sys_permission
-- ----------------------------
DROP TABLE IF EXISTS `sys_permission`;
CREATE TABLE `sys_permission`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `perm_code` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '权限标识',
  `perm_name` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '权限名称',
  `parent_id` bigint UNSIGNED NULL DEFAULT 0 COMMENT '父级ID',
  `perm_type` tinyint NOT NULL DEFAULT 1 COMMENT '1菜单 2按钮 3接口',
  `sort_order` int NOT NULL DEFAULT 0,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_perm_code`(`perm_code` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 11 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '权限' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_permission
-- ----------------------------
INSERT INTO `sys_permission` VALUES (1, 'kb:doc:view', '知识文档查看', 0, 1, 10, '2026-01-01 00:00:00');
INSERT INTO `sys_permission` VALUES (2, 'kb:doc:edit', '知识文档编辑', 0, 1, 20, '2026-01-01 00:00:00');
INSERT INTO `sys_permission` VALUES (3, 'kb:doc:publish', '知识发布', 0, 2, 30, '2026-01-01 00:00:00');
INSERT INTO `sys_permission` VALUES (4, 'chat:session:view', '会话查看', 0, 1, 40, '2026-01-01 00:00:00');
INSERT INTO `sys_permission` VALUES (5, 'chat:session:export', '会话导出', 0, 2, 50, '2026-01-01 00:00:00');
INSERT INTO `sys_permission` VALUES (6, 'model:config', '模型配置', 0, 1, 60, '2026-01-01 00:00:00');
INSERT INTO `sys_permission` VALUES (7, 'prompt:manage', 'Prompt管理', 0, 1, 70, '2026-01-01 00:00:00');
INSERT INTO `sys_permission` VALUES (8, 'risk:word', '敏感词管理', 0, 1, 80, '2026-01-01 00:00:00');
INSERT INTO `sys_permission` VALUES (9, 'stat:report', '统计报表', 0, 1, 90, '2026-01-01 00:00:00');
INSERT INTO `sys_permission` VALUES (10, 'sys:user:manage', '管理员账号', 0, 1, 100, '2026-01-01 00:00:00');

-- ----------------------------
-- Table structure for sys_role
-- ----------------------------
DROP TABLE IF EXISTS `sys_role`;
CREATE TABLE `sys_role`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `role_code` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '角色编码',
  `role_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '角色名称',
  `description` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `status` tinyint NOT NULL DEFAULT 0 COMMENT '0启用 1停用',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_role_code`(`role_code` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 11 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '角色' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_role
-- ----------------------------
INSERT INTO `sys_role` VALUES (1, 'SUPER_ADMIN', '超级管理员', '全部权限', 0, '2026-01-01 00:00:00');
INSERT INTO `sys_role` VALUES (2, 'KB_EDITOR', '知识编辑', '维护知识库', 0, '2026-01-01 00:00:00');
INSERT INTO `sys_role` VALUES (3, 'KB_AUDITOR', '知识审核', '审核发布', 0, '2026-01-01 00:00:00');
INSERT INTO `sys_role` VALUES (4, 'OPS_MONITOR', '运营监控', '会话与监控', 0, '2026-01-01 00:00:00');
INSERT INTO `sys_role` VALUES (5, 'MODEL_ADMIN', '模型配置', '模型与Prompt', 0, '2026-01-01 00:00:00');
INSERT INTO `sys_role` VALUES (6, 'RISK_ADMIN', '风控管理员', '敏感词与策略', 0, '2026-01-01 00:00:00');
INSERT INTO `sys_role` VALUES (7, 'ANALYST', '数据分析', '报表只读', 0, '2026-01-01 00:00:00');
INSERT INTO `sys_role` VALUES (8, 'AGENT_LEAD', '客服主管', '坐席与转接', 0, '2026-01-01 00:00:00');
INSERT INTO `sys_role` VALUES (9, 'READONLY', '只读', '仅查看', 0, '2026-01-01 00:00:00');
INSERT INTO `sys_role` VALUES (10, 'DEPRECATED', '废弃角色', '历史占位', 1, '2026-01-01 00:00:00');

SET FOREIGN_KEY_CHECKS = 1;
