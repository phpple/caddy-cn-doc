---
date: 2018-09-19 23:47:19 +0800
title: "tls.dns.otc"
sitename: "Caddy中文文档"
---

# tls.dns.otc

允许从Open Telekom Cloud Managed DNS使用DNS记录获取证书，进行域名管理。

[完整文档](https://github.com/caddyserver/dnsproviders/blob/master/README.md)

## 示例

__用法__

```caddy
tls {
    dns otc
}
```

在tls指令中指定otc作为DNS提供者。确保设置包含凭证的环境变量。