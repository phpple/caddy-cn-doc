---
date: 2018-10-07 20:16:19 +0800
title: "自己插入插件"
sitename: "Caddy开发者wiki"
template: "wiki"
---

# 自己插入插件

_<small>英文原文：<https://github.com/mholt/caddy/wiki/Plugging-in-Plugins-Yourself></small>_

_________________________

你可以从源代码构建Caddy并插入插件，而不必使用构建服务器。你只需要安装好[Go](https://golang.org/doc/install)，然后通过这个操作获取代码库：

```bash
$ go get github.com/mholt/caddy/caddy
```

它将被保存在`$GOPATH/src`的子文件夹中。(默认的`GOPATH`为`$HOME/go`)。

打开`caddy/caddymain/run.go`，在文件的顶部添加一个导入到你正在安装的插件包中：

```go
// This is where other plugins get plugged in (imported)
    _ "your/plugin/package/path/here"
```

例如，插入http.git插件：

```go
_ "github.com/abiosoft/caddy-git"
```

然后在同一个文件夹的命令行上运行：

```go
$ go run build.go
```

定制的二进制文件`caddy`将被保存在可以运行的文件夹中。