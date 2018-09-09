---
date: 2018-09-09 22:20:30 +0800
title: "http.errors"
sitename: "Caddy中文文档"
---

# http.errors

errors允许您设置自定义错误页面并启用错误日志记录。

如果没有这个中间件，就不会记录错误响应(HTTP状态码>=400)，客户端将收到明文错误消息。

使用错误日志，将记录每个错误的文本，这样您就可以在不向客户端公开这些细节的情况下确定出错的地方。使用错误页面，您可以显示自定义错误消息，并指示访问者如何操作。指定自定义错误页面时，将自动启用错误日志记录。

## 语法

```caddy
errors [logfile]
```

* __logfile__ 是相对于当前工作目录创建(或追加)错误日志文件的路径。有关如何指定输出位置的详细信息，请参阅[日志目标](#日志目标)。默认是`stderr`。
要指定自定义错误页面，请打开一个块：

```caddy
errors [logfile] {
    code     file
    rotate_size     mb
    rotate_age      days
    rotate_keep     count
    rotate_compress
}
```

* __code__ 可以是HTTP状态码(4xx、5xx或*用于默认错误页面)。
* __file__ 是错误页面的静态HTML文件(路径相对于站点根目录)。
* __rotate_size__ 是一个日志文件在滚动之前必须达到的大小，单位为M。
* __rotate_age__ 是保存旋转日志文件的天数。
* __rotate_keep__ 是要保存的轮转日志文件的最大数量；旧的轮转日志文件被删除。
* __rotate_compress__ 是压缩轮转日志文件的选项。gzip是唯一支持的格式。

## 日志目标

日志目标可以是下面列举的其中一种：

* 一个相对于当前工作目录的文件名
* `stdout`或`stderr`，写入控制台
* `visible` 将错误(如果适用的话，包括完整的堆栈跟踪)写入响应(除了本地调试之外不建议这样做)
* `syslog` 写入本地系统日志(Windows除外)
* `syslog://host[:port]` 通过UDP写入到本地或远程syslog服务器
* `syslog+udp://host[:port]` 和上面一样
* `syslog+tcp://host[:port]` 通过TCP协议写入到本地或远程syslog服务器

默认的日志目标是`stderr`。默认的日志目标是`stderr`。

## 日志轮转

日志有可能写满磁盘。为了缓和这一点，错误日志会根据这个默认配置自动轮转(“滚动”):

```caddy
rotate_size 100 # 当日志达到100M时轮转它
rotate_age  14  # 保持轮转日志文件14天
rotate_keep 10  # 保留最多10个旋转的日志文件
rotate_compress # 压缩gzip格式的轮转日志文件
```

您可以指定这些子指令来自定义日志滚动。

## 示例

将日志打印到`stderr`：

```caddy
errors
```

将错误记录到父目录中的自定义文件：
```caddy
errors ../error.log
```

记录错误日志，自定义错误页面:

```caddy
errors {
    404 404.html # 页面找不到
    500 500.html # 服务器内部错误
}
```

记录错误到指定的日志文件，提供自定义错误页面：

```caddy
errors ../error.log {
    404 404.html # 页面找不到
    500 500.html # 服务器内部错误
}
```

自定义一个默认的捕获厕所有错误的页面：

```caddy
errors {
    * default_error.html
}
```

使错误信息对客户端可见（仅用来调试）：

```caddy
errors visible
```

定制错误日志轮转：

```caddy
errors {
    rotate_size 50  # 50M以后轮转
    rotate_age  90  # 保持轮转文件90天
    rotate_keep 20  # 最多保持20个日志文件
    rotate_compress # 压缩gzip格式的轮转日志文件
}
```