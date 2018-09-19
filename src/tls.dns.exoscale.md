---
date: 2018-09-19 23:39:56 +0800
title: "tls.dns.exoscale"
sitename: "Caddy中文文档"
---

# tls.dns.exoscale

允许从Exoscale使用DNS记录获取证书，进行域名管理。

[完整文档](https://github.com/caddyserver/dnsproviders/blob/master/README.md)

## 示例

__用法__

```caddy
tls {
    dns exoscale
}
```

在你的tls指令中使用这个。