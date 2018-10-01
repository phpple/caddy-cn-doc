---
date: 2018-10-01 14:03:11 +0800
title: "扩展Caddy"
sitename: "Caddy开发者wiki"
template: "wiki"
---

# 扩展Caddy

_<small>英文原文：<https://github.com/mholt/caddy/wiki/Extending-Caddy></small>_

_________________________

加入[Caddy交流论坛](https://caddy.community/)和其他开发者一起分享。

Caddy可以基于插件进行扩展。插件为Caddy添加了缺失的功能。它们在编译时“插入”。

Caddy的每个构成几乎都是插件。HTTP服务器是一个插件。Caddy的高级TLS功能是插件。你在Caddyfile中输入的每个指令都是一个插件。

一些插入到Caddy核心，而另一些插入到特定的服务器类型。一些插件甚至插入到其他插件中(例如，`DNS提供者`插入到`tls`插件中)。Caddy默认会附带一些基本插件：HTTP服务器及其标准指令，以及标准Caddyfile加载器。

你可以为Caddy提供不同的插件：

* __[服务器类型](wiki.Writing-a-Plugin%3A-Server-Type)__ 一种Caddy可以运行的服务器(例如HTTP和DNS)。
* __[指令](https://github.com/mholt/caddy/wiki/Writing-a-Plugin:-Directives)__ Caddyfile的一个指令。
* __[HTTP中间件](https://github.com/mholt/caddy/wiki/Writing-a-Plugin:-HTTP-Middleware)__ 处理HTTP请求的函数，通常由Caddyfile指令调用。
* __[Caddyfile加载器](https://github.com/mholt/caddy/wiki/Writing-a-Plugin:-Caddyfile-Loader)__ 自定义Caddyfile加载的方式。
* __[DNS服务商](https://github.com/mholt/caddy/wiki/Writing-a-Plugin:-DNS-Provider)__ 让ACME的DNS挑战与你的DNS服务商兼容。
* __监听器中间件__ 通过包装一个`net.Listener`使用自己的侦听器在传输层或协议层执行某些操作。
* __事件钩子__ 当Caddy进程发出某些事件时，执行一个函数。

上面的链接将向你展示如何编写这些插件，但是当你遇到问题时，请始终参考[godoc](https://godoc.org/github.com/mholt/caddy)和[代码库本身](https://sourcegraph.com/github.com/mholt/caddy)！

<br>

## 5步完成一个Caddy插件

虽然有不同种类的插件，但是创建一个插件的过程对所有人来说都是一样的。

### 1. 创建一个包并注册你的插件

用init函数启动一个新的Go包，用Caddy注册你的插件，也可以注册服务器类型或其他类型的插件。使用的注册函数取决于插件的类型。以下是一些例子：

```go
import "github.com/mholt/caddy"

func init() {
    // 注册一个“通用”插件，比如一个指令或者中间件
    caddy.RegisterPlugin("name", myPlugin)

    // 注册一个当Caddy启动时加载Caddyfile的插件
    caddy.RegisterCaddyfileLoader("name", myLoader)

    // 注册一个实现了一个完整的服务器类型的插件，以便与Caddy一起使用
    caddy.RegisterServerType("name", myServerType)

    // 注册一个在Caddy发出事件时运行的函数
    caddy.RegisterEventHook("eventName", myHookFn)

    // 添加一个包装HTTP服务器侦听器的函数
    // （通常被一个指令调用，而不是作为一个独立的插件使用）
    httpserver.AddListenerMiddleware(myListenerMiddleware)

    // ... 还有一些其他用法，请查看godoc。
}
```

每个插件都必须有一个名称，在适用的情况下该名称对于该服务器类型必须是唯一的。

### 2. 插入你的插件

要将插件插入到Caddy中，请导入它。这通常是在__[run.go](https://github.com/mholt/caddy/blob/master/caddy/caddymain/run.go)__的顶部附近完成。

```go
import _ "your/plugin/package/path/here"
```

### 3. 测试、测试、测试！

编写[测试用例](https://golang.org/pkg/testing)，尽可能保证良好的覆盖率，并确保你的断言测试你认为它们正在测试的内容！使用`go vet`和`go test -race`来确保你的插件尽可能的没有错误。

### 4. 将插件添加到Caddy网站

让别人更容易找到和使用你的插件，[按照这些说明](https://github.com/mholt/caddy/wiki/Publishing-a-Plugin-to-the-Download-Page)将插件添加到Caddy的下载页面。

### 5. 维护你的插件

人们愿意使用有用的、有清晰文档记录的、易于使用的和由其所有者维护的插件。

同时恭喜你，你就是Caddy插件的作者！

