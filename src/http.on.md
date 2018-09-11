---
date: 2018-09-11 13:12:36 +0800
title: "http.on"
sitename: "Caddy中文文档"
---

# http.on

on在触发指定事件时执行命令。这对于为站点服务做准备很有用，比如当服务启动时运行一个脚本，或者启动php-fpm这样的后台进程，也可以在服务器退出时停止php-fpm。

执行的每个命令都是阻塞的，除非在命令后面加上空格和&使命令在后台运行。(当服务器退出时不要这样做，否则命令可能无法在父进程退出之前完成。)命令的输出和错误分别转到stdout和stderr。没有标准输入。

命令每次出现在Caddyfile中只执行一次。换句话说，即使这个指令被多个主机共享，一个命令每次在Caddyfile中只执行一次。

注意，如果Caddy被强制终止，那么为关闭事件计划的命令将不会执行，比如使用操作系统提供的"强制退出"功能。然而，典型的SIGINT(Ctrl+C)将允许执行关闭命令。

## 语法

```caddy
on event command
```

* __event__ 是执行命令的事件的名称(参见下面的列表)
* __command__ 是要执行的命令；接下来可能会有争论


## 事件

命令可以在以下事件上执行：

* __startup__ - 服务器实例首次启动
* __shutdown__ - 服务器实例正在关闭(不是重新启动)
* __certrenew__ - 托管证书已更新

## 示例

在服务器开始监听之前启动php-fpm：

```caddy
on startup /etc/init.d/php-fpm start
```

在服务器退出之前关闭php-fpm：

```caddy
on shutdown /etc/init.d/php-fpm stop
```

在Windows上，当命令路径包含空格时，您可能需要使用引号：

```
on startup "\"C:\Program Files\PHP\v7.0\php-cgi.exe\" -b 127.0.0.1:9123" &
```