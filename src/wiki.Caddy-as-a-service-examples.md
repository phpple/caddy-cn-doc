---
date: 2018-10-01 17:15:03 +0800
title: "Caddy注册服务示例"
sitename: "Caddy开发者wiki"
template: "wiki"
---

# Caddy注册服务示例

_<small>英文原文：<https://github.com/mholt/caddy/wiki/Caddy-as-a-service-examples></small>_

___________________

## systemd

请参阅[dist/init/linux-systemd](https://github.com/mholt/caddy/tree/master/dist/init/linux-systemd)以获取最新的完整的systemd单元文件。

你需要确保__systemd版本≥229__！例如：Ubuntu 16.04、Coreos 1029.0.0、Debian unstable sid (不是8.0)、Fedora rawhide（不是23），以及后来的systemd版本。

## FreeBSD rc.d

FreeBSD上的一个init脚本示例：
<https://gist.github.com/dprandzioch/f3a0bc4ebde3efd5c2a4>

## Windows

你可以使用[NSSM](https://nssm.cc/)，用以自动启动，崩溃后自动重启Caddy。

1. 首先下载[NSSM](https://nssm.cc/download)和[Caddy](https://caddyserver.com/download)，然后解压到`c:\myserver`。
2. 然后在终端输入下面的命令将caddy注册成为一个服务。
    
    ```cmd
    c:\myserver\nssm.exe install Caddy c:\myserver\caddy.exe
    c:\myserver\nssm.exe set Caddy AppDirectory C:\myserver\
    c:\myserver\nssm.exe set Caddy AppParameters -agree=true -log=C:\myserver\Caddylog.log
    ```
    第三行的命令也可以加入其它你需要输入的参数。

## Caddy-service

你可以下载一个已经嵌入了[caddy-service插件](hook.service.md)的Caddy。

1. [下载](https://caddyserver.com/download)嵌入caddy-service插件的Caddy。(`hook.service`选项)。

2. 安装和启动Caddy为一个服务。
```bash
caddy -service install [caddyOptions]
caddy -service start
```
