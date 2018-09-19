---
date: 2018-09-19 23:24:02 +0800
title: "tls.dns.auroradns"
sitename: "Caddy中文文档"
---

# tls.dns.auroradns

允许您从管理域名的服务商AuroraDNS通过DNS记录获取证书。

[完整文档](https://github.com/caddyserver/dnsproviders/blob/master/README.md)

## 示例

__用法__

```caddy
tls {
    dns auroradns
}
```

在tls指令中指定auroradns作为DNS服务商。