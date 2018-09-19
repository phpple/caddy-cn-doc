---
date: 2018-09-19 08:31:53 +0800
title: "http.grpc"
sitename: "Caddy中文文档"
---

# http.grpc

Caddy的grpc插件用来代理代理客户端对gRpc服务的gRpc调用。它使得能从普通的gRPC客户端或从浏览器(使用gRPC-Web协议)使用gRPC服务。

[完整文档](https://github.com/pieterlouw/caddy-grpc/blob/master/README.md)

## 示例

__基本设置__

```caddy
grpc.example.com 
grpc localhost:9090
```

以上是grpc插件的基本设置。

这将代理任何grpc请求到localhost:9090。

__使用其他指令设置__

```caddy
grpc.example.com 
prometheus
log
grpc localhost:9090
```

这将配合[log](http.log.md)和[prometheus](http.prometheus.md)指令，将任何grpc请求代理到localhost:9090。