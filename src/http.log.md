---
date: 2018-09-11 01:17:11 +0800
title: "http.log"
sitename: "Caddy中文文档"
---

# http.log

log用来启用请求日志。请求日志也被称为访问日志。

## 语法

在没有参数的情况下，所有日志都使用{common}格式的日志格式记录到access.log：

```caddy
log
```

自定义日志路径：

```caddy
log file
```

* __file__ 指相对于当前工作目录要创建(或附加到)日志文件的路径。有关如何指定输出位置的详细信息，请参阅[日志目标](http.log.md#destination)。默认是access.log。

将日志限制为只针对某些请求或更改日志格式：

```caddy
log path file [format]
```

* __path__ 要记录日志的基本请求路径。
* __file__ 相对于当前工作目录要创建(或追加)的日志文件。
* __format__ 为要使用的日志格式；默认是{common}日志格式。

大的日志文件会自动轮转。你可以通过打开一个块自定义日志轮转或其他事情：

```caddy
log path file [format] {
    rotate_size     mb
    rotate_age      days
    rotate_keep     count
    rotate_compress
    ipmask          ipv4_mask [ipv6_mask]
    except          paths...
}
```

* __rotate_size__ 是一个日志文件在滚动之前必须达到的兆字节大小。
* __rotate_age__ 是保存轮转日志文件的天数。
* __rotate_keep__ 是要保存的轮转日志文件的最大数量；旧的轮转日志文件则被删除。
* __rotate_compress__ 是压缩轮转日志文件的选项。gzip是唯一支持的格式。
* __ipmask__ 屏蔽某些IP地址屏蔽，以遵守公司或者法律的限制。第一个参数是IPv4地址的掩码，第二个参数是IPv6地址的掩码。IPv6掩码是可选的；如果只屏蔽IPv6,IPv4掩码可以是空字符串记号。
* __except__ 设置哪些路径可以被免除日志记录。如果需要的话，每行可以指定多个路径(空格分隔)，或者多次使用这个子指令。

## 日志格式

可以使用任何[占位符](placeholders.md)值指定自定义日志格式。日志同时支持请求和响应占位符。

目前有两个预定义的格式。

* {common} (默认)

```caddy
{remote} - {user} [{when}] \"{method} {uri} {proto}\" {status} {size}
```

* {combined} - 在{common}后面加上：

```caddy
\"{>Referer}\" \"{>User-Agent}\"
```

## 日志目标

日志目标可以是下面列举的其中一种：

* 一个相对于当前工作目录的文件名
* `stdout`或`stderr`，写入控制台
* `syslog` 写入本地系统日志(Windows除外)
* `syslog://host[:port]` 通过UDP写入到本地或远程syslog服务器
* `syslog+udp://host[:port]` 和上面一样
* `syslog+tcp://host[:port]` 通过TCP协议写入到本地或远程syslog服务器

## 日志轮转

日志有可能写满磁盘。为了缓和这一点，请求日志会根据下面的默认配置自动轮转(“滚动”):

```caddy
rotate_size 100 # 当日志达到100M时轮转它
rotate_age  14  # 保持轮转日志文件14天
rotate_keep 10  # 保留最多10个旋转的日志文件
rotate_compress # 压缩gzip格式的轮转日志文件
```

您可以指定这些子指令来自定义日志滚动。


## 示例

将所有日志打印记录到access.log：

```caddy
log
```

记录所有请求到标准输出：

```caddy
log stdout
```

自定义日志格式：

```caddy
log / stdout "{proto} Request: {method} {path}"
```

记录错误日志，自定义错误页面:

```caddy
errors {
    404 404.html # 页面找不到
    500 500.html # 服务器内部错误
}
```

使用预定义格式：

```caddy
log / stdout "{combined}"
```

使用日志轮转：

```caddy
log requests.log {
    rotate_size 50  # 50M以后轮转
    rotate_age  90  # 保持轮转文件90天
    rotate_keep 20  # 最多保持20个日志文件
    rotate_compress # 压缩gzip格式的轮转日志文件
}
```


屏蔽(匿名化)IPv4地址和IPv6地址到只保留8bit地址:

```caddy
log requests.log {
    ipmask 255.255.0.0 ffff:ffff:ffff:ff00::
}
```