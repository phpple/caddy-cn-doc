---
date: 2018-10-06 21:16:01 +0800
title: "开发插件：HTTP中间件"
sitename: "Caddy开发者wiki"
template: "wiki"
---

# 开发插件：HTTP中间件

_<small>英文原文：<https://github.com/mholt/caddy/wiki/Writing-a-Plugin:-HTTP-Middleware></small>_

----------------------------

加入[Caddy交流论坛](https://caddy.community/)和其他开发者一起分享。

这个页面描述了如何开发一个向HTTP服务器添加中间件的插件。

重要提示：你应该首先阅读[开发插件：指令](wiki.Writing-a-Plugin%3A-Directives.md)。本教程建立在它的基础上。

在本教程中，你将了解到如下内容：

* [HTTP中间件在Caddy中如何工作](#HTTP中间件在Caddy中如何工作)
* [如何开发Handler](#开发一个Handler)
* [如何添加Handler到Caddy](#如何添加Handler到Caddy)

## HTTP中间件在Caddy中如何工作

查看[httpserver包的godoc](http://godoc.org/github.com/mholt/caddy/caddyhttp/httpserver)。最重要的两种类型是[httpserver.Handler](https://godoc.org/github.com/mholt/caddy/caddyhttp/httpserver#Handler)和[httpserver.Middleware](https://godoc.org/github.com/mholt/caddy/caddyhttp/httpserver#Middleware)。

`Handler`是一个处理HTTP请求的函数。

`Middleware`是一种连接`Handler`的方式。

Caddy将负责为你设置HTTP服务器的所有簿记(bookkeeping)工作，但是你需要实现这两种类型。

## 开发一个Handler

`httpserver.Handler`是一个几乎和`http.Handler`完全一样的接口，除了`ServeHTTP`方法返回`(int, error)`。这个方法签名遵循Go语言博客中[关于与中间件相关的错误处理的建议](http://blog.golang.org/error-handling-and-go)。`int`是HTTP状态码，`error`应该被处理和/或记录。有关这些返回值的详细信息，请参阅godoc。

`Handler`通常是一个结构体，至少包含一个`Next`字段，用来链接下一个`Handler`：

```go
type MyHandler struct {
    Next httpserver.Handler
}
```

为了实现`httpserver.Handler`接口，我们需要编写一个名为`ServeHTTP`的方法。这个方法是实际的处理程序函数，除非它自己完全处理请求，否则它应该调用链中的下一个`Handler`：
```go
func (h MyHandler) ServeHTTP(w http.ResponseWriter, r *http.Request) (int, error) {
    return h.Next.ServeHTTP(w, r)
}
```

就是这样。

注意[竞态条件](https://baike.baidu.com/item/竞态条件/1321097)——尽可能避免进入状态，使用Go的[竞态探测器](https://blog.golang.org/race-detector)(`-race`)！

## 如何添加Handler到Caddy

回到设置函数。你刚刚解析了标识并使用所有适当的配置设置了中间件处理程序：

```go
func setup(c *caddy.Controller) error {
    for c.Next() {
        // get configuration
    }
    // now what?
}
```

要在新的处理程序中进行链接，请从`httpserver`包中获取当前站点的配置，然后将处理程序包装到一个中间件函数中：

```go
cfg := httpserver.GetConfig(c)
mid := func(next httpserver.Handler) httpserver.Handler {
    return MyHandler{Next: next}
}
cfg.AddMiddleware(mid)
```

你完成了！当然，在本例中，我们只是分配了一个没有特殊配置的`MyHandler`。在你的示例中，可能希望将配置存储在名为“rules”的结构中，这样就可以处理指令的多种用法并逐条添加规则。做与不做，这取决于你想做什么。只要你正确地链接了`next`，这真的不重要！