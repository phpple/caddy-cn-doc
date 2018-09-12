---
date: 2018-09-12 13:10:51 +0800
title: "http.websocket"
sitename: "Caddy中文文档"
---

# http.websocket

websocket用来帮助[WebSocket](https://developer.mozilla.org/en-US/docs/WebSockets)服务器/代理。当Caddy把一个新建立的[WebSocket connection](https://developer.mozilla.org/en-US/docs/WebSockets/Writing_WebSocket_client_applications)连接转发给该指令时，就会执行一个命令。

任何命令都可以执行，只要它接受stdin的输入并写入stdout，因为这是它与WebSocket客户端通信的方式。命令不需要知道它正在与Web套接字客户机通信;只需要使用stdin和stdout。

在连接客户端时，Caddy不会努力使后端进程保持活动。开发人员有责任确保在客户端准备好关闭连接或准备好终止连接之前程序不会终止。

> 注意，HTTP/2不支持协议升级，因此你可能必须禁用HTTP/2才能成功地在安全连接上使用此指令。

## 语法

```caddy
websocket [path] command
```

* __path__ 用来匹配请求网址的基本路径。
* __command__ 执行的命令

如果路径被省略，默认的路径是/(表示所有请求)。

## 示例

一个简单的WebSockets echo服务：

```caddy
websocket /echo cat
```