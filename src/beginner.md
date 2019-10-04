---
title: "新手入门"
sitename: "Caddy中文文档"
template: "tutorial"
---

# 新手入门
这个向导将帮助你完成首次安装、运行、配置caddy。我们是假定你从未使用过任何web服务器软件（假如你已经使用过，可以直接阅读[快速开始](tutorial.md)）。虽然caddy可以很快学会如何使用，我们还是希望你了解下面这些操作：

* 查找、移动、重命名文件
* 管理用户和文件权限
* 使用终端命令
* 配置防火墙

具备了上述经验，你就做好开始的准备了。

## 话题
1. [下载](#下载)
2. [安装](#安装)
3. 运行
4. 配置

## 下载

从[下载页面](https://dengxiaolong.com/caddy/doc/download.html)下载caddy。基本上你可以下载到任何操作系统和架构对应的caddy版本。caddy的下载页面有别于其他的web服务器：允许定制自己需要的插件。

对于本向导而言，你不需要任何插件。

有的时候下载页面在维护，你可以通过[github](https://github.com/mholt/caddy)下载到[最新的版本](https://github.com/mholt/caddy/releases/latest)（没有插件）。

## 安装

你下载到的是一个压缩包，需要对其解压缩获取到二进制文件（可执行文件）。

> __Windows__

> 右键.zip文件，选择“解压全部”，解压到常见的目录。解压完了，压缩文件就可以删除掉了。

> __macOS__

> 双击.zip文件直接解压。或者运行命令行：

> `$ unzip caddy*.zip caddy`

> __Linux__

> 运行命令：

> `$ tar -xzf caddy*.tar.gz caddy`



下一步，你可以把caddy的二进制文件移动到你可以轻易执行的位置。

> __Windows__

> 移动到你可以轻易找到的地方，比如`C:\Caddy`。

> __macOS__

> 任何`$PATH`包含的路径即可，如：

> `$ mv ./caddy /usr/local/bin`

> 如果获取到没有权限的错误，可以在前面增加`sudo`指令。

> __Linux__

> 任何`$PATH`包含的路径即可，如：

> `$ mv ./caddy /usr/local/bin`

## 运行

默认情况下，Caddy使用当前目录（执行命令的目录，而不是caddy二进制文件所在目录）作为网站根目录，因此运行本地站点非常方便。

使用终端或者命令行，切换到站点目录所在：

```bash
cd path/to/my/site
```

运行caddy：
> __Windows__

> 假设caddy的.exe文件在`C:\Caddy`目录，运行
> 
> `C:\Caddy\caddy.exe`

> __macOS__

> `caddy`

> __Linux__

> `caddy`

在浏览器打开<http://localhost:2015/>，如果出现404页面，说明caddy运行正常，但是网站缺少默认页面。

你可以使用`Ctrl+C`退出，caddy将尽可能优雅中断。

## 配置
你的站点已经可以用于生产环境了，不过现在还并不完美，因为我们还只是在本地你自己的电脑上运行：

* 站点是运行在2015端口，而不是80端口（标准http端口）。
* 另外，站点还没有支持HTTPS。

你只需要把网站的“名字”告诉Caddy，就可以很轻松地解决这两个问题了。当然，这里所说的“名字”，就是网站的域名了。我们将用“example.com”作为例子，你还是使用你真正的域名。接下来的操作，需要保证你的电脑能通过公网访问到80和443端口，并且域名被解析到你的电脑。反之，如果你还没有域名，你可以先使用“localhost”作为替代。

网站的“名字”又被称为“主机”或者“主机名”。可以通过一个参数指定主机：
> __Windows__

> `C:\Caddy\caddy.exe -host example.com`

> __macOS__

> `$ caddy -host example.com`

> __Linux__

> `$ caddy -host example.com`

当第一次使用一个真正的域名（不是localhost）运行Caddy时，会出现提示要求输入你的email地址。这是因为Caddy需要验证你的域名，并将验证信息安全地存储在硬盘上。


当提交你的email地址后，你是否看到了权限方面的报错？这是因为Caddy必须将40和443端口绑定到一个真正的站点，而这需要root或者Administrator的权限：

> __Windows__

> 右键cmd.exe，点击“用管理员运行”，然后运行Caddy：
> `C:\Caddy\caddy.exe -host example.com`

> __macOS__

> 使用`sudo`命令运行caddy

> `$ caddy -host example.com`

> __Linux__

> 使用`sudo`命令运行caddy

> `$ caddy -host example.com`

如果权限正确的话，你将会看到：
```bash
Activating privacy features... done.
https://example.com
http://example.com
```
使用真正的域名因为是对80和443端口进行操作，会触发Caddy的隐私政策。如果你只是使用`localhost`作为主机名的话，Caddy会继续使用2015作为端口，除非你通过`-port`选项指定别的端口。

[命令行接口](cli.md)比使用Caddy配置来得更快。但是你想不想每次都能复用同样的配置呢？使用Caddyfile将更加简单。

__Caddyfile__用来告诉Caddy如何提供服务的文本文件。他通常和网站放在一起。我们来创建一个：


> __Windows__

> 在网站目录创建一个名叫的文件，然后输入一行内容（使用你真实的域名，或者`localhost`）：
> 
> `example.com`

> __macOS__

> 使用你真实的域名（或者`localhost`）：

> `$ echo example.com > Caddyfile`

> __Linux__

> 使用你真实的域名（或者`localhost`）：

> `$ echo example.com > Caddyfile`

Caddy启动的时候会自动查找到该文件。
> __Windows__

> `caddy`

> __macOS__

> `$ caddy`

> __Linux__

> `$ caddy`

Caddyfile的第一行总是用来表示站点的访问地址（或者名称），因此只需简单的一行就管用了。

如果Caddyfile放在另外的目录，你需要告诉Caddy准确的位置：

> __Windows__

> `caddy -conf C:\path\to\Caddyfile`

> __macOS__

> `$ caddy -conf ../path/to/Caddyfile`

> __Linux__

> `$ caddy -conf ../path/to/Caddyfile`

你基本已经知道最需要了解的部分了。接下来，你将进一步了解如何使用[Caddyfile](caddyfile.md)，相信你会喜欢它的简单易用。

或者进入“[文档](./)”页面。
