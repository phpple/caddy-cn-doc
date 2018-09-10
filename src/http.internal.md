---
date: 2018-09-11 00:51:26 +0800
title: "http.internal"
sitename: "Caddy中文文档"
---

# http.internal

internal保护指定目录中的所有资源，使其不接受外部请求。直接请求受保护目录中的资源的浏览器(或任何客户端)将收到404 Not Found的状态。

因为这个指令支持X-Accel-Redirect头，所以它经常与后端代理一起使用。对不同于内部URL的请求可以重定向到代理，而代理可以设置X-Accel-Redirect头。当Caddy看到请求来自代理时，将允许访问内部资源并将其发送给客户端。这有时也被称为X-Sendfile。

通过这种模式处理请求时，允许后端代理进行日志记录、身份验证和其他事情，而客户端无需处理重定向。

## 语法

```caddy
internal path
```

* __path__ 防止外部请求的基本路径

## 示例

保护/internal的所有内容不能直接提供服务：

```caddy
internal /internal
```

下面的示例是Caddyfile的一部分，用于保护一些资源，但允许代理授予对它们的访问权限(在:9000监听的服务必须设置X-Accel-Redirect头)：

```caddy
internal /internal
proxy    /redirect   http://localhost:9000
```