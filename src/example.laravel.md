---
date: 2018-12-04 23:59:46 +0800
title: "Caddy的Laravel配置"
sitename: "Caddy配置示例"
template: "example"
---

# Caddy的Laravel配置

本示例配置用来通过Caddy运行基于[Laravel](https://laravel.com/)框架的网站。


## Caddyfile

```caddy
example.com {
    root ./public
    fastcgi / 127.0.0.1:9000 php
    rewrite {
        to {path} {path}/ /index.php?{query}
    }
}
```