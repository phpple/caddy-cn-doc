---
date: 2018-09-17 09:57:57 +0800
title: "http.realip"
sitename: "Caddy中文文档"
---

# http.realip

如果你的Caddy运行在CDN或代理后端，这个插件允许你通过`X-Forwarded-For`头获取到实际的客户端IP。它将使`logs`和其他下游指令能够看到实际的客户端IP，而不是代理的IP。

要保证安全措施，不能从未经授权的IP范围获取"X-Forwarded-For"，以免受骗。

[完整文档](https://github.com/captncraig/caddy-realip/blob/master/README.md)

## 示例

__只接受已知IP的X-Forwarded-For__

```caddy
realip {
    from 1.2.3.4/32
    from 2.3.4.5/32
}
```

__Cloudflare预设__

```caddy
realip cloudflare
```

自动添加cloudflare的IP到允许列表。