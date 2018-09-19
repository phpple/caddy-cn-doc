---
date: 2018-09-19 23:17:16 +0800
title: "dns"
sitename: "Caddy中文文档"
---

# dns

一个DNS服务插件。

[完整文档](https://github.com/coredns/coredns/blob/master/README.md)

## 示例

__CoreDNS__

```caddy
.:53 {
    cache    
    forward . 8.8.8.8:53
    log
    errors
}
```

点击<https://coredns.io>查看更多文档。
