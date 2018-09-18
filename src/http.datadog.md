---
date: 2018-09-18 23:32:00 +0800
title: "http.datadog"
sitename: "Caddy中文文档"
---

# http.datadog

Datadog插件允许Caddy HTTP/2 web服务器向[Datadog](https://www.datadoghq.com/)发送一些指标。

这个插件不仅可以使用Datadog，还可以兼容[statsd](https://github.com/etsy/statsd)的所有服务。

[完整文档](https://github.com/payintech/caddy-datadog/blob/master/README.md)

## 示例

```caddy
example-b.com {
  datadog {
    statsd 127.0.0.1:8125
    tags tag1 tag2 tag3
  }
}
```