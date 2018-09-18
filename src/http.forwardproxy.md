---
date: 2018-09-19 01:14:39 +0800
title: "http.forwardproxy"
sitename: "Caddy中文文档"
---

# http.forwardproxy

允许Caddy服务器作为一个安全的Web代理。通过以下形式有效地转发HTTP请求：GET someplace.else/thing.html HTTP/1.1。建立安全的TCP隧道:CONNECT someotherweb.server HTTP/1.1。

支持HTTP/2.0，也是被强烈推荐的方式，因为它支持多路复用。

[全部文档](https://github.com/caddyserver/forwardproxy/blob/master/README.md)

## 示例

__默认正向代理__

```caddy
forwardproxy
```

启动默认的未经身份验证的转发代理。小心使用，因为其他人可能开始使用(滥用)您的代理。

__需要授权的正向代理__

```caddy
forwardproxy {
    basicauth caddyuser1 0NtCL2JPJBgPPMmlPcJ
    basicauth caddyuser2 秘密
}
```

需要完成授权才能使用转发代理。

__抵御探测的正向代理__

```caddy
forwardproxy {
    basicauth caddyuser1 0NtCL2JPJBgPPMmlPcJ
    probe_resistance hiddenlink-u13PJVFur3.localhost
}
```

启用(实验性的)探测抵御，试图隐藏站点是正向代理的事实。如果凭证不正确或不存在，代理将不再响应“需要407代理身份验证”，并将尝试在其他方面模拟通用的无代理Caddy服务器。你可以选择指定hiddenlink，当访问该链接时，它将提示407响应。身份验证是必须的。

__从内存生成和服务PAC文件__

```caddy
forwardproxy {
    serve_pac proxyautoconfig.pac
}
```

在内存中生成并在给定路径上提供代理自动配置(参见<https://en.wikipedia.org/wiki/Proxy_auto-config>)文件。如果没有提供路径，PAC文件通过网址`/proxy.pac`提供。

__对被访问网站隐藏用户IP__

```caddy
forwardproxy {
    hide_ip
}
```

代理将停止向"Forwarded:"头添加用户的IP。

