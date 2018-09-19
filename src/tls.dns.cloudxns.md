---
date: 2018-09-19 23:34:04 +0800
title: "tls.dns.cloudxns"
sitename: "Caddy中文文档"
---

# tls.dns.cloudxns

允许从CloudXNS使用DNS记录获取证书，进行域名管理。

[完整文档](https://github.com/caddyserver/dnsproviders/blob/master/README.md)

## 示例

__用法__

```caddy
tls {
    dns cloudxns
}
```

在tls指令中指定cloudxns作为DNS提供者。确保设置包含凭证的环境变量。