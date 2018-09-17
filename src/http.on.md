---
date: 2018-09-17 10:17:08 +0800
title: "http.on"
sitename: "Caddy中文文档"
---

# http.on

on在触发指定事件时执行命令。这对于通过运行脚本或在服务器启动时启动php-fpm这样的后台进程，或在服务器退出时停止php-fpm，为站点准备服务非常有用。

执行的每个命令都是阻塞的，除非在命令后面加上空格和`&`，这会使得命令在后台运行。(当服务器退出时不要这样做，否则命令可能无法在父进程退出之前完成。)命令的输出和错误分别转到`stdout`和`stderr`。没有`stdin`。

命令每次出现在Caddyfile中只会被执行一次。换句话说，即使这个指令被多个主机共享，一个命令每次在Caddyfile中只执行一次。

注意，如果Caddy被强制终止，例如使用操作系统提供的“强制退出”特性，那么为关闭事件计划的命令将不会执行。但是，典型的SIGINT (Ctrl+C)将允许执行关闭命令。

## 语法

```caddy
on event command
```

* __event__ 是执行命令的事件的名称(参见下面的列表)
* __command__ 是要执行的命令；后面可以跟参数

## 事件
命令可以通过以下事件被执行：

* __startup__ 服务器实例首先启动
* __shutdown__ 服务器实例正在关闭(不是重新启动)
* __certrenew__ 一个托管证书被更新

## 示例

在服务器开始监听之前启动php-fpm：

```caddy
on startup /etc/init.d/php-fpm start
```

服务器退出时停止php-fpm：

```caddy
on shutdown /etc/init.d/php-fpm stop
```

在Windows上，当命令路径包含空格时，你可能需要使用引号：

```caddy
on startup "\"C:\Program Files\PHP\v7.0\php-cgi.exe\" -b 127.0.0.1:9123" &
```