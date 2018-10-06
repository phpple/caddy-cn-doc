---
date: 2018-10-06 21:51:17 +0800
title: "开发插件：Caddyfile加载器"
sitename: "Caddy开发者wiki"
template: "wiki"
---

# 开发插件：Caddyfile加载器

_<small>英文原文：<https://github.com/mholt/caddy/wiki/Writing-a-Plugin:-Caddyfile-Loader></small>_

----------------------------

加入[Caddy交流论坛](https://caddy.community/)和其他开发者一起分享。

你可以自定义Caddy如何加载Caddyfile。如果你使用外部工具或服务管理服务器配置，并且希望动态地从它们获取Caddyfile，那么这将非常有用。如果你打对了牌，你甚至可以在改变upstream的时候让Caddy重新加载Caddyfile。

你所要做的就是实现[caddy.Loader](https://godoc.org/github.com/mholt/caddy#Loader)接口，并使用一个唯一的名字注册你的插件。

这里有一段示意代码：

```go
import "github.com/mholt/caddy"

func init() {
    caddy.RegisterCaddyfileLoader("myloader", caddy.LoaderFunc(myLoader))
}

func myLoader(serverType string) (caddy.Input, error) {
    return nil, nil
}
```

如果你的加载器需要更多的状态，你可以直接使用`struct`实现`caddy.Loader`接口，而不是像我们之前做的那样使用包装器类型`caddy.LoaderFunc`。简单加载器只需要是独立的函数。

加载器应该在错误值得中止并报告给用户时才返回错误。换句话说，不要仅仅因为没有要加载的Caddyfile就返回错误。

## 如何使用加载器

当Caddy启动时，它迭代不同的加载器，请求它们提供Caddyfile。它总是调用所有加载器，但最多只有一个应该返回值。这意味着你的加载器不要返回`caddy.Input`，除非条件刚好。例如：如果设置了特定的环境变量，或者使用命令行标记来填充值，这些都是关于如何加载Caddyfile的特定条件。

使用多种方式调用Caddy来加载Caddyfile会让人感到困惑，并将被视为错误。

因此，如果你想要编写一个Caddyfile加载器来连接到etcd，例如，确保它只有在设置了访问etcd的环境变量，才会返回一个Caddyfile。

## 设置默认的Caddyfile加载器

当没有其他加载程序返回Caddyfile时，可以多次设置默认的Caddyfile加载程序。为此，只需调用`caddy.SetDefaultCaddyfileLoader()`，而不是`caddy.RegisterCaddyfileLoader()`。注意，这将覆盖以前的任何默认加载器。

如果默认加载器不返回任何Caddyfile输入，Caddy将向服务器类型请求默认输入。如果服务器类型没有指定默认输入，则假定为空白的Caddyfile。

## 动态重载

可以开发一个Caddyfile加载器，以便Caddy在更改新Caddyfile时重新加载并应用它。实现细节差别很大，但是你可以像这样让Caddy重新加载新的Caddyfile：

(TODO)