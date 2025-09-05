-- 修复 admin_configs 表缺失 USERNAME 字段的问题
-- 此脚本将为管理员配置表添加用户名字段并插入默认管理员用户

-- Step 1: 添加 USERNAME 字段到 admin_configs 表
ALTER TABLE admin_configs ADD COLUMN username TEXT;

-- Step 2: 插入默认的管理员用户名配置
INSERT OR REPLACE INTO admin_configs (config_key, config_value, description, username) VALUES
('admin_username', 'admin', '默认管理员用户名', 'admin');

-- Step 3: 更新现有的配置记录，添加管理员用户名
UPDATE admin_configs 
SET username = 'admin' 
WHERE username IS NULL;

-- Step 4: 插入其他必要的管理员配置（如果不存在）
INSERT OR IGNORE INTO admin_configs (config_key, config_value, description, username) VALUES
('admin_password', '$2b$10$example.hash.for.admin.password', '管理员密码哈希', 'admin'),
('site_name', 'KatelyaTV', '站点名称', 'admin'),
('site_description', '高性能影视播放平台', '站点描述', 'admin'),
('enable_register', 'true', '是否允许用户注册', 'admin'),
('max_users', '100', '最大用户数量', 'admin'),
('cache_ttl', '3600', '缓存时间（秒）', 'admin'),
('cors_origin', '*', 'CORS来源设置', 'admin'),
('health_check_enabled', 'true', '健康检查开关', 'admin'),
('health_check_interval', '30', '健康检查间隔（秒）', 'admin'),
('image_proxy_enabled', 'true', '图片代理开关', 'admin'),
('log_format', 'json', '日志格式', 'admin'),
('log_level', 'info', '日志级别', 'admin'),
('nextauth_url', 'https://tv.katelya.eu.org', '认证服务URL', 'admin'),
('next_public_site_description', '高性能影视播放平台', '公共站点描述', 'admin'),
('next_public_site_name', 'KatelyaTV', '公共站点名称', 'admin'),
('next_public_storage_type', 'd1', '存储类型', 'admin'),
('node_env', 'production', '运行环境', 'admin'),
('password', '值已加密', '管理员密码', 'admin'),
('rate_limit_max', '100', '速率限制最大值', 'admin'),
('rate_limit_window', '60000', '速率限制窗口（毫秒）', 'admin');

-- Step 5: 验证数据插入
SELECT 'admin_configs表记录数量:' as info, COUNT(*) as count FROM admin_configs;
SELECT 'admin_configs表结构:' as info, sql FROM sqlite_master WHERE type='table' AND name='admin_configs';
