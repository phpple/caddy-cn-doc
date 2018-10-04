---
date: 2018-10-01 18:14:36 +0800
title: "开发插件：服务器类型"
sitename: "Caddy开发者wiki"
template: "wiki"
---

# 开发插件：服务器类型

_<small>英文原文：<https://github.com/mholt/caddy/wiki/Writing-a-Plugin:-Server-Type></small>_

----------------------------

加入[Caddy交流论坛](https://caddy.community/)和其他开发者一起分享。

Caddy附带一个HTTP服务器，但是你可以实现其他服务器类型并将它们插入Caddy中。其他类型的服务器可以是SSH、SFTP、TCP、内部使用的其他东西等等。

对于Caddy来说，服务器的概念是任何可以`Listen()`和`Serve()`的东西。这意味着什么、如何运作都取决于你。你可以自由地发挥你的创造力去使用它。

如果你的服务器类型可以使用TLS，那么它应该利用Caddy的神奇TLS特性。我们将在本指南的最后描述如何做到这一点。

在一个高的层面上而言，使用[caddy.RegisterServerType()](https://godoc.org/github.com/mholt/caddy#RegisterServerType)函数实现一个服务器类型插件非常容易。传入服务器类型的名称，以及描述它的[caddy.ServerType](https://godoc.org/github.com/mholt/caddy#ServerType)结构即可。

下面是一个(稍微简化了一些)HTTP服务器的示例:

```caddy
import "github.com/mholt/caddy"

func init() {
    caddy.RegisterServerType("http", caddy.ServerType{
        Directives: directives,
        DefaultInput: func() caddy.Input {
            return caddy.CaddyfileInput{
                Contents:       []byte(fmt.Sprintf("%s:%s\nroot %s", Host, Port, Root)),
                ServerTypeName: "http",
            }
        },
        NewContext: newContext,
    })
}
```

如你所见，服务器类型包括名称(“http”)、指令列表、默认的Caddyfile输入(可选，但推荐)和上下文。现在我们将分别讨论这些。

## 指令

每个服务器类型都要定义它所识别的指令，以及它们应该以什么顺序执行。这只是一个字符串列表，其中每个字符串都是一个指令的名称：

```caddy
var directives = []string{
    "dir1",
    "dir2",
    "etc",
}
```

在大多数服务器类型中，执行顺序非常重要，因此如果不在此列表中，则不会执行指令。

## 默认Caddyfile输入

这是可选的，但是强烈建议你不要默认使用空白的Caddyfile。这对你的服务器类型意味着什么取决于你自己。但是你可以返回一个`caddy.CaddyfileInput`实例以满足此功能。只有在需要时，Caddy才会调用你的函数。

## 上下文

Caddy试图避免尽可能多的全局状态。当Caddy加载、解析和执行Caddyfile时，它是在一个称为[实例](https://godoc.org/github.com/mholt/caddy#Instance)的作用域中执行的，这样一组服务器可以单独管理，多个服务器类型可以在同一个进程中启动。

每次Caddy经过这个启动阶段，都会创建一个新的`caddy.instance`。实例和Caddy将向你的服务器类型请求一个新的`caddy.Context`值，以便在不共享全局状态的情况下执行服务器的指令。阅读`caddy.Context`的[godoc](https://godoc.org/github.com/mholt/caddy#Context)，获取更多信息。

不应该使用服务器类型存储上下文列表；它们将与实例一起存储，并且可以[从控制器访问](https://godoc.org/github.com/mholt/caddy#Controller.Context)。如果服务器稍后停止运行，那么保持对上下文的引用将防止它们被垃圾收集，这很可能造成内存泄漏。

最终，您的目标是使`MakeServers()`返回一个[caddy.Server](https://godoc.org/github.com/mholt/caddy#Server)列表供Caddy使用。你怎么做完全取决于你自己。

例如：HTTP服务器[使用其上下文类型](https://github.com/mholt/caddy/blob/aede4ccbce94bcb67161674e30dd1bfa7296448c/caddyhttp/httpserver/plugin.go#L54-L63)保存站点配置的map。这个包还有一个公有函数`GetConfig(c Controller)`，它为某个站点获取配置，传入指定的[caddy.Controller](https://godoc.org/github.com/mholt/caddy#Controller)。配置依次存储中间件列表等——所有设置站点所需的信息。每个指令的操作都调用GetConfig函数，帮助正确地设置站点。在调用`MakeServers()`时，只需将这些站点配置合并到服务器实例中并返回它们。(服务器实例实现了[caddy.Server](https://godoc.org/github.com/mholt/caddy#Server)。)

## 服务器

`caddy.Server`的接口同时考虑了TCP和非TCP服务器。它有四个方法：两个针对TCP，两个针对UDP或其他：

```go
type Server interface {
    TCPServer // Required if using TCP
    UDPServer // Required if using UDP or other
}

type TCPServer interface {
    Listen() (net.Listener, error)
    Serve(net.Listener) error
}

type UDPServer interface {
    ListenPacket() (net.PacketConn, error)
    ServePacket(net.PacketConn) error
}
```
如果你的服务器只使用TCP，`*Packet()`方法可能是空操作(即返回nil)。而非TCP服务器则与此相反。服务器还可以同时使用TCP和UDP，并实现所有四种方法。

一旦这些接口被实现，并且正确地从Caddyfile指令应用了配置，你的服务器类型就可以运行了。


## 自动TLS

可以使用TLS的服务器类型应该在将TLS添加到Caddy下载页面之前自动启用TLS。导入[caddytls](https://godoc.org/github.com/mholt/caddy/caddytls)包以使用Caddy的魔术 TLS特性。乍一看，这似乎有点令人困惑，但一旦它起作用，你会喜欢它，并意识到它是值得的。

* 你需要一种方式来为你的服务器实例存储Caddy TLS配置。通常，这只意味着向服务器的配置结构中添加一个字段。
* 相同的服务器配置结构类型应该实现[caddytls.ConfigHolder](https://godoc.org/github.com/mholt/caddy/caddytls#ConfigHolder)接口。这只是一些getter方法。
* 在包的init()中调用[RegisterConfigGetter()](https://godoc.org/github.com/mholt/caddy/caddytls#RegisterConfigGetter)，这样caddytls包就知道在为服务器类型解析Caddyfile时如何请求配置。(如果给定控制器中还不存在配置，你的“配置getter”必须创建一个新的`caddytls.Config`。
* 将`tls`指令添加到服务器类型的指令列表中。通常它位于列表的最前面。

当你实例化实际的服务器值并需要`tls.Config`时，可以调用[caddytls.MakeTLSConfig(tlsConfigs)](https://godoc.org/github.com/mholt/caddy/caddytls#MakeTLSConfig)，其中`tlsConfigs`是`[]caddytls.Config`。这个函数将一个Caddy的TLS配置列表转换为一个标准库的`tls.Config`。然后，你可以在对[tls.NewListener()](https://golang.org/pkg/crypto/tls/#NewListener)的调用中使用它。

最后，你通常希望在分析Caddyfile时启用TLS。例如，HTTP服务器在执行`tls`指令后立即配置HTTPS。你应该使用包的`init()`函数注册一个解析回调函数，该回调函数将遍历配置并配置TLS：

```go
// 将"http"替换成你自己的服务器类型
caddy.RegisterParsingCallback("http", "tls", activateHTTPS)
```

这段代码在`tls`指令完成设置后执行`activateHTTPS()`函数。你的服务器类型应该有一个类似的函数，以一种合理的方式启用TLS。为了给你一个概念，HTTP服务器的`activateHTTPS`函数做了以下工作：

1. 打印一条信息到标准输出，“激活隐私功能…”(Activating privacy features...)(如果操作出现；例如，`caddy.Started() == false`)，因为这个过程可能需要几秒钟。
2. 在所有应该完全管理的配置上将`Managed`字段设置为`true`。
3. 为每个配置调用 [ObtainCert()](https://godoc.org/github.com/mholt/caddy/caddytls#Config.ObtainCert) (此方法仅在配置正确并将其`Managed`字段设置为true时才获得证书)。
4. 通过将TLS配置的`Enabled`字段设置为`true`并调用caddytls.CacheManagedCertificate()来配置服务器结构以使用新获得的证书，而[caddyls .cachemanagedcertificate()](https://godoc.org/github.com/mholt/caddy/caddytls#CacheManagedCertificate)实际上是将证书加载到内存中以供使用。
5. 调用[caddytls.SetDefaultTLSParams()]以确保所有必要的字段都有一个值。
6. 调用[caddytls.RenewManagedCertificates(true)](https://godoc.org/github.com/mholt/caddy/caddytls#RenewManagedCertificates)，以确保在必要时已将所有已加载到内存中的证书更新。

还有很多很多，但是你还可以[看看HTTP服务器是如何工作的](https://github.com/mholt/caddy/blob/c75ee0000e1677737e0f05efe8de4c101814b848/caddyhttp/httpserver/https.go#L12)(<--这是一个永久链接，所以最新的代码可能更好)。

为了保持完美的前向保密，你应该在实例化服务器值时调用[caddytls.RotateSessionTicketKeys()](https://godoc.org/github.com/mholt/caddy/caddytls#RotateSessionTicketKeys)，传入TLS配置。请确保在服务器停止时关闭它返回的通道。

TLS的所有其他内容：续订、OCSP和其他维护都会为你进行，因为所有服务器类型都是相同的。所有这些步骤只是将你的服务器类型与Caddy的TLS包连接起来，这样它就知道如何完成它的工作。

彻底测试caddytls包的集成。一旦运行良好，让我们将你的服务器类型添加到下载页面！