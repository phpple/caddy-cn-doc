---
date: 2018-09-11 21:40:33 +0800
title: "http.request_id"
sitename: "Caddy中文文档"
---

# http.request_id

equest_id生成一个UUID，可以通过{request_id}[占位符](placeholders.md)引用，用于许多其他指令包括`header`和`log`。

当启用request_id时，{request_id}[占位符](placeholders.md)将有一个值；否则它将是空的。

## 语法

```caddy
request_id [header_field]
```

* __header_field__ 是一个可选的头字段名，可以从中读取现有的请求ID。为了站点的安全起见，不要滥用这个特性(例如，不要使用它来跟踪用户会话)。

## 示例
在响应头中设置请求ID:

```caddy
request_id 
header /  Caddy-Request-Id {request_id}
```

如果存在，从一个名为X-Request-ID的请求头中读取请求ID:

```caddy
request_id X-Request-ID
```