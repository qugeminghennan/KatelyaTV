-- 完整的 admin_configs 表修复脚本
-- 这将创建正确的管理员配置数据结构

-- 首先清理可能存在的不正确数据
DELETE FROM admin_configs WHERE config_key != 'main_config';

-- 插入完整的管理员配置JSON数据
INSERT OR REPLACE INTO admin_configs (config_key, config_value, description) VALUES (
  'main_config',
  '{
    "SiteConfig": {
      "SiteName": "KatelyaTV",
      "Announcement": "欢迎使用KatelyaTV高性能影视播放平台",
      "SearchDownstreamMaxPage": 5,
      "SiteInterfaceCacheTime": 3600,
      "ImageProxy": "https://images.weserv.nl/?url=",
      "DoubanProxy": "https://douban-api.katelya.eu.org"
    },
    "UserConfig": {
      "AllowRegister": true,
      "Users": [
        {
          "username": "admin",
          "role": "owner",
          "banned": false
        }
      ]
    },
    "SourceConfig": [
      {
        "key": "kuaikan",
        "name": "快看影视",
        "api": "https://kuaikan-api.com",
        "from": "config",
        "disabled": false,
        "is_adult": false
      },
      {
        "key": "ysgc",
        "name": "影视工厂",
        "api": "https://ysgc.cc",
        "from": "config", 
        "disabled": false,
        "is_adult": false
      }
    ]
  }',
  '主要管理员配置 - 包含站点配置、用户配置和资源站配置'
);

-- 验证插入结果
SELECT 
  config_key,
  JSON_EXTRACT(config_value, '$.UserConfig.Users[0].username') as admin_username,
  JSON_EXTRACT(config_value, '$.SiteConfig.SiteName') as site_name,
  LENGTH(config_value) as config_size
FROM admin_configs 
WHERE config_key = 'main_config';
