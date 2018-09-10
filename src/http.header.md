---
date: 2018-09-10 09:05:42 +0800
title: "http.header"
sitename: "Caddy中文文档"
---

# http.header

header可以操作响应头。

注意，如果希望从代理后端删除响应标头，必须在[proxy](http.proxy.md)指令中这样做。

## 语法

```caddy
header path name value
```

* __path__ 匹配的基本路径。
* __name__ 字段名称。以连字符(-)作为前缀表示要删除这个头，以加号(+)作为前缀则表示追加而不是覆盖。
* __value__ 字段的值。动态值也可以使用[占位符](placeholders.md)插入。

这个指令可以多次使用，或者你可以为同一路径定义多个自定义头字段:

```
header path {
    name value
}
```

## 示例
给所有页面自定义头：
```caddy
header / X-Custom-Header "My value"
```

从头信息去掉"Hidden"字段：

```caddy
header / -Hidden
```

一个特定路径的多个自定义头，同时删除"-Server"字段：

```caddy
header /api {
    Access-Control-Allow-Origin  *
    Access-Control-Allow-Methods "GET, POST, OPTIONS"
    -Server
}
```

为所有页面添加一些安全相关的头:

```
header / {
    # 启用HTTP严格传输安全性(HSTS)来强制客户端始终通过HTTPS链接（如果只是测试请勿使用）
    Strict-Transport-Security "max-age=31536000;"
    # 启用跨站点过滤器(XSS)并告诉浏览器阻止检测到的攻击
    X-XSS-Protection "1; mode=block"
    # 防止某些浏览器通过声明的"Content-type"对响应使用"MIME-sniffing"
    X-Content-Type-Options "nosniff"
    # 不允许网站在框架内渲染(点击劫持保护)
    X-Frame-Options "DENY"
}
```
