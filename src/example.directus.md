---
date: 2018-12-04 23:08:15 +0800
title: "Directus的Caddy配置"
sitename: "Caddy配置示例"
template: "example"
---

# Directus的Caddy配置

本文档是无状态API驱动CMS系统——[directus](https://getdirectus.com/]的caddy配置文件示例。

## Caddyfile

```caddy
# 更换域名为你自己的
localhost:3000

# 更换为正确的网站根目录
# 在本示例里边我们假设directus是安装在此根目录
# 你可能需要根据你自己的设置去调整重写规则
root /var/www/directus

# 设置PHP-FPM的ip和端口
# 如果你不想到处使用php，可以将这里改到对应的路径下
fastcgi / 127.0.0.1:9000 php

# API路由的重写规则
rewrite /api {
    regexp ^extensions/([^/]+)
    to {path} /api/api.php?run_extension={1}&{query}
}

rewrite /api {
    to {path} /api/api.php?run_api_router=1&{query} 
}

# 其他重写规则
rewrite / {
    if {path} not_starts_with /assets
    if {path} not_starts_with /extensions
    if {path} not_starts_with /listviews
    to {path} /index.php
}
```