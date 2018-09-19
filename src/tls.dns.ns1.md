---
date: 2018-09-19 23:46:31 +0800
title: "tls.dns.ns1"
sitename: "Caddy中文文档"
---

# tls.dns.ns1

允许从Ns1使用DNS记录获取证书，进行域名管理。

[完整文档](https://github.com/caddyserver/dnsproviders/blob/master/README.md)

## 示例

__用法__

```caddy
tls {
    dns ns1
}
```

在tls指令中指定ns1作为DNS提供者。确保设置包含凭证的环境变量。