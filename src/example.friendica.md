---
date: 2018-12-07 22:47:50 +0800
title: "Friendica的Caddy配置"
sitename: "Caddy配置示例"
template: "example"
---

# Friendica的Caddy配置

这个Caddyfile用来测试和[Friendica](https://friendi.ca/) 3.5.2一起运行。

它应该能支持Friendica 3.x的版本，也许还能支持更低的版本。

## 可替换内容

要使这个配置生效，你应该只替换Caddyfile开头的`server_name`、到PHP套接字的路径(或IP)和`root/*_log`参数。

对于FastCGI，建议使用网络套接字而不是文件系统套接字，PHP可能无法预测文件系统套接字。请参阅有关如何指定FastCGI套接字的[文档](http.fastcgi.md)。

## Caddyfile

```caddy
server_name {
    root /home/friendica/public
    log    /home/friendica/log/access.log
    errors /home/friendica/log/errors.log

    fastcgi / 127.0.0.1:2000 php {
        env PATH /bin
    }

    rewrite {
        r .*
        to /{uri} /index.php?q={path}&{query}
    }
}
```