---
date: 2018-12-08 23:05:27 +0800
title: "Wordpress的Caddy配置"
sitename: "Caddy配置示例"
template: "example"
---

# Wordpress的Caddy配置

<img src="https://s.w.org/style/images/wporg-logo.svg?3" height="80"/>

这是如何通过caddy使用[WordPress](https://wordpress.org/)的配置示例。

## 准备内容

WordPress需要安装如下[必须项](https://wordpress.org/about/requirements/)：

- PHP版本≥5.6
- MySQL版本≥5.5

如果使用Ubuntu，我们可以使用下面的命令安装它们：

```bash
sudo apt-get update
sudo apt-get install mysql-server php5-mysql php5-fpm
```

安装期间，MySQL将会要求设置root密码。

要完成安装，我们需要激活MySQL并使用安全安装：

````
sudo mysql_install_db
sudo /usr/bin/mysql_secure_installation
````

## 创建WordPress数据库

具备所有先决条件后，我们可以继续为WordPress创建一个新的MySQL数据库和用户。


首先，登录MySQL：
````
mysql -u root -p
````

现在，创建数据库和用户：

````
CREATE DATABASE wordpress;
CREATE USER wordpressuser@localhost;
SET PASSWORD FOR wordpressuser@localhost= PASSWORD("password");
GRANT ALL PRIVILEGES ON wordpress.* TO wordpressuser@localhost IDENTIFIED BY 'password';
FLUSH PRIVILEGES;
exit
````

上述脚本完成了如下事情：
1. 创建`wordpress`数据库
2. 创建用户`wordpressuser`
3. 给此用户设置密码
4. 授权此用户使用`wordpress`库的授权
5. 载入新的用户设置

你可以随意以不同的方式命名数据库或用户。

## 下载/安装WordPress

我们可以从官网获得最新版本的Wordpress：

````
curl -SL http://wordpress.org/latest.tar.gz | tar --strip 1 -xzf -
````
使用本页的Caddyfile，并确保fastcgi监听端口9000。

现在，我们终于可以运行Caddy了。如果一切正常，只要访问`http://localhost:8080`, WordPress就会向你发出问候。从这里开始，WordPress将指导你完成其余的设置。

## 故障排除

你可能遇到的最常见错误是`502 Bad Gateway`。在这种情况下，按照以下步骤进行：

- 检查`/var/log/php5-fpm.log`中记录的错误
- 添加`errors visible`到`Caddyfile`文件
- 通常php-fpm没有运行都是因为错误的权限设置，检查错误日志并修改`/etc/php5/fpm/pool.d/www.conf`中的用户。
- 切换到Unix套接字也可能会管用。修改`/etc/php5/fpm/pool.d/www.conf`中的listen为`listen = unix:/var/run/php5-fpm.sock`并且调整`Caddyfile`中同步修改。
- 如果使用unix套接字，请确保Caddy能够访问该套接字文件。

否则，搜索关于如何为Nginx设置`fastcgi`的指南。fastcgi的配置对于Nginx和Caddy是一样的，但是Nginx有更多的在线教程。

## Caddyfile

```caddy
localhost:8080

root <WP站点php文件所在目录>
gzip
fastcgi / 127.0.0.1:9000 php

# 防止恶意PHP上传运行
rewrite {
	r /uploads\/(.*)\.php
	to /
}

rewrite {
	if {path} not_match ^\/wp-admin
	to {path} {path}/ /index.php?{query}
}
```