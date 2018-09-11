---
date: 2018-09-11 22:05:37 +0800
title: "http.root"
sitename: "Caddy中文文档"
---

# http.root

root指定了站点的根目录。如果网站的根(/)目录与Caddy从哪里执行不同，那么这是非常有用的，实际上是必需的。

默认根目录是当前工作目录。相对根路径是相对于当前工作目录的。

## 语法

```caddy
root path
```

* __path__ 设置为站点根目录的路径

## 例子

使用杰克的public_html文件夹而不是当前的工作目录中服务网站：

```caddy
root /home/jake/public_html
```