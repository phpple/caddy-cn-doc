---
date: 2018-12-05 09:37:35 +0800
title: "Gitea的配置"
sitename: "Caddy配置示例"
template: "example"
---

# Gitea的Caddy配置

<img src="https://gitea.io/images/gitea.png" width="150"/>

这是一个如何使[Gitea](https://gitea.io/)使用Caddy的示例配置。

这个配置使用了下面的假设
* Gitea监听了3000端口
* 你的域名是mygitea.com

请将其修改为实际的值。

## Caddyfile

```caddy
mygitea.com {
    proxy / localhost:3000
}
```