---
date: 2018-09-18 23:34:34 +0800
title: "http.expires"
sitename: "Caddy中文文档"
---

# http.expires

expires允许设置相对于请求时间的过期头信息。它允许你根据与正则表达式匹配的路径设置不同的过期时间。

[完整文档](https://github.com/epicagency/caddy-expires/blob/master/README.md)

## 语法

```caddy
expires {
    match regex duration
}
```

* __match__: 路径的正则表达式以及过期时间。

match子指令可以重复多次，但只使用与路径首次匹配上的配置。

duration是按顺序排列的0y0m0d0h0i0s的组合。部件可以省略。

## 示例

__各种资源的过期时间__

```caddy
expires {
    match some/path/.*.css$ 1y # expires
    css files in some/path after one year
    match .js$ 1m # expires
    js files after 30 days
    match .png$ 1d # expires
    png files after one day
    match .jpg$ 1h # expires
    jpg files after one hour
    match .pdf$ 1i # expires
    pdf file after one minute
    match .txt$ 1s # expires
    txt files after one second
    match .html$ 5i30s # expires
    html files after 5 minutes 30 seconds
}
```

你可以按照你的需要指定各种粒度的过期指令。

使用第一个匹配规则。
