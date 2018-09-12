---
date: 2018-09-12 12:51:32 +0800
title: "http.timeouts"
sitename: "Caddy中文文档"
---

# http.timeouts

timeouts用来配置Caddy的HTTP少时时间：

* __Read__: 读取整个请求的最大持续时间，包括正文。
* __Read Header__: 允许读取请求头的时间。
* __Write__: 允许写入响应的最大持续时间。
* __Idle__: 等待下一个请求的最大时间(当使用keep-alive时)。默认是5分钟。

超时是在出现bug或恶意客户端时维持服务器连通性的重要手段。

由于超时适用于整个HTTP服务，该服务可能为您的Caddyfile中定义的多个站点提供服务，因此在共享该服务的所有站点上，每个站点的超时值将被减少到它们的最小值(
`0`或`none`是最低值)。最好保持你的超时时间不变，或者只在一个站点上设置它们以避免混淆。一个站点上的超时设置将应用于共享该服务的所有站点。

## 语法

将所有超时设置为相同的值：

```caddy
timeouts val
```

* __val__ 适用于所有超时的持续时间值(例如30s、2m30s、5m、1h)。设置为`0`或`none`以禁用以前启用的超时。

你也可以单独地配置每个超时项：

```caddy
timeouts {
	read   val
	header val
	write  val
	idle   val
}
```

有效值是持续时间，或`0`或`none`（禁用掉超时，如果之前启用过）。

## 示例

设置所有超时时间为1分钟：

```caddy
timeouts 1m
```

自定义`read`和`write`的超时值：

```caddy
timeouts {
	read  30s
	write 20s
}
```
