---
date: 2018-09-11 20:40:20 +0800
title: "http.push"
sitename: "Caddy中文文档"
---

# http.push

push用来启用和配置HTTP/2服务器推送。

服务器推送可以通过发送其知道客户端需要但尚未请求的资源来加速页面载入。它不是WebSockets的替代品。它必须被仔细配置，特别是在客户端缓存方面，否则推送实际上会降低性能。如果客户端在第一次推送资源之后被缓存了，则不需要对同一资源进行后续推送。

Caddy知道应该从Caddyfile中提供的规则或从上游的连接头信息中推送哪些资源。

## 语法

```caddy
push
```

通过读取响应的HTTP连接的报头，启用服务器对任何请求的推送。如果你使用[proxy](http.proxy.md)或[fastcgi](http.fastcgi.md)代理后端应用这是有用的，比如，这将为预加载设置连接头。

配置一个基本的push规则：

```caddy
push path [resources...]
```

* __path__ 应用此规则的请求的基本路径。
* __resources...__ 通过空格分开的推送资源列表。如果没有指定资源，将只能通过连接头来了解推送资源。

要推送许多不适合一行的资源，或更改用于初始化推送的合成请求的方法或标题，需使用块：

```caddy
push path [resources...] {
    method method
    header name value
    resources
}
```

* __path__和 __resources__ 和上面一样，除了在块中指定资源时，每行只列出一个资源。
* __method__ 指定发起推送的合成请求的方法；可以是GET或HEAD。默认是GET。
* __header__ 向发起推送的合成请求添加标题；可以多次指定。它由字段名和值组成。不允许使用伪标头字段。

## 示例
启用服务器使用连接头推送所有请求：

```caddy
push
```

为所有请求(不支持缓存)推送谷歌分析脚本：

```caddy
push / /ga.js
```

将一对CSS文件的请求推到主页：

```caddy
push /index.html /common.css /home.css
```

推送很多资源到主页：

```caddy
push /index.html {
    /resources/css/common.css
    /resources/css/home.css
    /resources/css/compiled.css
    /resources/js/main.js
    /resources/js/jquery.min.js
    /resources/images/logo.png
    /resources/images/background.jpg
}
```

为所有推送请求指定一个方法和标题：

```caddy
push {
    method HEAD
    header MyHeader "The value"
}
```