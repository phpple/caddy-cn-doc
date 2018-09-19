---
date: 2018-09-19 23:30:23 +0800
title: "tls.dns.azure"
sitename: "Caddy中文文档"
---

# tls.dns.azure

允许从Microsoft Azure使用DNS记录获取证书，进行域名管理。

[完整文档](https://github.com/caddyserver/dnsproviders/blob/master/README.md)

## 示例

__用法__

```caddy
tls {
    dns azure
}
```

在你的tls指令中使用这个。请确保使用环境变量设置凭证。(参见文档)。