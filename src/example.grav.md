---
date: 2018-12-07 23:23:10 +0800
title: "Grav的Caddy配置"
sitename: "Caddy配置示例"
template: "example"
---

# Grav的Caddy配置

这是一份通过Caddy访问[Grav](https://www.getgrav.org/)的Caddy配置文件，只需要将所有请求重定向到index.php即可。

## Caddyfile

```caddy
example.com {
    root /path/to/site
    fastcgi / 127.0.0.1:9000 php

    status 403 /forbidden

    # Begin - 安全
    # 下面的目录不允许被访问
    rewrite {
        if {path} match /(.git|cache|bin|logs|backups|tests)/.*$
        to /forbidden
    }
    # 核心系统目录内的这类类型不允许被执行
    rewrite {
        if {path} match /(system|vendor)/.*\.(txt|xml|md|html|yaml|php|pl|py|cgi|twig|sh|bat)$
        to /forbidden
    }
    # 用户目录下的这类文件不允许被执行
    rewrite {
        if {path} match /user/.*\.(txt|md|yaml|php|pl|py|cgi|twig|sh|bat)$
        to /forbidden
    }
    # root目录的这些文件不允许被访问
    rewrite {
        if {path} match /(LICENSE.txt|composer.lock|composer.json|nginx.conf|web.config|htaccess.txt|\.htaccess)
        to /forbidden
    }
    ## End - 安全

    # 在最后放全局的重写规则
    rewrite {
        to  {path} {path}/ /index.php?_url={uri}
    }
}
```