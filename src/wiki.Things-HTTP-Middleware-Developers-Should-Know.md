---
date: 2018-10-10 08:49:07 +0800
title: "HTTP中间件开发人员应该知道的事情"
sitename: "Caddy中文文档"
template: "wiki"
---

# HTTP中间件开发人员应该知道的事情

_<small>英文原文：<https://github.com/mholt/caddy/wiki/Things-HTTP-Middleware-Developers-Should-Know></small>_

----------------------------

本文完善中(WIP)。

* 使用`httpserver.Path`比较基本路径，以了解你的处理器是否应该处理请求(例如：`httpserver.Path(r.URL.Path).Matches(myHandler.BasePath))`
* 不要直接使用来自请求的路径访问文件系统，因为这样做容易受到路径遍历攻击。应该这样：
  - 要打开文件，使用`http.Dir`(标准库)
  - 对于其他内容，请使用`httpserver.SafePath`去找一条经过特殊处理的路径
* 如果中间件访问磁盘上的文件，则对`HiddenFiles`字段使用[SiteConfig](https://godoc.org/github.com/mholt/caddy/caddyhttp/httpserver#SiteConfig)结构。
* 如果需要包装或记录响应，请将自己的ResponseWriter类型使用`httpserver.ResponseWriterWrapper`类型包装，这样可以保证它实现一些关键的接口。
* `http.Request.URL`(尤其是它的`.Path`值)可能会被其他“重写”中间件更改。你总是可以通过上下文访问原始传入URL：`req.Context().Value(httpserver.OriginalURLCtxKey).(url.URL)`
* 指令(和子指令)遵循`underscore_convention`来命名。小写字母，下划线作为单词分隔符。可能有很少的例外(例如，`header`指令使用header字段名，比如`Content-Type`作为子指令)，但通常尝试遵循这种约定。它将使用户对中间件的体验与Caddy的其余部分保持一致。避免驼峰或使用`-`分隔单词。
* 指令的第一个参数(如果适用)通常是用于匹配请求的基本路径。
* 与[staticfiles.IndexPages](https://godoc.org/github.com/mholt/caddy/caddyhttp/staticfiles#pkg-variables)一起使用[httpserver.IndexFile()](https://godoc.org/github.com/mholt/caddy/caddyhttp/httpserver#IndexFile)，用于确定文件是否是索引文件。

__对于插件作者(TODO:当我们获得足够的内容时，移动到单独的文章)：__

* 插件可能使用vendor目录作为依赖而且不导出vendor目录里的类型(也就是说，它们不与Caddy或任何其他插件共享vendor类型)。请参阅<https://github.com/mattfarina/golang-broken-vendor>，了解为什么这很糟糕。(注意/待办事项：在Go 1.9发布之前，插件应该只允许通过Caddy构建检查的供应商副总裁，比如`test -race`和`vet`。因为Go 1.8-工具不会忽略供`vendor`/目录...)
* 不要vendor`github.com/mholt/caddy`或者该代码库中的任何包，或任何你的插件“resisters”的包也插入到Caddy中。这样做将会导致你的插件使用vendor副本注册，而不是“main”包的编译源。