---
date: 2018-09-17 09:40:31 +0800
title: "http.cache"
sitename: "Caddy中文文档"
---

# http.cache

cache指令用来配置http缓存。

[完整文档](https://github.com/nicolasazrak/caddy-cache/blob/master/README.md)

## 示例

__基本示例__

```caddy
yoursite.caddy {
    cache
    proxy / localhost:8080
}
```

这是最基本的用法。它将缓存成功的响应并将它们保存在临时文件夹中。

如果定义了cache-control头，它将遵循它。如果没有指定过期时间，则默认使用5分钟。

__高级用法__

```caddy
caddy.test {
    proxy / yourserver:5000
    cache {
        match_path /assets
        match_header Content-Type image/jpg image/png
        status_header X-Cache-Status
        default_max_age 15m
        path /tmp/caddy-cache
    }
}
```

您可以定义更高级的选项，如:

* __match_path__：它将缓存给定的路径，除非头字段指定了其他的(cache-control: private)

* __match_header__：它将缓存具有给定头字段的响应。在示例中:每个带有Content-Type image/jpg或image/png的响应都将被缓存，除非头字段另有说明

* __status_header__：是用缓存状态设置的标头名称。该值将是以下值之一: `hit`、`miss`、`skip`或`bypass`。

* __default_max_age__：当报头没有指定它时，它指定缓存响应的默认过期时间。

* __path__：存储响应的位置。需要保证它已经存在，且能被Caddy写入。