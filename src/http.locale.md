---
date: 2018-09-19 20:38:24 +0800
title: "http.locale"
sitename: "Caddy中文文档"
---

# http.locale

为Caddy进行区域检测。

[完整文档](https://github.com/simia-tech/caddy-locale/blob/master/README.md)

## 示例

__根据cookie/header进行地域检测__

```caddy
locale en de {
  detect cookie header
}

rewrite {
  ext /
  to index.{>Detected-Locale}.html index.html
}

header / Vary "Cookie, Accept-Language"
```

这个示例尝试从cookie中读取区域设置，如果失败，则使用Accept-Language头。
