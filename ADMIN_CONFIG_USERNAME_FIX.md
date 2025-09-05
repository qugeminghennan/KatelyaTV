# admin_configs 表 USERNAME 字段修复说明

## 问题描述
从截图中看到，你的 admin_configs 表缺少了应该存在的 USERNAME 配置。这是因为 admin_configs 表的数据结构与预期不符。

## 解决方案

### 方法1: 直接在 Cloudflare D1 控制台执行 (推荐)

在你的 Cloudflare D1 数据库控制台中，执行以下SQL语句：

```sql
-- 清理现有的配置数据
DELETE FROM admin_configs;

-- 插入完整的管理员配置
INSERT INTO admin_configs (config_key, config_value, description) VALUES (
  'main_config',
  '{"SiteConfig":{"SiteName":"KatelyaTV","Announcement":"欢迎使用KatelyaTV高性能影视播放平台","SearchDownstreamMaxPage":5,"SiteInterfaceCacheTime":3600,"ImageProxy":"https://images.weserv.nl/?url=","DoubanProxy":"https://douban-api.katelya.eu.org"},"UserConfig":{"AllowRegister":true,"Users":[{"username":"admin","role":"owner","banned":false}]},"SourceConfig":[{"key":"kuaikan","name":"快看影视","api":"https://kuaikan-api.com","from":"config","disabled":false,"is_adult":false}]}',
  '主要管理员配置'
);
```

### 方法2: 使用 wrangler CLI

如果你有 wrangler CLI 配置好，可以执行：

```bash
wrangler d1 execute your-database-name --command="DELETE FROM admin_configs;"
wrangler d1 execute your-database-name --command="INSERT INTO admin_configs (config_key, config_value, description) VALUES ('main_config', '{\"SiteConfig\":{\"SiteName\":\"KatelyaTV\",\"Announcement\":\"欢迎使用KatelyaTV高性能影视播放平台\",\"SearchDownstreamMaxPage\":5,\"SiteInterfaceCacheTime\":3600,\"ImageProxy\":\"https://images.weserv.nl/?url=\",\"DoubanProxy\":\"https://douban-api.katelya.eu.org\"},\"UserConfig\":{\"AllowRegister\":true,\"Users\":[{\"username\":\"admin\",\"role\":\"owner\",\"banned\":false}]},\"SourceConfig\":[{\"key\":\"kuaikan\",\"name\":\"快看影视\",\"api\":\"https://kuaikan-api.com\",\"from\":\"config\",\"disabled\":false,\"is_adult\":false}]}', '主要管理员配置');"
```

### 方法3: 使用项目中的SQL文件

我已经创建了 `fix-admin-config-complete.sql` 文件，你可以：

1. 在D1控制台中复制粘贴该文件的内容
2. 或者使用 wrangler: `wrangler d1 execute your-database-name --file=fix-admin-config-complete.sql`

## 验证结果

执行完成后，你应该看到：
- admin_configs 表中有一条 config_key = 'main_config' 的记录
- config_value 是完整的JSON配置，包含用户名 "admin"
- 管理员页面应该能正常显示配置信息

## 预期结果

修复后，admin_configs 表应该包含：
- config_key: "main_config"
- config_value: 完整的JSON配置数据
- description: "主要管理员配置"

在管理员页面你将看到：
- USERNAME: admin (从JSON配置中提取)
- 其他所有的配置选项都正常显示
