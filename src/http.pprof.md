---
date: 2018-09-11 20:25:18 +0800
title: "http.pprof"
sitename: "Caddy中文文档"
---

# http.pprof

pprof在/debug/pprof下发布节点上的运行时分析数据。您可以访问/debug/pprof来获取可用节点的索引。

这是一个调试工具。某些请求(例如收集执行跟踪)可能很慢。如果您在在线站点使用pprof，请考虑限制访问或仅临时启用它。

有关更多信息，请参阅[Go的pprof文档](https://golang.org/pkg/net/http/pprof/)并阅读[Go程序性能分析](https://blog.golang.org/profiling-go-programs)。

## 语法

```caddy
pprof
```

## 示例
启用pprof节点：

```caddy
pprof
```