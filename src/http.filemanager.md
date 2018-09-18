---
date: 2018-09-18 23:45:05 +0800
title: "http.filemanager"
sitename: "Caddy中文文档"
---

# http.filemanager

filemanager是基于[browse中间件](http.browse.md)的扩展。它在指定的目录中提供了一个文件管理接口，可以用于在该目录中上载、删除、预览和重命名文件。

如果你在处理大型文件时遇到麻烦，你可能需要查看[timeouts](timeouts.md)插件，它可以用来更改默认的HTTP超时。

[完整文档](https://filebrowser.github.io/caddy/)

## 示例

__基本用法__

```caddy
filemanager
```

展示Caddy第一个域名对应的网站根目录。

__浏览特定的目录__

```caddy
filemanager / ./foo
```

在域名的根目录显示`foo`目录的内容。

__使用特定的网址浏览__

```caddy
filemanager /filemanager
```

通过`/filemanager`网址显示caddy所在的根目录。