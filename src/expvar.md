---
date: 2018-09-09 23:10:51 +0800
title: "http.expvar"
sitename: "Caddy中文文档"
---

# http.expvar

expvar以JSON格式公开关于运行时或当前进程状态的变量。默认访问网址是/debug/vars。默认情况下，它报告内存统计信息、用于运行Caddy的命令和goroutines的数量。

> 这是一个调试工具。虽然通常在在线站点使用是安全的，但要注意不要泄露任何敏感信息。还要注意，这个插件可以添加到已发布的值列表中。

更多信息，轻查看[Go的expvar文档](https://golang.org/pkg/expvar/)。

## 语法

```caddy
expvar [path]
```

* __path__ 展示变量的网址。默认值是/debug/vars。

## 示例

在默认路径启用expvar：

```caddy
expvar
```

在一个指定的路径启用expvar：

```caddy
expvar /stats
```