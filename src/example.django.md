---
date: 2018-12-01 01:37:12 +0800
title: "Caddy的Django配置"
sitename: "Caddy配置示例"
template: "example"
---

# Caddy的Django配置

这是一个使用gunicorn运行的Django项目的配置例子。目前，caddy还不支持uwsgi协议，最好的选择，就是代理请求到应用服务器。

1. 在你的应用服务器安装gunicorn：`pip install gunicorn`。

2. 启动gunicorn：`gunicorn -b "127.0.0.1:8000" project.wsgi`。
   通常，你会通过supervisor或者类似的工具运行gunicorn的脚本，以保证服务的高可用。

3. 通过caddy代理到gunicon的请求。

4. 注意你的静态和媒体资源。

## Caddyfile

```caddy
domain.tld {
    root /var/www/project/folder
    proxy / localhost:8000 {
        transparent
    }
}
```