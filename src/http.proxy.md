---
date: 2018-09-11 20:39:46 +0800
title: "http.proxy"
sitename: "Caddy中文文档"
---

# http.proxy

proxy保证了基本的反向代理和健壮的负载均衡。代理支持多个后端和添加自定义标头。负载平衡特性包括多个策略、健康检查和failovers。Caddy也可以代理WebSocket连接。

proxy facilitates both a basic reverse proxy and a robust load balancer. The proxy has support for multiple backends and adding custom headers. The load balancing features include multiple policies, health checks, and failovers. Caddy can also proxy WebSocket connections.

This middleware adds a placeholder that can be used in log formats: {upstream} - the name of the upstream host to which the request was proxied.

Syntax
In its most basic form, a simple reverse proxy uses this syntax:

proxy from to

from is the base path to match for the request to be proxied
to is the destination endpoint to proxy to (may include a port range)
However, advanced features including load balancing can be utilized with an expanded syntax:

