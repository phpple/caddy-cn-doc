---
date: 2018-10-07 20:08:16 +0800
title: "在Go程序中嵌入Caddy"
sitename: "Caddy开发者wiki"
template: "wiki"
---

# 在Go程序中嵌入Caddy

_<small>英文原文：<https://github.com/mholt/caddy/wiki/Embedding-Caddy-in-your-Go-program></small>_

_________________________

在你的Go程序中，你可以把Caddy当作库。如果你的Go应用程序不仅仅需要Go的基本静态文件服务器或反向代理，那么这是非常有用的。当你需要重新加载程序时，你甚至可以利用Caddy优雅的重启功能。

你只需要一个[caddy](https://godoc.org/github.com/mholt/caddy)包。链接对应的godoc有详细的说明。

注意：如果不想创建原始的Caddyfile字符串，可以使用[caddyfile](https://godoc.org/github.com/mholt/caddy/caddyfile)包在该字符串和标识的JSON表示之间进行转换。它的结构简单，很容易用代码操作，而不是解析原始字符串。

下面是一个基本示例：

```go
caddy.AppName = "Sprocket"
caddy.AppVersion = "1.2.3"

// pass in the name of the server type this Caddyfile is for (like "http")
caddyfile, err := caddy.LoadCaddyfile(serverType)
if err != nil {
    log.Fatal(err)
}

instance, err := caddy.Start(caddyfile)
if err != nil {
    log.Fatal(err)
}

// Start() only blocks until the servers have started.
// Wait() blocks until the servers have stopped.
instance.Wait()
```

你也可以重启Caddy：

```go
// On Unix systems, you get graceful restarts.
// To use same Caddyfile, just pass in nil.
// Be sure to replace the old instance with the new one!
instance, err = instance.Restart(newCaddyfile)
if err != nil {
    log.Fatal(err)
}
```

或者停止他：

```go
err = instance.Stop()
if err != nil {
    log.Fatal(err)
}
```

下面是另一个示例，它从当前目录加载应用程序的Caddyfile：

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
    // configure default caddyfile
    caddy.SetDefaultCaddyfileLoader("default", caddy.LoaderFunc(defaultLoader))
}

func main() {
    caddy.AppName = "Sprocketplus"
    caddy.AppVersion = "1.2.3"

    // load caddyfile
    caddyfile, err := caddy.LoadCaddyfile("http")
    if err != nil {
        log.Fatal(err)
    }

    // start caddy server
    instance, err := caddy.Start(caddyfile)
    if err != nil {
        log.Fatal(err)
    }

    instance.Wait()
}

// provide loader function
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

请务必参考godoc获取caddy包的最新信息。好运！