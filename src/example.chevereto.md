---
date: 2018-12-01 01:11:47 +0800
title: "Chevereto的Caddy配置"
sitename: "Caddy配置示例"
template: "example"
---

# Chevereto的Caddy配置

这是一个通过Caddy运行[Chevereto](https://chevereto.com/)的一个配置示例。

这个配置假设了如下条件：

* 你已经在`/var/www/chevereto`安装了Chevereto。
* 你使用的域名是`example.com`

请务必使用实际的值替换相应位置。

## Caddyfile

```caddy
example.com {
    root /var/www/chevereto
    fastcgi / /var/run/php/php7.0-fpm.sock php

    rewrite {
        to {path} {path}/ /index.php?{query}
    }
}
```

