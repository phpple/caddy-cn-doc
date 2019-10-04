---
date: 2018-12-04 23:51:45 +0800
title: "Drone的Caddy配置"
sitename: "Caddy配置示例"
template: "example"
---

# Drone的Caddy配置

这是如何通过Caddy使用[Drone](https://github.com/drone/drone)的配置示例。

本配置假设了下面的几点：

* Drone使用了8000
* 你的域名是example.com

请将其修改成真实的值。

## Caddyfile

```caddy
example.com {
    gzip {
        not /api/
    }
    proxy / localhost:8000 {
        websocket
        transparent
    }
}
```