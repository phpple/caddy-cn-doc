---
date: 2018-09-19 08:51:49 +0800
title: "http.ipfilter"
sitename: "Caddy中文文档"
---

# http.ipfilter

ipfilter指令增加了基于客户端IP地址允许或阻止请求的能力。

[完整文档](https://github.com/pyed/ipfilter/blob/master/README.md)

## 示例

__过滤特定的IP或[CIDR](https://zh.wikipedia.org/wiki/无类别域间路由)范围__

```caddy
ipfilter / {
    rule block
    ip 70.1.128.0/19 2001:db8::/122 9.12.20.16
}
```

caddy会阻止IP地址分别属于`70.1.128.0/19`和`2001:db8::/122`范围的客户端，或者显示地IP为`9.12.20.16`的客户端。

__基于国家ISO代码过滤客户端__

```caddy
ipfilter / {
    rule allow
    database /data/GeoLite.mmdb
    country US JP
}
```

在Caddyfile这样配置的话，Caddy将只服务于来自美国或日本的用户。

使用国家代码进行过滤需要本地的Geo数据库副本，可以从[MaxMind](https://dev.maxmind.com/geoip/geoip2/geolite2/)免费下载。

__定义块页面__

```caddy
ipfilter / {
    rule allow
    blockpage default.html
    ip 55.3.4.20 2e80::20:f8ff:fe31:77cf
}
```

Caddy将只服务这两个ip，其他人将只能访问到`default.html`。

__多个路径__

```caddy
ipfilter /notglobal /secret {
    rule allow
    ip 84.235.124.4
}
```

只允许IP为`84.235.124.4`的用户访问`/notglobal`和`/secret`。

__多个块__

```caddy
ipfilter / {
    rule allow
    ip 32.55.3.10
}

ipfilter /webhook {
    rule allow
    ip 192.168.1.0/24
}
```

你可以使用尽可能多的`ipfilter`块，上面的意思是：只允许`32.55.3.10`，其他人都被阻止，除非他的IP是在`192.168.1.0/24`范围内且请求的是`/webhook`网址。

