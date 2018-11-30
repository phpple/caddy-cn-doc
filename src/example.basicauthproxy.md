---
date: 2018-11-28 22:21:27 +0800
title: "Caddy的basic验证代理配置"
sitename: "Caddy配置示例"
template: "example"
---

# Caddy的basic验证代理配置

本文将学习如何将Caddy如何在http服务器的前端充当basic验证代理。想了解更多，查看[http.basicauth](http.basicauth.md)和[http.proxy](http.proxy.md)的文档。

## 前提
* 你有一个正在运行的http服务器或者一些外部资源
* 你已经安装，如果没有请查看[新手入门](beginner.md)

## 启动Caddy

```bash
$ ./caddy
Activating privacy features... done.
your.public.com:443
your.public.com:80
```

### Caddyfile

```caddy
# 下面的例子说明了如何为web服务器设置basic验证代理

your.public.com

# 如果你想使用多个用户，换行加上其他用户即可
# basicauth / username1 password1
# basicauth / username2 password2

basicauth / username password

# 代理到localhost的8080端口
# 如果使用了多个后端，用空格隔开即可
# proxy / localhost:8080 localhost:8081 192.168.99.100:8083

proxy / localhost:8080
```