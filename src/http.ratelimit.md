---
date: 2018-09-19 21:44:52 +0800
title: "http.ratelimit"
sitename: "Caddy中文文档"
---

# http.ratelimit

ratelimit用于限制基于客户端IP地址的请求处理速率。过多的请求将以返回错误429(Too Many Request)，并携带X-RateLimit-RetryAfter头信息。

[完整文档](https://github.com/xuqingfeng/caddy-rate-limit/blob/master/README.md)

## 示例

__单个资源__

```caddy
ratelimit methods path rate burst unit
```

* __methods__ 是它将匹配的请求方法(逗号分开)；
* __path__ 是应用速率限制的文件或目录;
* __rate__ 是一个时间单位内的最大请求次数(r/s、r/m、r/h、r/d、r/w)(例如1);
* __burst__ 是客户端可以超过的最大突发大小;burst>=rate(如2);
* __unit__ 是时间间隔(当前支持:秒、分钟、小时、日、周)。

__多个资源__

```caddy
ratelimit methods rate burst unit {
    whitelist CIDR
    resources
}
```

* __whitelist__ 是可信IP白名单的关键词，[CIDR](https://zh.wikipedia.org/wiki/无类别域间路由)是你不想执行速率限制的IP范围，白名单是一个通用规则，它不会针对特定的资源;
* __resources__ 是应用速率限制的文件/目录列表，每行一个。

注意：如果你不想将速率限制应用于一些特殊的资源，在路径前面加上^。

__将客户端限制为每秒2次请求(突发3次)，限制为/r下的任何方法和资源__

```caddy
ratelimit * /r 2 3 second
```

__如果请求来自1.2.3.4或192.168.1.0/30(192.168.1.0 ~ 192.168.1.3)，不要执行速率限制，对于列出的路径，如果请求方法是GET或POST，则将客户机限制为每分钟2个请求(突发2次)，并且总是忽略/dist/app.js__

```
ratelimit 2 2 minute {
    whitelist 1.2.3.4/32
    whitelist 192.168.1.0/30
    /foo.html
    /api
    ^/dist/app.js
}
```






