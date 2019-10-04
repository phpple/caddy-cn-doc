---
date: 2018-12-07 22:25:09 +0800
title: "Caddy的Flask配置"
sitename: "Caddy配置示例"
template: "example"
---

# Caddy的Flask配置

这是一个基于[Guicorn](http://gunicorn.org/)运行的[Flask](http://flask.pocoo.org/)项目的配置示例。目前Caddy尚不支持uwsgi协议，可以关注这个[issue](https://github.com/mholt/caddy/issues/176)获取这方面的最新动态。现在最好的选择是将请求代理到app服务器。

1. 在app环境安装Gunicorn：

```bash
pip install gunicorn
```

2. 启动Gunicorn：

```bash
gunicorn -b "127.0.0.1:8000" project.wsgi
```

通常，你将使用supervisor或者其他工具启动Gunicorn脚本。

3. 通过Caddy代理到Gunicorn的请求。

## Caddyfile

```caddy
domain.tld {
    root /var/www/project/folder
    proxy / localhost:8000 {
        transparent
    }
}
```
