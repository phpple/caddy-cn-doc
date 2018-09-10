---
date: 2018-09-10 08:32:49 +0800
title: "http.fastcgi"
sitename: "Caddy中文文档"
---

# http.fastcgi

fastcgi代理对FastCGI服务器的请求。尽管这个指令最常见的用途是服务PHP站点，但默认情况下它是一个通用的FastCGI代理。这个指令可以在不同的请求路径下多次使用。

## 语法

```caddy
fastcgi path endpoint [preset] {
    root     directory
    ext      extension
    split    splitval
    index    indexfile
    env      key value
    except   ignored_paths...
    upstream endpoint
    connect_timeout duration
    read_timeout    duration
    send_timeout    duration
}
```

* __path__ 是转发请求之前要匹配的基本路径。
* __endpoint__ 是FastCGI服务器的地址或Unix套接字。
* __preset__ 是可选的预设名称(见[下文](#预设))。使用预设值时，不需要重复预设值的个别设定。
* __root__ 如果与虚拟主机的根目录不同，则指定FastCGI服务器使用的根目录。如果FastCGI服务器在另一个服务器上、根目录监狱(chroot-jailed)、和/或容器化的服务器上，那么它是有用的。
* __ext__ 指定后缀，如果请求URL具有该后缀，则该扩展将代理请求到FastCGI。
* __split__ 指定如何拆分URL；分割值成为第一部分的结尾，在它之后的任何URL中的内容成为PATH_INFO CGI变量的部分。
* __index__ 指定如果URL没有指定文件时要尝试的默认文件。
* __env__ 用给定的_value_设置一个名为_key_的环境变量；env属性可以多次使用，值可以使用[请求占位符](placeholders.md)。
* __except__ 是要从fastcgi处理中排除的以空格分隔的请求路径列表，即使它与基路径匹配。
* __upstream__ 指定要使用的额外的后端。将执行基本负载平衡。可以多次指定。
* __connect_timeout__ 允许连接到后端的时间。必须是持续时间值(如"10s")。
* __read_timeout__ 从后端读取响应的时间。必须是持续时间值。
* __send_timeout__ 允许向后端发送请求的时间。必须是持续时间值。

对于HTTPS连接，为了兼容httpd的mod_ssl方式，这些环境变量将被设置：`HTTPS`、`SSL_PROTOCOL`和`SSL_CIPHER`。

## 预设

预设是某种FastCGI配置的简写。这些预设是可用的:

* __php__ 是这些配置的简写：

```
ext   .php
split .php
index index.php
```

你不需要为预置指定单独的配置设置。但是，如果需要，可以通过手动声明来覆盖它的各个设置。

## 示例
代理所有到FASTCGI应答器的请求到127.0.0.1:9000：

```caddy
fastcgi / 127.0.0.1:9000
```

将/blog中的所有请求转发到通过php-fpm服务的PHP站点(如WordPress)：

```caddy
fastcgi /blog/ 127.0.0.1:9000 php
```

使用自定义的FastCGI配置。

```
fastcgi / 127.0.0.1:9001 {
    split .html
}
```

使用PHP的预设，但是覆盖ext属性：

```caddy
fastcgi / 127.0.0.1:9001 php {
    ext .html
}
```

使用PHP预设，但FastCGI服务器运行在一个基于官方Docker映像的容器中(容器端口9000发布到127.0.0.1:9001)：

```caddy
fastcgi / 127.0.0.1:9001 php {
    root /var/www/html
}
```