---
date: 2018-12-07 22:53:29 +0800
title: "Ghost的Caddy配置"
sitename: "Caddy配置示例"
template: "example"
---

# Ghost的Caddy配置

这是如何使用Caddy服务[Ghost](https://ghost.org/)的配置文件。

## 准备条件
Ghost的官方推荐技术栈是：

* Ubuntu 16.04
* MySQL
* Systemd
* 通过NodeSource安装的Node v6

下面的每一步安装都必须是通过非root但有sudo权限的用户。

如果是Ubuntu，我们可以用下面的命令安装必须的依赖项：

```bash
sudo apt-get update
sudo apt-get upgrade
sudo apt-get install nginx
sudo apt-get install mysql-server
```

`Ghost-CLI`需要给MySQL设置一个root密码，否则将会导致一个[ER_NOT_SUPPORTED_AUTH_MODE](https://docs.ghost.org/docs/troubleshooting#section-error-with-mysql-er_not_supported_auth_mode)的错误。

运行加固设置是安装(和安全)MySQL最简单的方法：

```bash    
sudo mysql_secure_installation
```
接下来，我们需要为Node 6添加NodeSource APT存储库：

```bash
curl -sL https://deb.nodesource.com/setup_6.x | sudo -E bash
```
并且安装好Node.js：
```bash
sudo apt-get install -y nodejs
```

注意Node.js必须在系统范围内安装。不推荐使用NVM，因为它通常会导致node的本地安装，从而导致它不能在Ghost中很好地工作(如果有的话)。

## 安装Ghost-CLI

Ghost提供了一个非常方便的CLI，我们可以使用以下命令安装它：

```bash
sudo npm i -g ghost-cli
```

您可以通过键入`ghost help`检查安装是否完成。

## 通过Ghost-CLI安装Ghost

多亏了Ghost-CLI，安装Ghost只需三个步骤：

1. 创建站点的目录
2. 修改权限
3. 安装Ghost

先来创建一个新目录：
```bash
sudo mkdir -p /var/www/ghost
```

修改目录的所有者和权限：

```bash
sudo chown [user]:[user] /var/www/ghost
sudo chmod 775 /var/www/ghost
```
将[user]替换为一个非root，但有sudo权限的帐号。

然后，进入该目录并安装Ghost：

```bash
cd /var/www/ghost
ghost install
```

Ghost会问你一系列的问题。大部分的你都可以按回车键来使用默认项。需要你注意的提示如下：


1. Enter your blog Url:
2. Enter your MySQL hostname [localhost]:
3. Enter your MySQL username:
    如果您还没有为Ghost设置MySQL用户，请使用root。随后Ghost-CLI将为Ghost设置一个MySQL用户。
4. Enter your MySQL password: [hidden]
5. Ghost database name:
6. Do you wish to set up a ghost MySQL user?
    Yes (y), 这是推荐选项，Ghost-CLI将为你自动设置。
7. Do you wish to set up nginx?
    No (n), 我们想使用Caddy，难道不是吗？
8. Do you wish to set up ssl?
    No (n), Caddy对此非常熟练。
9. Do you wish to set up systemd?
10. Do you want to start Ghost?

好了，Ghost准备好了！现在我们需要编辑Caddyfile。使用本例中提供的示例作为指导。

更新Ghost非常简单:只需在Ghost文件夹中运行`Ghost update`。

## 故障排除

如果由于这样或那样的原因导致安装中途停止，你可以使用命令ghost设置来恢复。

如果不知道问题出在哪里，运行`ghost doctor`将进行Ghost-CLI运行测试，以识别安装中的问题。有了错误代码，请查看Ghost官方文档的[故障排除页面](https://docs.ghost.org/v1.0.0/docs/troubleshooting)。

对于致命错误，你可能需要清除文件夹(不仅是文件夹内的内容，而且是整个文件夹)，然后在创建文件夹时重新开始。

有时需要手动设置systemd。执行以下命令：

```bash
ghost setup systemd
```

另一个常见的错误是混淆了文件权限。作为一个非root的sudo用户，运行以下命令来回到正轨：

```bash
sudo find /var/www/ghost/* -type d -exec chmod 775 {} \;
sudo find /var/www/ghost/* -type f -exec chmod 664 {} \;
```

有关其他故障排除，请参考文档丰富、易于理解的[官方Ghost文档](https://docs.ghost.org/docs)。

## Caddyfile

```caddy
www.mycoolghostblog.com {
    gzip
    proxy / localhost:2368 {
        transparent
    }
}
```