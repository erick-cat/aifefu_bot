-- =============================================================================
-- 智能客服系统 MySQL 初始化脚本
-- 字符集: utf8mb4 | 引擎: InnoDB | 建议 MySQL 8.0+（使用 JSON 函数 JSON_ARRAY / JSON_OBJECT）
-- 说明: 含建表 + 每表不少于 10 条示例数据，可直接导入
--
-- 导入前请先创建库并选择库，例如:
--   CREATE DATABASE IF NOT EXISTS aikefu DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
--   USE aikefu;
--   SOURCE /path/to/aikefu_init.sql;
-- 命令行一行示例:
--   mysql -u root -p aikefu < sql/aikefu_init.sql
--
-- 演示账号密码均为明文 password 对应的 BCrypt 哈希，生产环境务必替换。
-- =============================================================================

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- -----------------------------------------------------------------------------
-- 清理（按依赖逆序）
-- -----------------------------------------------------------------------------
DROP TABLE IF EXISTS human_transfer_record;
DROP TABLE IF EXISTS customer_feedback;
DROP TABLE IF EXISTS chat_message;
DROP TABLE IF EXISTS chat_session;
DROP TABLE IF EXISTS kb_embedding_meta;
DROP TABLE IF EXISTS knowledge_chunk;
DROP TABLE IF EXISTS knowledge_document;
DROP TABLE IF EXISTS knowledge_category;
DROP TABLE IF EXISTS prompt_template_history;
DROP TABLE IF EXISTS prompt_template;
DROP TABLE IF EXISTS admin_operation_log;
DROP TABLE IF EXISTS security_audit_log;
DROP TABLE IF EXISTS role_permission;
DROP TABLE IF EXISTS admin_user_role;
DROP TABLE IF EXISTS agent_user;
DROP TABLE IF EXISTS admin_user;
DROP TABLE IF EXISTS customer_user;
DROP TABLE IF EXISTS sys_permission;
DROP TABLE IF EXISTS sys_role;
DROP TABLE IF EXISTS llm_model_config;
DROP TABLE IF EXISTS sensitive_word;
DROP TABLE IF EXISTS stat_daily_summary;

SET FOREIGN_KEY_CHECKS = 1;

-- 统一占位密码哈希（演示用，对应明文 password，生产请替换）
-- BCrypt: $2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy

