---
title: "占位符"
sitename: "Caddy中文文档"
---

# 占位符

一些指令允许你在Caddyfile中使用占位符来为每个请求填写不同的值。例如，值{path}将被请求URL的路径部分替换。这些也被称为可替换值。

> 这些占位符只作用于支持它们的指令。检查你的指令文档，看看它们是否支持占位符。请求占位符

## 请求占位符
这些值都是通过请求获取的。

| 占位符   | 值                                                      |
|---------|---------------------------------------------------------|
| {~cookie}  | cookie的值，其中"cookie"就是cookie的名称。                 |
| {dir}      | 请求文件的目录(来自请求URI)   |˙
| {file}     | 请求的文件名(来自请求URI)  |
| {fragment} | URL从"#"开始的最后的部分  |
| {>Header}  | 任何请求头，"Header"是请求头的名称 |
| {host}     | 请求的主机  |
| {hostname} | 处理当前请求机器的名称  |
| {hostonly} | 和{host}类似，但不包括端口信息  |
| {labelN}   | 主机的第N部分 (N是一个整数，最少为1); 比如：对应"sub.dengxiaolong.com"的{label2}是"dengxiaolong"。对应"*.dengxiaolong.com"的{label1}是子域名单独的部分。  |
| {method}   | 请求方法（如GET、POST等）  |
| {mitm}     | HTTPS拦截是likely、unlikely还是unknown  |
| {path}     | 请求原始URI的路径部分（不包含查询字符串以及锚部分）  |
| {path_escaped} | {path}的查询转义变体  |
| {port}     | __客户端__端口  |
| {proto}    | 协议字符串（如"HTTP/1.1"）  |
| {query}    | URL的查询字符串部分，没有开始的"?"  |
| {query_escaped} | {query}的查询转义变体  |
| {?key}     | 查询字符串的"key"参数  |
| {remote}   | 客户端的IP地址  |
| {request}  | 整个HTTP请求（不包括请求体），压缩成一行  |
| {request_id} | 请求ID的UUID。如果在Caddyfile中没有使用`request_id`指令，则返回为空 |
| {request_body} | 请求体，压缩到一行了（最大长度100 KB；只能是JSON或者XML）  |
| {rewrite_path} | 和{path}类似，但是是经过重写后的路径 |
| {rewrite\_path\_escaped} | {rewrite_path}的查询转义变体  |
| {rewrite_uri} | 任何重写发生后的请求URI（包括路径、查询字符串、以及锚部分）  |
| {rewrite\_uri\_escaped} | {rewrite_uri}的查询转义变体  |
| {scheme}   | 使用的协议/方案（通常是http或者https）  |
| {tls_cipher} | 用于TLS连接的密码套件  |
| {tls_version} | TLS版本  |
| {uri} | 请求URI（包括路径、查询串、以及锚部分）  |
| {uri_escaped} | {uri}的查询转义变体  |
| {user} | basic校验认证的用户名（HTTP基本认证）  |
| {when} | 格式为02/Jan/2006:15:04:05 -0700的当地时间  |
| {when_iso} | 格式为2006-01-02T15:04:05Z的UTC时间  |
| {when_unix} | Unix时间戳，格式为1136214252(自1970年1月1日的秒数)  |


## 响应占位符

这些值是从响应中获得的，并且仅在某些指令中实现。在尝试使用响应占位符之前，请确保您的指令支持它们。


| 占位符   | 值                                                      |
|---------|---------------------------------------------------------|
| {<Header} | 任何响应头，"Header"是头字段的名称  |
| {latency} | 以适合人类阅读的格式预估服务器处理请求的时间  |
| {latency_ms} | 服务器处理请求的大概时间，单位为毫秒  |
| {size} | 响应体的尺寸  |
| {status} | 响应的HTTP状态码  |
