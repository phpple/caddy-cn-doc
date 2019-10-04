---
date: 2018-12-07 23:42:14 +0800
title: "在Go程序中中嵌入Caddy"
sitename: "Caddy开发者wiki"
template: "wiki"
---

# 在Go程序中中嵌入Caddy

_<small>英文原文：<https://github.com/mholt/caddy/wiki/Extending-Caddy></small>_

_________________________

加入[Caddy交流论坛](https://caddy.community/)和其他开发者一起分享。

你可以用Caddy作为你Go应用程序的库。如果你的Go应用程序需要的不仅仅是Go的基本静态文件服务器或反向代理，那么这一点非常有用。当你需要重新加载程序时，你甚至可以利用Caddy优雅的重启功能。

如果你只需要[caddy](https://godoc.org/github.com/mholt/caddy)包，链接的godoc有相关指令。

注意：如果你不想创建原始的Caddyfile字符串，可以使用Caddyfile包将字符串转化为通过JSON表示的标识。它结构简单，很容易使用代码操作，而不需要解析原始字符串。

下面是一个简单的例子：

```go
caddy.AppName = "Sprocket"
caddy.AppVersion = "1.2.3"

// 传入这个Caddyfile的服务类型名称（比如"http"）
caddyfile, err := caddy.LoadCaddyfile(serverType)
if err != nil {
    log.Fatal(err)
}

instance, err := caddy.Start(caddyfile)
if err != nil {
    log.Fatal(err)
}

// Start() 在服务启动完毕前处于阻塞状态
// Wait() 在服务停止前处于阻塞状态
instance.Wait()
```

你也能重启Caddy：

```go
// 在Linux系统，能使用平滑重启
// 要使用同一个Caddyfile，只需要传入nil
// 请务必使用新实例替换掉旧的！
instance, err = instance.Restart(newCaddyfile)
if err != nil {
    log.Fatal(err)
}
```

或者停止它：

```go
err = instance.Stop()
if err != nil {
    log.Fatal(err)
}
```

下面是另外一个例子，用来为你的应用从当前目录载入Caddyfile：

```go
package main

import (
    "io/ioutil"
    "log"
    "os"

    "github.com/mholt/caddy"
    _ "github.com/mholt/caddy/caddyhttp"
)

func init() {
    // 配置默认caddyfile
    caddy.SetDefaultCaddyfileLoader("default", caddy.LoaderFunc(defaultLoader))
}

func main() {
    caddy.AppName = "Sprocketplus"
    caddy.AppVersion = "1.2.3"

    // 载入caddyfile
    caddyfile, err := caddy.LoadCaddyfile("http")
    if err != nil {
        log.Fatal(err)
    }

    // 启动caddy服务
    instance, err := caddy.Start(caddyfile)
    if err != nil {
        log.Fatal(err)
    }

    instance.Wait()
}

// 提供载入功能
func defaultLoader(serverType string) (caddy.Input, error) {
    contents, err := ioutil.ReadFile(caddy.DefaultConfigFile)
    if err != nil {
        if os.IsNotExist(err) {
            return nil, nil
        }
        return nil, err
    }
    return caddy.CaddyfileInput{
        Contents:       contents,
        Filepath:       caddy.DefaultConfigFile,
        ServerTypeName: serverType,
    }, nil
}
```

请务必参考godoc获取caddy包的最新内容。好运！