-- =============================================================================
-- 1. 终端用户（C 端）
-- =============================================================================
CREATE TABLE customer_user (
  id              BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT '主键',
  username        VARCHAR(64)  NOT NULL COMMENT '登录名',
  phone           VARCHAR(20)  DEFAULT NULL COMMENT '手机号',
  email           VARCHAR(128) DEFAULT NULL COMMENT '邮箱',
  password_hash   VARCHAR(255) NOT NULL COMMENT '密码哈希',
  nickname        VARCHAR(64)  DEFAULT NULL COMMENT '昵称',
  avatar_url      VARCHAR(512) DEFAULT NULL COMMENT '头像URL',
  status          TINYINT      NOT NULL DEFAULT 0 COMMENT '0正常 1冻结 2注销',
  register_source VARCHAR(32)  DEFAULT 'web' COMMENT '注册来源',
  phone_verified  TINYINT      NOT NULL DEFAULT 0 COMMENT '0未验证 1已验证',
  last_login_at   DATETIME     DEFAULT NULL COMMENT '最近登录时间',
  created_at      DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at      DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  deleted         TINYINT      NOT NULL DEFAULT 0 COMMENT '0否 1逻辑删除',
  UNIQUE KEY uk_customer_username (username),
  KEY idx_customer_phone (phone),
  KEY idx_customer_created (created_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='C端用户';

-- =============================================================================
-- 2. 管理员账号
-- =============================================================================
CREATE TABLE admin_user (
  id              BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  username        VARCHAR(64)  NOT NULL COMMENT '登录名',
  password_hash   VARCHAR(255) NOT NULL,
  real_name       VARCHAR(64)  DEFAULT NULL,
  phone           VARCHAR(20)  DEFAULT NULL,
  email           VARCHAR(128) DEFAULT NULL,
  status          TINYINT      NOT NULL DEFAULT 0 COMMENT '0正常 1禁用',
  last_login_at   DATETIME     DEFAULT NULL,
  created_at      DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at      DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  UNIQUE KEY uk_admin_username (username)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='后台管理员';

-- =============================================================================
-- 3. 人工客服坐席
-- =============================================================================
CREATE TABLE agent_user (
  id            BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  work_no       VARCHAR(32)  NOT NULL COMMENT '工号',
  display_name  VARCHAR(64)  NOT NULL COMMENT '显示名',
  bind_admin_id BIGINT UNSIGNED DEFAULT NULL COMMENT '关联管理员ID',
  skill_group   VARCHAR(64)  DEFAULT 'default' COMMENT '技能组',
  status        TINYINT      NOT NULL DEFAULT 0 COMMENT '0在职 1停用',
  online_status TINYINT      NOT NULL DEFAULT 0 COMMENT '0离线 1在线 2忙碌',
  max_concurrent INT         NOT NULL DEFAULT 3 COMMENT '最大并发会话数',
  created_at    DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  UNIQUE KEY uk_agent_work_no (work_no),
  KEY idx_agent_admin (bind_admin_id),
  CONSTRAINT fk_agent_admin FOREIGN KEY (bind_admin_id) REFERENCES admin_user (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='人工客服坐席';

-- =============================================================================
-- 4. RBAC：角色 / 权限
-- =============================================================================
CREATE TABLE sys_role (
  id          BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  role_code   VARCHAR(64)  NOT NULL COMMENT '角色编码',
  role_name   VARCHAR(64)  NOT NULL COMMENT '角色名称',
  description VARCHAR(256) DEFAULT NULL,
  status      TINYINT      NOT NULL DEFAULT 0 COMMENT '0启用 1停用',
  created_at  DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  UNIQUE KEY uk_role_code (role_code)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='角色';

CREATE TABLE sys_permission (
  id          BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  perm_code   VARCHAR(128) NOT NULL COMMENT '权限标识',
  perm_name   VARCHAR(128) NOT NULL COMMENT '权限名称',
  parent_id   BIGINT UNSIGNED DEFAULT 0 COMMENT '父级ID',
  perm_type   TINYINT      NOT NULL DEFAULT 1 COMMENT '1菜单 2按钮 3接口',
  sort_order  INT          NOT NULL DEFAULT 0,
  created_at  DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  UNIQUE KEY uk_perm_code (perm_code)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='权限';

CREATE TABLE admin_user_role (
  id        BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  admin_id  BIGINT UNSIGNED NOT NULL,
  role_id   BIGINT UNSIGNED NOT NULL,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  UNIQUE KEY uk_admin_role (admin_id, role_id),
  KEY idx_aur_role (role_id),
  CONSTRAINT fk_aur_admin FOREIGN KEY (admin_id) REFERENCES admin_user (id),
  CONSTRAINT fk_aur_role FOREIGN KEY (role_id) REFERENCES sys_role (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='管理员-角色';

CREATE TABLE role_permission (
  id            BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  role_id       BIGINT UNSIGNED NOT NULL,
  permission_id BIGINT UNSIGNED NOT NULL,
  created_at    DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  UNIQUE KEY uk_role_perm (role_id, permission_id),
  KEY idx_rp_perm (permission_id),
  CONSTRAINT fk_rp_role FOREIGN KEY (role_id) REFERENCES sys_role (id),
  CONSTRAINT fk_rp_perm FOREIGN KEY (permission_id) REFERENCES sys_permission (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='角色-权限';

-- =============================================================================
-- 5. 知识库
-- =============================================================================
CREATE TABLE knowledge_category (
  id          BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  parent_id   BIGINT UNSIGNED DEFAULT 0 COMMENT '父分类ID',
  name        VARCHAR(128) NOT NULL,
  sort_order  INT          NOT NULL DEFAULT 0,
  status      TINYINT      NOT NULL DEFAULT 0 COMMENT '0启用 1停用',
  created_at  DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  KEY idx_kc_parent (parent_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='知识分类';

CREATE TABLE knowledge_document (
  id            BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  category_id   BIGINT UNSIGNED NOT NULL,
  title         VARCHAR(256) NOT NULL,
  doc_type      VARCHAR(32)  NOT NULL DEFAULT 'faq' COMMENT 'faq/file/html',
  content       MEDIUMTEXT   COMMENT '正文或摘要',
  file_url      VARCHAR(512) DEFAULT NULL,
  status        TINYINT      NOT NULL DEFAULT 0 COMMENT '0草稿 1已发布 2下线',
  version_no    INT          NOT NULL DEFAULT 1,
  published_at  DATETIME     DEFAULT NULL,
  created_by    BIGINT UNSIGNED DEFAULT NULL COMMENT '管理员ID',
  created_at    DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at    DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  KEY idx_kd_cat (category_id),
  KEY idx_kd_status (status),
  CONSTRAINT fk_kd_cat FOREIGN KEY (category_id) REFERENCES knowledge_category (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='知识文档';

CREATE TABLE knowledge_chunk (
  id           BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  document_id  BIGINT UNSIGNED NOT NULL,
  chunk_index  INT            NOT NULL DEFAULT 0 COMMENT '切片序号',
  content      TEXT           NOT NULL,
  token_count  INT            DEFAULT NULL,
  created_at   DATETIME       NOT NULL DEFAULT CURRENT_TIMESTAMP,
  KEY idx_kchunk_doc (document_id),
  CONSTRAINT fk_kchunk_doc FOREIGN KEY (document_id) REFERENCES knowledge_document (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='知识切片';

CREATE TABLE kb_embedding_meta (
  id             BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  chunk_id       BIGINT UNSIGNED NOT NULL,
  model_name     VARCHAR(128) NOT NULL COMMENT 'Embedding模型名',
  embedding_dim  INT            NOT NULL DEFAULT 1536,
  vector_json    JSON           NOT NULL COMMENT '向量JSON(演示为短向量)',
  created_at     DATETIME       NOT NULL DEFAULT CURRENT_TIMESTAMP,
  UNIQUE KEY uk_emb_chunk_model (chunk_id, model_name),
  CONSTRAINT fk_emb_chunk FOREIGN KEY (chunk_id) REFERENCES knowledge_chunk (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='切片向量元数据';

-- =============================================================================
-- 6. 会话与消息
-- =============================================================================
CREATE TABLE chat_session (
  id               BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  user_id          BIGINT UNSIGNED DEFAULT NULL COMMENT 'C端用户，匿名为空',
  anonymous_token  VARCHAR(64)  DEFAULT NULL COMMENT '匿名访客标识',
  channel          VARCHAR(32)  NOT NULL DEFAULT 'web' COMMENT 'web/h5/mini',
  status           TINYINT      NOT NULL DEFAULT 0 COMMENT '0进行中 1已结束 2转人工中 3已关闭',
  title            VARCHAR(256) DEFAULT NULL COMMENT '会话标题/首句摘要',
  robot_mode       VARCHAR(32)  DEFAULT 'rag' COMMENT 'rag/general',
  started_at       DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  ended_at         DATETIME     DEFAULT NULL,
  last_message_at  DATETIME     DEFAULT NULL,
  KEY idx_cs_user (user_id),
  KEY idx_cs_anon (anonymous_token),
  KEY idx_cs_started (started_at),
  CONSTRAINT fk_cs_user FOREIGN KEY (user_id) REFERENCES customer_user (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='聊天会话';

CREATE TABLE chat_message (
  id            BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  session_id    BIGINT UNSIGNED NOT NULL,
  role_type     VARCHAR(16)  NOT NULL COMMENT 'user/assistant/system/agent',
  content       MEDIUMTEXT   NOT NULL,
  metadata_json JSON         DEFAULT NULL COMMENT '引用来源、工具调用等',
  token_usage   INT          DEFAULT NULL,
  created_at    DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  KEY idx_cm_session (session_id),
  CONSTRAINT fk_cm_session FOREIGN KEY (session_id) REFERENCES chat_session (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='聊天消息';

-- =============================================================================
-- 7. Prompt 模板与版本
-- =============================================================================
CREATE TABLE prompt_template (
  id            BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  scene_code    VARCHAR(64)  NOT NULL COMMENT '场景编码',
  name          VARCHAR(128) NOT NULL,
  content       MEDIUMTEXT   NOT NULL,
  variables_json JSON        DEFAULT NULL COMMENT '占位变量说明',
  status        TINYINT      NOT NULL DEFAULT 0 COMMENT '0启用 1停用',
  current_version INT      NOT NULL DEFAULT 1,
  created_by    BIGINT UNSIGNED DEFAULT NULL,
  created_at    DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at    DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  KEY idx_pt_scene (scene_code)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Prompt模板';

CREATE TABLE prompt_template_history (
  id            BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  template_id   BIGINT UNSIGNED NOT NULL,
  version_no    INT            NOT NULL,
  content       MEDIUMTEXT     NOT NULL,
  changed_by    BIGINT UNSIGNED DEFAULT NULL,
  changed_at    DATETIME       NOT NULL DEFAULT CURRENT_TIMESTAMP,
  remark        VARCHAR(512)   DEFAULT NULL,
  KEY idx_pth_tpl (template_id),
  CONSTRAINT fk_pth_tpl FOREIGN KEY (template_id) REFERENCES prompt_template (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Prompt版本历史';

-- =============================================================================
-- 8. 大模型配置与敏感词
-- =============================================================================
CREATE TABLE llm_model_config (
  id            BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  config_name   VARCHAR(128) NOT NULL COMMENT '配置名称',
  provider      VARCHAR(64)  NOT NULL COMMENT 'openai/azure/local等',
  model_name    VARCHAR(128) NOT NULL,
  api_key_ref   VARCHAR(256) DEFAULT NULL COMMENT '密钥引用/脱敏ID，非明文',
  embedding_model VARCHAR(128) DEFAULT NULL,
  temperature   DECIMAL(4,3) NOT NULL DEFAULT 0.700,
  top_p         DECIMAL(4,3) NOT NULL DEFAULT 1.000,
  max_tokens    INT          NOT NULL DEFAULT 2048,
  timeout_ms    INT          NOT NULL DEFAULT 60000,
  is_default_chat TINYINT    NOT NULL DEFAULT 0,
  is_default_embed TINYINT   NOT NULL DEFAULT 0,
  status        TINYINT      NOT NULL DEFAULT 0 COMMENT '0启用 1停用',
  created_at    DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at    DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  KEY idx_llm_default (is_default_chat, status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='LLM与Embedding配置';

CREATE TABLE sensitive_word (
  id          BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  word        VARCHAR(128) NOT NULL,
  category    VARCHAR(64)  DEFAULT 'general' COMMENT '分类',
  level       TINYINT      NOT NULL DEFAULT 1 COMMENT '1低 2中 3高',
  action      VARCHAR(32)  NOT NULL DEFAULT 'block' COMMENT 'block/replace/warn/transfer',
  replace_to  VARCHAR(128) DEFAULT NULL,
  status      TINYINT      NOT NULL DEFAULT 0,
  created_at  DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  KEY idx_sw_word (word)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='敏感词';

-- =============================================================================
-- 9. 审计与运营日志
-- =============================================================================
CREATE TABLE security_audit_log (
  id          BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  user_type   VARCHAR(16)  NOT NULL COMMENT 'customer/admin/agent',
  user_id     BIGINT UNSIGNED DEFAULT NULL,
  event_type  VARCHAR(64)  NOT NULL COMMENT 'login/logout/fail等',
  ip          VARCHAR(64)  DEFAULT NULL,
  user_agent  VARCHAR(512) DEFAULT NULL,
  result      VARCHAR(32)  NOT NULL DEFAULT 'success',
  detail_json JSON         DEFAULT NULL,
  created_at  DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  KEY idx_sal_user (user_type, user_id),
  KEY idx_sal_time (created_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='安全审计日志';

CREATE TABLE admin_operation_log (
  id            BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  admin_id      BIGINT UNSIGNED NOT NULL,
  module        VARCHAR(64)  NOT NULL,
  action        VARCHAR(64)  NOT NULL,
  resource_type VARCHAR(64)  DEFAULT NULL,
  resource_id   VARCHAR(64)  DEFAULT NULL,
  ip            VARCHAR(64)  DEFAULT NULL,
  before_json   JSON         DEFAULT NULL,
  after_json    JSON         DEFAULT NULL,
  created_at    DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  KEY idx_aol_admin (admin_id),
  KEY idx_aol_time (created_at),
  CONSTRAINT fk_aol_admin FOREIGN KEY (admin_id) REFERENCES admin_user (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='管理端操作日志';

-- =============================================================================
-- 10. 满意度与转人工
-- =============================================================================
CREATE TABLE customer_feedback (
  id          BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  session_id  BIGINT UNSIGNED NOT NULL,
  user_id     BIGINT UNSIGNED DEFAULT NULL,
  rating      TINYINT      NOT NULL COMMENT '1-5星',
  comment     VARCHAR(1024) DEFAULT NULL,
  tags        VARCHAR(256)  DEFAULT NULL COMMENT '逗号分隔标签',
  created_at  DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  KEY idx_cf_session (session_id),
  CONSTRAINT fk_cf_session FOREIGN KEY (session_id) REFERENCES chat_session (id),
  CONSTRAINT fk_cf_user FOREIGN KEY (user_id) REFERENCES customer_user (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='用户评价';

CREATE TABLE human_transfer_record (
  id             BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  session_id     BIGINT UNSIGNED NOT NULL,
  agent_id       BIGINT UNSIGNED DEFAULT NULL,
  queue_position INT            DEFAULT NULL,
  status         VARCHAR(32)    NOT NULL DEFAULT 'queued' COMMENT 'queued/picked/closed/cancel',
  reason         VARCHAR(256)   DEFAULT NULL,
  created_at     DATETIME       NOT NULL DEFAULT CURRENT_TIMESTAMP,
  picked_at      DATETIME       DEFAULT NULL,
  closed_at      DATETIME       DEFAULT NULL,
  KEY idx_ht_session (session_id),
  KEY idx_ht_agent (agent_id),
  CONSTRAINT fk_ht_session FOREIGN KEY (session_id) REFERENCES chat_session (id),
  CONSTRAINT fk_ht_agent FOREIGN KEY (agent_id) REFERENCES agent_user (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='转人工记录';

-- =============================================================================
-- 11. 日统计（管理端报表）
-- =============================================================================
CREATE TABLE stat_daily_summary (
  id                  BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  stat_date           DATE         NOT NULL,
  channel             VARCHAR(32)  NOT NULL DEFAULT 'all',
  session_count       INT          NOT NULL DEFAULT 0,
  message_count       INT          NOT NULL DEFAULT 0,
  user_message_count  INT          NOT NULL DEFAULT 0,
  transfer_count      INT          NOT NULL DEFAULT 0,
  avg_response_ms     INT          DEFAULT NULL,
  satisfaction_avg    DECIMAL(4,2) DEFAULT NULL COMMENT '平均分',
  created_at          DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  UNIQUE KEY uk_stat_day_ch (stat_date, channel)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='日汇总统计';

-- =============================================================================
-- 示例数据（每表不少于 10 条）
-- 密码哈希均为演示用 BCrypt: 明文 password
-- =============================================================================

SET @pwd := '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy';

INSERT INTO customer_user (id, username, phone, email, password_hash, nickname, status, register_source, phone_verified, last_login_at, created_at) VALUES
(1, 'zhangsan', '13800001001', 'zs@example.com', @pwd, '张三', 0, 'web', 1, '2026-03-30 09:00:00', '2026-01-10 10:00:00'),
(2, 'lisi', '13800001002', 'ls@example.com', @pwd, '李四', 0, 'h5', 1, '2026-03-29 14:20:00', '2026-02-01 11:00:00'),
(3, 'wangwu', '13800001003', 'ww@example.com', @pwd, '王五', 0, 'web', 0, NULL, '2026-02-15 08:30:00'),
(4, 'zhaoliu', '13800001004', NULL, @pwd, '赵六', 0, 'mini', 1, '2026-03-28 18:00:00', '2026-03-01 12:00:00'),
(5, 'sunqi', '13800001005', 'sq@example.com', @pwd, '孙七', 0, 'web', 1, '2026-03-31 08:10:00', '2026-03-05 09:00:00'),
(6, 'zhouba', '13800001006', 'zb@example.com', @pwd, '周八', 1, 'web', 1, '2026-03-01 10:00:00', '2025-12-20 10:00:00'),
(7, 'wujiu', '13800001007', NULL, @pwd, '吴九', 0, 'web', 0, '2026-03-27 16:00:00', '2026-03-10 14:00:00'),
(8, 'zhengshi', '13800001008', 'zs2@example.com', @pwd, '郑十', 0, 'h5', 1, '2026-03-30 20:00:00', '2026-03-12 16:00:00'),
(9, 'testuser09', '13800001009', 'tu9@example.com', @pwd, '测试用户9', 0, 'web', 1, '2026-03-29 11:11:00', '2026-03-15 10:00:00'),
(10, 'testuser10', '13800001010', 'tu10@example.com', @pwd, '测试用户10', 0, 'web', 1, '2026-03-30 22:00:00', '2026-03-20 10:00:00');

INSERT INTO admin_user (id, username, password_hash, real_name, phone, email, status, last_login_at, created_at) VALUES
(1, 'admin', @pwd, '系统管理员', '13900001001', 'admin@company.com', 0, '2026-03-31 07:00:00', '2026-01-01 00:00:00'),
(2, 'operator01', @pwd, '运营小王', '13900001002', 'op1@company.com', 0, '2026-03-30 18:00:00', '2026-01-05 10:00:00'),
(3, 'operator02', @pwd, '运营小李', '13900001003', 'op2@company.com', 0, '2026-03-29 09:00:00', '2026-01-05 10:00:00'),
(4, 'kb_mgr', @pwd, '知识库主管', '13900001004', 'kb@company.com', 0, '2026-03-28 17:00:00', '2026-02-01 10:00:00'),
(5, 'auditor', @pwd, '审计员', '13900001005', 'audit@company.com', 0, '2026-03-27 12:00:00', '2026-02-10 10:00:00'),
(6, 'devops', @pwd, '运维', '13900001006', 'dev@company.com', 0, '2026-03-31 06:30:00', '2026-02-15 10:00:00'),
(7, 'readonly', @pwd, '只读账号', '13900001007', 'ro@company.com', 0, '2026-03-20 10:00:00', '2026-03-01 10:00:00'),
(8, 'agent_mgr', @pwd, '客服主管', '13900001008', 'am@company.com', 0, '2026-03-30 10:00:00', '2026-03-10 10:00:00'),
(9, 'analyst', @pwd, '数据分析师', '13900001009', 'an@company.com', 0, '2026-03-29 15:00:00', '2026-03-15 10:00:00'),
(10, 'temp_admin', @pwd, '临时管理员', '13900001010', 'tmp@company.com', 1, NULL, '2026-03-25 10:00:00');

INSERT INTO agent_user (id, work_no, display_name, bind_admin_id, skill_group, status, online_status, max_concurrent, created_at) VALUES
(1, 'A1001', '坐席-刘芳', 8, '售前', 0, 1, 3, '2026-01-10 10:00:00'),
(2, 'A1002', '坐席-陈强', 8, '售后', 0, 1, 3, '2026-01-10 10:00:00'),
(3, 'A1003', '坐席-杨敏', NULL, '投诉', 0, 0, 2, '2026-02-01 10:00:00'),
(4, 'A1004', '坐席-赵磊', NULL, '售前', 0, 2, 4, '2026-02-01 10:00:00'),
(5, 'A1005', '坐席-黄婷', NULL, '售后', 0, 1, 3, '2026-02-15 10:00:00'),
(6, 'A1006', '坐席-吴刚', NULL, 'default', 0, 0, 3, '2026-03-01 10:00:00'),
(7, 'A1007', '坐席-徐丽', NULL, '售前', 0, 1, 3, '2026-03-01 10:00:00'),
(8, 'A1008', '坐席-马超', NULL, '售后', 0, 0, 3, '2026-03-05 10:00:00'),
(9, 'A1009', '坐席-丁悦', NULL, '投诉', 0, 1, 2, '2026-03-10 10:00:00'),
(10, 'A1010', '坐席-高远', NULL, 'default', 1, 0, 3, '2026-03-15 10:00:00');

INSERT INTO sys_role (id, role_code, role_name, description, status, created_at) VALUES
(1, 'SUPER_ADMIN', '超级管理员', '全部权限', 0, '2026-01-01 00:00:00'),
(2, 'KB_EDITOR', '知识编辑', '维护知识库', 0, '2026-01-01 00:00:00'),
(3, 'KB_AUDITOR', '知识审核', '审核发布', 0, '2026-01-01 00:00:00'),
(4, 'OPS_MONITOR', '运营监控', '会话与监控', 0, '2026-01-01 00:00:00'),
(5, 'MODEL_ADMIN', '模型配置', '模型与Prompt', 0, '2026-01-01 00:00:00'),
(6, 'RISK_ADMIN', '风控管理员', '敏感词与策略', 0, '2026-01-01 00:00:00'),
(7, 'ANALYST', '数据分析', '报表只读', 0, '2026-01-01 00:00:00'),
(8, 'AGENT_LEAD', '客服主管', '坐席与转接', 0, '2026-01-01 00:00:00'),
(9, 'READONLY', '只读', '仅查看', 0, '2026-01-01 00:00:00'),
(10, 'DEPRECATED', '废弃角色', '历史占位', 1, '2026-01-01 00:00:00');

INSERT INTO sys_permission (id, perm_code, perm_name, parent_id, perm_type, sort_order, created_at) VALUES
(1, 'kb:doc:view', '知识文档查看', 0, 1, 10, '2026-01-01 00:00:00'),
(2, 'kb:doc:edit', '知识文档编辑', 0, 1, 20, '2026-01-01 00:00:00'),
(3, 'kb:doc:publish', '知识发布', 0, 2, 30, '2026-01-01 00:00:00'),
(4, 'chat:session:view', '会话查看', 0, 1, 40, '2026-01-01 00:00:00'),
(5, 'chat:session:export', '会话导出', 0, 2, 50, '2026-01-01 00:00:00'),
(6, 'model:config', '模型配置', 0, 1, 60, '2026-01-01 00:00:00'),
(7, 'prompt:manage', 'Prompt管理', 0, 1, 70, '2026-01-01 00:00:00'),
(8, 'risk:word', '敏感词管理', 0, 1, 80, '2026-01-01 00:00:00'),
(9, 'stat:report', '统计报表', 0, 1, 90, '2026-01-01 00:00:00'),
(10, 'sys:user:manage', '管理员账号', 0, 1, 100, '2026-01-01 00:00:00');

INSERT INTO admin_user_role (id, admin_id, role_id, created_at) VALUES
(1, 1, 1, '2026-01-01 00:00:00'),
(2, 2, 4, '2026-01-05 10:00:00'),
(3, 3, 4, '2026-01-05 10:00:00'),
(4, 4, 2, '2026-02-01 10:00:00'),
(5, 5, 3, '2026-02-10 10:00:00'),
(6, 6, 5, '2026-02-15 10:00:00'),
(7, 7, 9, '2026-03-01 10:00:00'),
(8, 8, 8, '2026-03-10 10:00:00'),
(9, 9, 7, '2026-03-15 10:00:00'),
(10, 10, 2, '2026-03-25 10:00:00');

INSERT INTO role_permission (id, role_id, permission_id, created_at) VALUES
(1, 1, 1, '2026-01-01 00:00:00'),
(2, 1, 2, '2026-01-01 00:00:00'),
(3, 1, 3, '2026-01-01 00:00:00'),
(4, 1, 4, '2026-01-01 00:00:00'),
(5, 1, 5, '2026-01-01 00:00:00'),
(6, 1, 6, '2026-01-01 00:00:00'),
(7, 1, 7, '2026-01-01 00:00:00'),
(8, 1, 8, '2026-01-01 00:00:00'),
(9, 1, 9, '2026-01-01 00:00:00'),
(10, 1, 10, '2026-01-01 00:00:00');

INSERT INTO knowledge_category (id, parent_id, name, sort_order, status, created_at) VALUES
(1, 0, '账户与安全', 1, 0, '2026-01-01 00:00:00'),
(2, 0, '订单与物流', 2, 0, '2026-01-01 00:00:00'),
(3, 0, '支付与发票', 3, 0, '2026-01-01 00:00:00'),
(4, 0, '退换货', 4, 0, '2026-01-01 00:00:00'),
(5, 0, '会员权益', 5, 0, '2026-01-01 00:00:00'),
(6, 2, '发货时效', 1, 0, '2026-01-01 00:00:00'),
(7, 2, '物流查询', 2, 0, '2026-01-01 00:00:00'),
(8, 0, '技术支持', 6, 0, '2026-01-01 00:00:00'),
(9, 0, '常见问题', 7, 0, '2026-01-01 00:00:00'),
(10, 0, '其他', 99, 0, '2026-01-01 00:00:00');

INSERT INTO knowledge_document (id, category_id, title, doc_type, content, status, version_no, published_at, created_by, created_at) VALUES
(1, 1, '如何修改登录密码', 'faq', '进入个人中心-安全设置-修改密码，按提示完成验证后即可修改。', 1, 1, '2026-02-01 10:00:00', 1, '2026-02-01 10:00:00'),
(2, 1, '账号锁定怎么办', 'faq', '连续输错密码将临时锁定，请等待30分钟或通过手机验证码找回。', 1, 1, '2026-02-01 10:00:00', 1, '2026-02-01 10:00:00'),
(3, 2, '下单后多久发货', 'faq', '现货订单一般48小时内发货，预售以商品页说明为准。', 1, 1, '2026-02-05 10:00:00', 4, '2026-02-05 10:00:00'),
(4, 7, '如何查询物流', 'faq', '订单详情页可查看物流单号，复制到快递公司官网或小程序查询。', 1, 1, '2026-02-05 10:00:00', 4, '2026-02-05 10:00:00'),
(5, 3, '发票开具说明', 'faq', '订单完成后可在订单页申请电子发票，信息提交后1-3个工作日开具。', 1, 1, '2026-02-10 10:00:00', 4, '2026-02-10 10:00:00'),
(6, 4, '七天无理由规则', 'faq', '符合商品页标注支持无理由的商品，签收7天内可申请，需保持完好。', 1, 1, '2026-02-12 10:00:00', 4, '2026-02-12 10:00:00'),
(7, 5, '会员等级说明', 'faq', '根据近12个月消费金额划分等级，不同等级享受不同折扣与积分倍率。', 1, 1, '2026-02-15 10:00:00', 2, '2026-02-15 10:00:00'),
(8, 8, '无法打开页面', 'faq', '请清除浏览器缓存、更换网络或更新App至最新版本后重试。', 1, 1, '2026-02-18 10:00:00', 2, '2026-02-18 10:00:00'),
(9, 9, '客服服务时间', 'faq', '智能客服7×24小时；人工客服工作日9:00-21:00。', 1, 1, '2026-02-20 10:00:00', 2, '2026-02-20 10:00:00'),
(10, 10, '联系我们', 'faq', '可通过在线客服、官方邮箱或微博私信联系，非紧急建议留言。', 1, 1, '2026-02-22 10:00:00', 2, '2026-02-22 10:00:00');

INSERT INTO knowledge_chunk (id, document_id, chunk_index, content, token_count, created_at) VALUES
(1, 1, 0, '进入个人中心-安全设置-修改密码，按提示完成验证后即可修改。', 32, '2026-02-01 10:00:00'),
(2, 2, 0, '连续输错密码将临时锁定，请等待30分钟或通过手机验证码找回。', 28, '2026-02-01 10:00:00'),
(3, 3, 0, '现货订单一般48小时内发货，预售以商品页说明为准。', 24, '2026-02-05 10:00:00'),
(4, 4, 0, '订单详情页可查看物流单号，复制到快递公司官网或小程序查询。', 30, '2026-02-05 10:00:00'),
(5, 5, 0, '订单完成后可在订单页申请电子发票，信息提交后1-3个工作日开具。', 32, '2026-02-10 10:00:00'),
(6, 6, 0, '符合商品页标注支持无理由的商品，签收7天内可申请，需保持完好。', 34, '2026-02-12 10:00:00'),
(7, 7, 0, '根据近12个月消费金额划分等级，不同等级享受不同折扣与积分倍率。', 34, '2026-02-15 10:00:00'),
(8, 8, 0, '请清除浏览器缓存、更换网络或更新App至最新版本后重试。', 28, '2026-02-18 10:00:00'),
(9, 9, 0, '智能客服7×24小时；人工客服工作日9:00-21:00。', 22, '2026-02-20 10:00:00'),
(10, 10, 0, '可通过在线客服、官方邮箱或微博私信联系，非紧急建议留言。', 30, '2026-02-22 10:00:00');

INSERT INTO kb_embedding_meta (id, chunk_id, model_name, embedding_dim, vector_json, created_at) VALUES
(1, 1, 'text-embedding-3-small', 16, JSON_ARRAY(0.01,0.02,0.03,0.04,0.05,0.06,0.07,0.08,0.09,0.10,0.11,0.12,0.13,0.14,0.15,0.16), '2026-02-01 10:00:00'),
(2, 2, 'text-embedding-3-small', 16, JSON_ARRAY(0.11,0.12,0.13,0.14,0.15,0.16,0.17,0.18,0.19,0.20,0.21,0.22,0.23,0.24,0.25,0.26), '2026-02-01 10:00:00'),
(3, 3, 'text-embedding-3-small', 16, JSON_ARRAY(0.21,0.22,0.23,0.24,0.25,0.26,0.27,0.28,0.29,0.30,0.31,0.32,0.33,0.34,0.35,0.36), '2026-02-05 10:00:00'),
(4, 4, 'text-embedding-3-small', 16, JSON_ARRAY(0.31,0.32,0.33,0.34,0.35,0.36,0.37,0.38,0.39,0.40,0.41,0.42,0.43,0.44,0.45,0.46), '2026-02-05 10:00:00'),
(5, 5, 'text-embedding-3-small', 16, JSON_ARRAY(0.41,0.42,0.43,0.44,0.45,0.46,0.47,0.48,0.49,0.50,0.51,0.52,0.53,0.54,0.55,0.56), '2026-02-10 10:00:00'),
(6, 6, 'text-embedding-3-small', 16, JSON_ARRAY(0.51,0.52,0.53,0.54,0.55,0.56,0.57,0.58,0.59,0.60,0.61,0.62,0.63,0.64,0.65,0.66), '2026-02-12 10:00:00'),
(7, 7, 'text-embedding-3-small', 16, JSON_ARRAY(0.61,0.62,0.63,0.64,0.65,0.66,0.67,0.68,0.69,0.70,0.71,0.72,0.73,0.74,0.75,0.76), '2026-02-15 10:00:00'),
(8, 8, 'text-embedding-3-small', 16, JSON_ARRAY(0.71,0.72,0.73,0.74,0.75,0.76,0.77,0.78,0.79,0.80,0.81,0.82,0.83,0.84,0.85,0.86), '2026-02-18 10:00:00'),
(9, 9, 'text-embedding-3-small', 16, JSON_ARRAY(0.81,0.82,0.83,0.84,0.85,0.86,0.87,0.88,0.89,0.90,0.91,0.92,0.93,0.94,0.95,0.96), '2026-02-20 10:00:00'),
(10, 10, 'text-embedding-3-small', 16, JSON_ARRAY(0.91,0.92,0.93,0.94,0.95,0.96,0.97,0.98,0.99,1.00,0.01,0.02,0.03,0.04,0.05,0.06), '2026-02-22 10:00:00');

INSERT INTO chat_session (id, user_id, anonymous_token, channel, status, title, robot_mode, started_at, last_message_at) VALUES
(1, 1, NULL, 'web', 1, '咨询修改密码', 'rag', '2026-03-30 10:00:00', '2026-03-30 10:05:00'),
(2, 2, NULL, 'h5', 1, '物流多久到', 'rag', '2026-03-29 14:00:00', '2026-03-29 14:10:00'),
(3, NULL, 'anon_uuid_001', 'web', 0, NULL, 'rag', '2026-03-31 08:00:00', '2026-03-31 08:02:00'),
(4, 3, NULL, 'web', 1, '发票问题', 'rag', '2026-03-28 16:00:00', '2026-03-28 16:20:00'),
(5, 5, NULL, 'mini', 2, '转人工排队', 'rag', '2026-03-27 11:00:00', '2026-03-27 11:30:00'),
(6, 8, NULL, 'web', 1, '会员等级', 'rag', '2026-03-26 09:00:00', '2026-03-26 09:15:00'),
(7, 9, NULL, 'h5', 1, '退换货', 'rag', '2026-03-25 20:00:00', '2026-03-25 20:08:00'),
(8, 10, NULL, 'web', 0, '技术支持', 'rag', '2026-03-31 09:30:00', '2026-03-31 09:35:00'),
(9, 4, NULL, 'web', 1, '发货时间', 'rag', '2026-03-24 13:00:00', '2026-03-24 13:05:00'),
(10, 7, NULL, 'web', 1, '联系渠道', 'rag', '2026-03-23 18:00:00', '2026-03-23 18:12:00');

INSERT INTO chat_message (id, session_id, role_type, content, metadata_json, token_usage, created_at) VALUES
(1, 1, 'user', '怎么修改登录密码？', JSON_OBJECT('client','web'), 12, '2026-03-30 10:00:00'),
(2, 1, 'assistant', '您可以在个人中心-安全设置中修改密码，需完成身份验证。', JSON_OBJECT('refs', JSON_ARRAY('doc:1')), 45, '2026-03-30 10:00:30'),
(3, 2, 'user', '下单后几天发货？', NULL, 10, '2026-03-29 14:00:00'),
(4, 2, 'assistant', '现货订单一般48小时内发货，预售请参考商品页说明。', JSON_OBJECT('refs', JSON_ARRAY('doc:3')), 40, '2026-03-29 14:01:00'),
(5, 3, 'user', '运费谁承担？', NULL, 8, '2026-03-31 08:00:00'),
(6, 3, 'assistant', '请以订单结算页与活动规则为准，一般满额包邮。', NULL, 35, '2026-03-31 08:01:00'),
(7, 4, 'user', '如何开发票？', NULL, 8, '2026-03-28 16:00:00'),
(8, 4, 'assistant', '订单完成后可在订单页申请电子发票。', JSON_OBJECT('refs', JSON_ARRAY('doc:5')), 30, '2026-03-28 16:01:00'),
(9, 5, 'user', '我要找人工', NULL, 6, '2026-03-27 11:00:00'),
(10, 5, 'system', '已为您接入排队，请稍候。', JSON_OBJECT('event','transfer'), 15, '2026-03-27 11:00:10'),
(11, 6, 'user', '会员有什么权益？', NULL, 10, '2026-03-26 09:00:00'),
(12, 6, 'assistant', '不同会员等级享受不同折扣与积分倍率。', JSON_OBJECT('refs', JSON_ARRAY('doc:7')), 38, '2026-03-26 09:01:00');

INSERT INTO prompt_template (id, scene_code, name, content, variables_json, status, current_version, created_by, created_at) VALUES
(1, 'rag_system', 'RAG系统提示', '你是智能客服，仅根据【知识】回答，无法确定时请说明并建议转人工。', JSON_OBJECT('vars', JSON_ARRAY('knowledge','history')), 0, 2, 1, '2026-01-01 00:00:00'),
(2, 'welcome', '欢迎语', '您好，我是智能助手，请问有什么可以帮您？', NULL, 0, 1, 1, '2026-01-01 00:00:00'),
(3, 'refuse', '无依据拒答', '当前知识库未收录该问题，为您转接人工客服。', NULL, 0, 1, 1, '2026-01-01 00:00:00'),
(4, 'transfer', '转人工提示', '正在为您转接人工客服，请稍候。', NULL, 0, 1, 1, '2026-01-01 00:00:00'),
(5, 'summary', '会话摘要', '请用三句话总结用户诉求与已处理项。', NULL, 0, 1, 6, '2026-02-01 00:00:00'),
(6, 'safety', '安全补充', '禁止输出违法、侵权与隐私内容。', NULL, 0, 1, 1, '2026-02-01 00:00:00'),
(7, 'intent', '意图澄清', '您是指订单问题还是售后问题？', NULL, 0, 1, 2, '2026-02-10 00:00:00'),
(8, 'product', '商品咨询', '请结合商品页参数与库存状态回答用户。', NULL, 0, 1, 2, '2026-02-10 00:00:00'),
(9, 'vip', '会员话术', '会员权益以活动页公示为准。', NULL, 0, 1, 2, '2026-02-15 00:00:00'),
(10, 'offline', '降级话术', '系统繁忙，请稍后再试或留言。', NULL, 0, 1, 6, '2026-03-01 00:00:00');

INSERT INTO prompt_template_history (id, template_id, version_no, content, changed_by, changed_at, remark) VALUES
(1, 1, 1, '你是客服助手，请友好回答。', 1, '2026-01-01 00:00:00', '初版'),
(2, 1, 2, '你是智能客服，仅根据【知识】回答，无法确定时请说明并建议转人工。', 1, '2026-02-01 10:00:00', '加入RAG约束'),
(3, 2, 1, '您好，请问有什么可以帮您？', 1, '2026-01-01 00:00:00', '初版'),
(4, 3, 1, '我不知道。', 1, '2026-01-01 00:00:00', '初版'),
(5, 4, 1, '转人工中', 1, '2026-01-01 00:00:00', '初版'),
(6, 5, 1, '请总结会话。', 6, '2026-02-01 00:00:00', '初版'),
(7, 6, 1, '注意安全。', 1, '2026-02-01 00:00:00', '初版'),
(8, 7, 1, '请选择问题类型。', 2, '2026-02-10 00:00:00', '初版'),
(9, 8, 1, '回答商品问题。', 2, '2026-02-10 00:00:00', '初版'),
(10, 9, 1, '会员说明。', 2, '2026-02-15 00:00:00', '初版');

INSERT INTO llm_model_config (id, config_name, provider, model_name, api_key_ref, embedding_model, temperature, top_p, max_tokens, timeout_ms, is_default_chat, is_default_embed, status, created_at) VALUES
(1, '生产-对话主模型', 'openai', 'gpt-4o-mini', 'vault:openai_main', 'text-embedding-3-small', 0.700, 1.000, 2048, 60000, 1, 1, 0, '2026-01-01 00:00:00'),
(2, '备用-对话', 'openai', 'gpt-3.5-turbo', 'vault:openai_backup', NULL, 0.600, 1.000, 1024, 45000, 0, 0, 0, '2026-01-01 00:00:00'),
(3, '本地测试-Chat', 'local', 'qwen2.5-7b', NULL, NULL, 0.800, 0.950, 4096, 120000, 0, 0, 1, '2026-02-01 00:00:00'),
(4, 'Azure-企业', 'azure', 'gpt-4o', 'vault:azure_1', 'text-embedding-ada-002', 0.700, 1.000, 4096, 90000, 0, 0, 0, '2026-02-05 00:00:00'),
(5, 'Embedding专用', 'openai', 'dummy', 'vault:openai_emb', 'text-embedding-3-large', 0.000, 1.000, 0, 30000, 0, 0, 0, '2026-02-10 00:00:00'),
(6, '高创意营销', 'openai', 'gpt-4o', 'vault:openai_main', NULL, 0.900, 0.950, 2048, 60000, 0, 0, 0, '2026-02-12 00:00:00'),
(7, '低延迟', 'openai', 'gpt-4o-mini', 'vault:openai_main', NULL, 0.300, 0.900, 512, 20000, 0, 0, 0, '2026-02-15 00:00:00'),
(8, '长文本', 'openai', 'gpt-4-turbo', 'vault:openai_main', NULL, 0.700, 1.000, 8192, 120000, 0, 0, 1, '2026-03-01 00:00:00'),
(9, '试用-DeepSeek', 'deepseek', 'deepseek-chat', 'vault:ds_1', NULL, 0.700, 1.000, 2048, 60000, 0, 0, 0, '2026-03-10 00:00:00'),
(10, '归档配置', 'openai', 'gpt-3.5-turbo', 'vault:old', NULL, 0.500, 1.000, 1024, 60000, 0, 0, 1, '2026-03-20 00:00:00');

INSERT INTO sensitive_word (id, word, category, level, action, replace_to, status, created_at) VALUES
(1, '赌博', '违法', 3, 'block', NULL, 0, '2026-01-01 00:00:00'),
(2, '色情', '违法', 3, 'block', NULL, 0, '2026-01-01 00:00:00'),
(3, '法轮功', '政治', 3, 'block', NULL, 0, '2026-01-01 00:00:00'),
(4, '傻逼', '辱骂', 2, 'replace', '**', 0, '2026-01-01 00:00:00'),
(5, '退款诈骗', '诈骗', 3, 'warn', NULL, 0, '2026-02-01 00:00:00'),
(6, '加微信转账', '诈骗', 3, 'transfer', NULL, 0, '2026-02-05 00:00:00'),
(7, '代开发票', '合规', 2, 'warn', NULL, 0, '2026-02-10 00:00:00'),
(8, '政治敏感词A', '政治', 3, 'block', NULL, 0, '2026-02-15 00:00:00'),
(9, '政治敏感词B', '政治', 3, 'block', NULL, 0, '2026-02-15 00:00:00'),
(10, '测试敏感', '测试', 1, 'warn', NULL, 1, '2026-03-01 00:00:00');

INSERT INTO security_audit_log (id, user_type, user_id, event_type, ip, user_agent, result, detail_json, created_at) VALUES
(1, 'customer', 1, 'login', '192.168.1.10', 'Mozilla/5.0', 'success', JSON_OBJECT('method','password'), '2026-03-30 09:00:00'),
(2, 'admin', 1, 'login', '10.0.0.5', 'Chrome', 'success', NULL, '2026-03-31 07:00:00'),
(3, 'customer', 2, 'login_fail', '192.168.1.11', 'Safari', 'fail', JSON_OBJECT('reason','bad_password'), '2026-03-29 08:00:00'),
(4, 'admin', 2, 'logout', '10.0.0.6', 'Chrome', 'success', NULL, '2026-03-30 18:05:00'),
(5, 'customer', 5, 'login', '172.16.0.2', 'App/1.0', 'success', NULL, '2026-03-31 08:10:00'),
(6, 'admin', 4, 'login', '10.0.0.7', 'Firefox', 'success', NULL, '2026-03-28 17:00:00'),
(7, 'customer', NULL, 'anon_chat', '203.0.113.1', 'H5', 'success', JSON_OBJECT('token','anon_uuid_001'), '2026-03-31 08:00:00'),
(8, 'admin', 10, 'login_fail', '10.0.0.8', 'Edge', 'fail', JSON_OBJECT('reason','disabled'), '2026-03-25 09:00:00'),
(9, 'customer', 8, 'logout', '192.168.2.3', 'Chrome', 'success', NULL, '2026-03-30 20:10:00'),
(10, 'admin', 6, 'login', '10.0.0.9', 'Chrome', 'success', NULL, '2026-03-31 06:30:00');

INSERT INTO admin_operation_log (id, admin_id, module, action, resource_type, resource_id, ip, before_json, after_json, created_at) VALUES
(1, 1, 'kb', 'publish', 'knowledge_document', '1', '10.0.0.5', NULL, JSON_OBJECT('status',1), '2026-02-01 11:00:00'),
(2, 4, 'kb', 'update', 'knowledge_document', '3', '10.0.0.12', JSON_OBJECT('title','旧标题'), JSON_OBJECT('title','下单后多久发货'), '2026-02-05 12:00:00'),
(3, 1, 'model', 'update', 'llm_model_config', '1', '10.0.0.5', JSON_OBJECT('temperature',0.6), JSON_OBJECT('temperature',0.7), '2026-03-01 10:00:00'),
(4, 6, 'prompt', 'create', 'prompt_template', '10', '10.0.0.20', NULL, JSON_OBJECT('scene','offline'), '2026-03-01 11:00:00'),
(5, 2, 'risk', 'create', 'sensitive_word', '6', '10.0.0.8', NULL, JSON_OBJECT('word','加微信转账'), '2026-02-05 15:00:00'),
(6, 8, 'agent', 'status', 'agent_user', '4', '10.0.0.30', JSON_OBJECT('online',1), JSON_OBJECT('online',2), '2026-03-30 09:00:00'),
(7, 4, 'kb', 'import', 'knowledge_document', 'batch', '10.0.0.12', NULL, JSON_OBJECT('count',5), '2026-03-10 14:00:00'),
(8, 1, 'sys', 'role_bind', 'admin_user', '9', '10.0.0.5', NULL, JSON_OBJECT('role_id',7), '2026-03-15 16:00:00'),
(9, 5, 'chat', 'export', 'chat_session', '202603', '10.0.0.40', NULL, JSON_OBJECT('rows',1200), '2026-03-20 10:00:00'),
(10, 9, 'stat', 'view', 'report', 'daily', '10.0.0.50', NULL, NULL, '2026-03-29 15:30:00');

INSERT INTO customer_feedback (id, session_id, user_id, rating, comment, tags, created_at) VALUES
(1, 1, 1, 5, '回答很清晰', '满意,准确', '2026-03-30 10:06:00'),
(2, 2, 2, 4, '还可以', '物流', '2026-03-29 14:12:00'),
(3, 4, 3, 5, NULL, NULL, '2026-03-28 16:25:00'),
(4, 6, 8, 3, '希望更详细', '会员', '2026-03-26 09:20:00'),
(5, 7, 9, 5, '很好', '售后', '2026-03-25 20:10:00'),
(6, 9, 4, 4, NULL, NULL, '2026-03-24 13:10:00'),
(7, 10, 7, 2, '等待较久', '慢', '2026-03-23 18:15:00'),
(8, 8, 10, 5, '不错', NULL, '2026-03-31 09:40:00'),
(9, 3, NULL, 4, '匿名用户评价', '匿名', '2026-03-31 08:05:00'),
(10, 2, 2, 5, '二次评价补充分', '物流,快', '2026-03-29 14:30:00');

-- Note: session 3 user_id is NULL - customer_feedback id 9 uses session 3 with user_id NULL - OK

INSERT INTO human_transfer_record (id, session_id, agent_id, queue_position, status, reason, created_at, picked_at, closed_at) VALUES
(1, 5, 1, 1, 'closed', '用户要求', '2026-03-27 11:00:10', '2026-03-27 11:05:00', '2026-03-27 11:25:00'),
(2, 2, 2, 2, 'closed', NULL, '2026-03-26 10:00:00', '2026-03-26 10:02:00', '2026-03-26 10:20:00'),
(3, 4, NULL, 3, 'cancel', '用户取消', '2026-03-25 15:00:00', NULL, '2026-03-25 15:02:00'),
(4, 1, 5, 1, 'picked', '咨询升级', '2026-03-31 07:00:00', '2026-03-31 07:01:00', NULL),
(5, 6, 7, 2, 'closed', NULL, '2026-03-24 12:00:00', '2026-03-24 12:01:00', '2026-03-24 12:30:00'),
(6, 7, 3, 4, 'queued', '投诉', '2026-03-31 10:00:00', NULL, NULL),
(7, 8, 4, 1, 'closed', NULL, '2026-03-22 11:00:00', '2026-03-22 11:02:00', '2026-03-22 11:40:00'),
(8, 9, 9, 3, 'closed', NULL, '2026-03-21 09:00:00', '2026-03-21 09:05:00', '2026-03-21 09:25:00'),
(9, 10, 8, 2, 'closed', NULL, '2026-03-20 14:00:00', '2026-03-20 14:03:00', '2026-03-20 14:18:00'),
(10, 3, 6, 5, 'cancel', '超时未接入', '2026-03-19 16:00:00', NULL, '2026-03-19 16:30:00');

INSERT INTO stat_daily_summary (id, stat_date, channel, session_count, message_count, user_message_count, transfer_count, avg_response_ms, satisfaction_avg, created_at) VALUES
(1, '2026-03-31', 'all', 120, 980, 490, 15, 2300, 4.35, '2026-04-01 01:00:00'),
(2, '2026-03-30', 'all', 110, 900, 450, 12, 2400, 4.40, '2026-03-31 01:00:00'),
(3, '2026-03-29', 'all', 105, 860, 430, 11, 2500, 4.28, '2026-03-30 01:00:00'),
(4, '2026-03-28', 'web', 80, 640, 320, 8, 2200, 4.50, '2026-03-29 01:00:00'),
(5, '2026-03-28', 'h5', 25, 200, 100, 3, 2600, 4.10, '2026-03-29 01:00:00'),
(6, '2026-03-27', 'all', 98, 820, 410, 10, 2350, 4.33, '2026-03-28 01:00:00'),
(7, '2026-03-26', 'all', 90, 760, 380, 9, 2450, 4.20, '2026-03-27 01:00:00'),
(8, '2026-03-25', 'mini', 15, 120, 60, 2, 2800, 4.00, '2026-03-26 01:00:00'),
(9, '2026-03-24', 'all', 88, 700, 350, 8, 2400, 4.45, '2026-03-25 01:00:00'),
(10, '2026-03-23', 'all', 85, 680, 340, 7, 2500, 4.30, '2026-03-24 01:00:00');

-- 重置自增（可选，便于固定ID后续扩展）
-- ALTER TABLE customer_user AUTO_INCREMENT = 11;
