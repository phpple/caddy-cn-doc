---
date: 2018-10-04 22:03:22 +0800
title: "开发插件：指令"
sitename: "Caddy开发者wiki"
template: "wiki"
---

# 开发插件：指令

_<small>英文原文：<https://github.com/mholt/caddy/wiki/Writing-a-Plugin:-Directives></small>_

----------------------------

加入[Caddy交流论坛](https://caddy.community/)和其他开发者一起分享。

这个页面描述了如何开发一个为Caddyfile注册新指令的插件。

指令可以在服务器启动或关闭、更改服务器配置等情况下运行代码。例如，常见的做法是使用指令来配置并向HTTP服务器注入中间件处理程序。

1. [创建一个新的Go包](#1. 创建一个新的Go包)
2. [实现设置函数](#2. 实现设置函数)
3. [对指令排序](#3. 对指令排序)
4. [插入你的插件(适用于任何插件)](#4. 插入你的插件)

## 1. 创建一个新的Go包

Caddy插件是Go包。创建一个新插件：导入`caddy`包并[注册你的插件](https://godoc.org/github.com/mholt/caddy#RegisterPlugin)。让我们创建一个名为“gizmo”的插件，它只针对HTTP服务器：

```go
import "github.com/mholt/caddy"

func init() {
    caddy.RegisterPlugin("gizmo", caddy.Plugin{
        ServerType: "http",
        Action:     setup,
    })
}
```

### 指令名称

你的指令插件的名字也是指令的名字。它一定是独一无二的！它应该是一个小写的单词。这是一个重要的简单性和可用性约定。

### 服务器类型

大多数指令只适用于特定类型的服务器。例如，“http”服务器类型(如[gzip](http.gzip.md)和 [fastcgi](http.fastcgi.md)的指令配置和注入中间件处理程序。这些类型的插件通常需要导入相关服务器类型的包。

有些指令不属于特定类型的服务器。例如，[tls](tls.md)是一个指令，任何服务器类型都可以使用它来利用Caddy强大的TLS功能；通过`startup`和`shutdown`则可以在服务器启动/停止时运行命令，无论它是什么类型的服务器。在这种情况下，`ServerType`字段可以保持为空。为了使用这些指令，必须对服务器类型进行编码以专门支持它们。

### 动作(“设置功能”)

`caddy.Plugin`结构的`Action`字段是插件指令的独特之处。这是Caddy在解析和执行Caddyfile时要运行的函数。

这个动作是`caddy.Controller`一个[简单的函数](https://godoc.org/github.com/mholt/caddy#SetupFunc)，返回一个error：

```go
func setup(c *caddy.Controller) error {
    return nil
}
```

接下来，我们来看看如何使用这个`Controller`来执行你的指令。

## 2. 实现Setup函数

在Caddy解析了Caddyfile之后，它将迭代每个指令名(按照服务器类型规定的顺序)，并在每次遇到指令名时调用指令的setup函数。setup函数的职责是解析指令的标识并配置自己。

[控制器](https://godoc.org/github.com/mholt/caddy#Controller)的结构使得这非常容易实现。注意，类型定义嵌入了`caddyfile.Dispenser`。如果我们希望在Caddyfile中有一行这样的行：

```caddy
gizmo foobar
```

我们可以得到第一个参数(“foobar”)的值，如下所示：

```go
for c.Next() {              // skip the directive name
    if !c.NextArg() {       // expect at least one value
        return c.ArgErr()   // otherwise it's an error
    }
    value := c.Val()        // use the value
}
```

您可以通过遍历`c.Next()`来解析为指令提供的标识，只要有更多的标识需要解析，那么`c.Next()`就会返回`true`。由于一个指令可能出现多次，你必须遍历`c.Next()`以获得所有出现的指令并使用第一个标识(即指令名)。

有关caddyfile包，请参阅[godoc](https://godoc.org/github.com/mholt/caddy/caddyfile)以了解如何更充分地使用分发器，并查看任何其他现有插件。

## 3. 对指令排序

最后一件要做的事情是告诉服务器类型在进程的什么地方执行你的指令。这一点很重要，因为其他指令可能会设置你所依赖的更原始的配置，因此执行指令的顺序不能是随意的。

每个服务器类型都有一个字符串列表，其中每个项都是一个指令的名称。例如，查看[HTTP服务器支持的指令列表](https://github.com/mholt/caddy/blob/d3860f95f59b5f18e14ddf3d67b4c44dbbfdb847/caddyhttp/httpserver/plugin.go#L314-L355)。将指令添加到适当的位置。

## 4. 插入你的插件

最后，不要忘记导入你的插件包！Caddy必须导入插件来注册并执行它。这通常是在[run.go](https://github.com/mholt/caddy/blob/master/caddy/caddymain/run.go)的`import`部分的尾部完成的：

```go
_ "your/plugin/package/here"
```

请注意：包名前的`_`是必需的。

就是这样！可以用你的插件来构建caddy，然后用你的新指令写一个Caddyfile来查看它的运行情况。

如果你正在开发HTTP中间件，[请继续到下一页](https://github.com/mholt/caddy/wiki/Writing-a-Plugin:-HTTP-Middleware)。



