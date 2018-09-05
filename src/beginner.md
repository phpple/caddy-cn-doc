+++
title = "新手入门"
sitename = "caddy中文文档"
template = "tutorial"
+++

# 新手入门
这个向导将帮助你完成首次安装、运行、配置caddy。我们是假定你从未使用过任何web服务器软件（加入你已经使用过，可以直接阅读[快速开始](tutorial.md)）。虽然caddy可以很快学会如何使用，我们还是希望你了解下面这些操作：
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
