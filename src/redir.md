---
name: "http.redir"
sitename: "Caddy中文文档"
---

# http.redir
`redir`会在网址符合指定模式时发送给客户端HTTP重定向的状态码。也可以创建一个有条件的重定向。


## 语法

```caddy
redir from to [code]
```

* __from__ 匹配的请求路径（必须精确匹配，除非是匹配全部路径的`/`）。

* __to__ 要跳转到的路径（可以使用[请求占位符](placeholders.md)）。
* __code__ 相应的HTTP状态码；必须是300-308之间（不包括306）。也可以为浏览器发送meta的重定向标记。默认状态码是"301 Moved Permanently"。

创建一个永久，全部重定向的指令，忽略*from*值。

```caddy
redir to
```

如果你有很多重定向，可以通过创建一个块来共享重定向代码。

```caddy
redir [code] {
    from to [code]
}
```

每一行定义一条重定向，且可以有选择性地覆盖在块顶部定义的重定向代码。如果没有指定重定向代码，则使用默认值。

也可以是有条件的一组重定向

```caddy
redir [code] {
    if    a cond b
    if_op [and|or]
    ...
}
```

* __if__ 指定一个重写条件，在默认情况下，多个if条件会通过AND组合在一起。`a`和`b`可以是任何字符串，也可以使用[请求占位符](placeholders.md)。`cond`是条件，使用在重写中解释的可能的值（也有可能包含if表达式）。

* __if_op__ 指定了连接多个if条件；默认值是`and`。

## 保留路径

默认情况下，重定向从精确匹配的路径到你定义的精确路径。您可以在任何"to"参数中使用占位符来保存请求URL的路径或其他部分，如`{uri}`或`{path}`，只支持[请求占位符](placeholders.md)。


## 示例
* 当收到来自`/resources/images/photo.jpg`的一个请求, 使用307状态码（临时重定向）重定向到`/resources/images/drawing.jpg`：

```caddy
redir /resources/images/photo.jpg /resources/images/drawing.jpg 307
```

* 把所有请求冲向到https://newsite.com，并保留请求URI：

```caddy
redir https://newsite.com{uri}
```

* 定义一组除了最后一个外都使用307状态码的重定向：

```caddy
redir 307 {
    /foo     /info/foo
    /todo    /notes
    /api-dev /api       meta
}
```

* 只有请求协议是HTTP时才进行重定向：

```cadday
redir 301 {
    if {>X-Forwarded-Proto} is http
    /  https://{host}{uri}
}
```

