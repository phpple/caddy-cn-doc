---
title: "gzip"
sitename: "Caddy中文文档"
---

# http.cors

Caddy默认不支持此功能。如果需要，下载之前需要勾选上`http.cors`插件。

[完整文档](https://github.com/captncraig/cors/blob/master/README.md)


## 例子

* 简单用法

```caddy
cors
```
允许所有来源访问所有资源

* 只允许指定的来源访问域名

```caddy
cors / http://mytrusteddomain.tld http://myotherdomain.com
```

只允许来自指定的几个域名的跨域请求。

* 完整配置

```caddy
cors / {
    origin            http://allowedSite.com
    origin            http://anotherSite.org https://anotherSite.org
    methods           POST,PUT
    allow_credentials false
    max_age           3600
    allowed_headers   X-Custom-Header,X-Foobar
    exposed_headers   X-Something-Special,SomethingElse
}
```
这个例子展示了所有可用的选项。