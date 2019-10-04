---
date: 2018-12-01 01:15:40 +0800
title: "CMS Made Simple的Caddy配置"
sitename: "Caddy配置示例"
template: "example"
---

# CMS Made Simple的Caddy配置

这篇文章介绍了通过Caddy使用[CMS Made Simple](https://www.cmsmadesimple.org/)的配置。



CMS Made Simple 需要满足这样一些[最低要求](https://docs.cmsmadesimple.org/installation/requirements)。

本示例使用如下架构：

* Ubuntu 16.04 Server
* PHP version 7.0
* MariaDB


## 安装Caddy
安装caddy，更换用户名。

给caddy创建一个专用目录：

```bash
mkdir ~/caddy
```

下载Caddyfile并且更换为你的域名。


下载`caddy@.service`，更换为PHP文件使用的用户名，邮箱地址也换成你的，并且添加到`/etc/systemd/system/caddy@.service`。

安装caddy。如果有需要，也可以选择[hugo](http.hugo.md)或者[git](http.git.md)等插件，把`~/caddy`目录切换成你的用户名。

```bash
curl https://getcaddy.com | bash -s ipfilter,ratelimit
sudo setcap cap_net_bind_service=+ep /usr/local/bin/caddy
sudo systemctl daemon-reload
sudo systemctl stop caddy@username
sudo systemctl start caddy@username
sudo systemctl enable caddy@username
```

## 安装PHP和MariaDB

在Ubuntu系统，我们可以使用下面的命令来安装：

```bash
sudo apt update

sudo apt install php7.0-common php7.0-cli php7.0-curl php7.0-fpm php7.0-gd \
php7.0-gd php7.0-json php7.0-mbstring php7.0-mysql php7.0-mysql \
php7.0-opcache php7.0-readline php7.0-xml mariadb-server
```

安装MariaDB并且创建数据库。

```bash
# 1) sudo to root
sudo su

# 2) Go through steps securing your database. Add root password for your database.
mysql_secure_installation

# 3) Start MariaDB database CLI, use root password you created at previous step
mysql -hlocalhost -uroot -p

# 4) Set your whole database to use UTF-8.
SET character_set_server = 'utf8';

# 5) Set database result ordering. Yours could be different.
SET collation_server = 'utf8_swedish_ci';

# 6) Create database for CMS Made Simple. You could name differently.
CREATE DATABASE simple;

# 7) Create user for that database, and add password. Change to your own.
CREATE USER 'simple'@'localhost' IDENTIFIED BY 'password';

# 8) Give previously created user access to datatabase
GRANT ALL PRIVILEGES ON simple.* to 'simple'@'localhost';

# 9) Take these new settings to be used immediately, and exit.
FLUSH PRIVILEGES;
exit
```

更换`/etc/php/7.0/fpm/php.ini`的配置为你需要的参数：

```ini
; Maximum upload filesize
upload_max_filesize = 2G
; Maximum post size, may contain multiple files
post_max_size = 4G
max_file_uploads = 20
max_execution_time = 120
max_input_time = 60
memory_limit = 128M
; Disable showing errors
error_reporting = E_ALL & ~E_NOTICE & ~E_DEPRECATED
```

这个php.ini文件禁用了pnctl功能，因为安全原因，在Ubuntu系统下是默认被禁用的。所以虽然有的扩展需要它，我也没有启用它。


```ini
disable_functions = pcntl...
```

更换`/etc/php/7.0/fpm/pool.d/www.conf`的用户为你的CMS Made Simple文件对应的用户：

```
user = username
group = username
listen.owner = username
listen.group = username
```

## 安装CMS Made Simple

[下载最新的CMS Made Simple的PHP安装文件](http://www.cmsmadesimple.org/downloads/)


添加到`~/caddy/example.com/public/cmsms-[VERSION]-install.php`

在`https://example.com/cmsms-[VERSION]-install.php`使用安装向导安装它。

在配置中加入URL转发功能：

```
cd ~/caddy/example.com/public/
sudo nano config.php
# Add this line to bottom:
$config['url_rewriting'] = 'mod_rewrite';
```

你可以将下面的内容保存成`reload-caddy.sh`脚本，将域名改成你自己的，将`caddy@username`中的username改成php文件对应的用户：

```bash
#!/bin/bash
sudo systemctl daemon-reload
sudo systemctl stop caddy@username
sudo systemctl stop php7.0-fpm
sudo systemctl start php7.0-fpm
sudo systemctl start caddy@username
# Delete CMS Made Simple cache files
rm ~/caddy/example.com/public/tmp/cache/*
rm ~/caddy/example.com/public/tmp/templates_c/*
And make it executeable:

chmod +x ./reload-caddy.sh
```

在需要的时候就可以运行了：

```bash
./reload-caddy.sh
```

## Caddyfile

```caddy
example.com {
	root /home/username/caddy/example.com/public
	fastcgi / /var/run/php/php7.0-fpm.sock php

	rewrite {
		to {path} {path}/ /index.php?page={uri_escaped}
	}
}

```

## caddy@service脚本

```bash
; see `man systemd.unit` for configuration details
; the man section also explains *specifiers* `%x`

[Unit]
Description=Caddy HTTP/2 web server %I
Documentation=https://caddyserver.com/docs
After=network-online.target
Wants=network-online.target
Wants=systemd-networkd-wait-online.service

[Service]
; run user and group for caddy
User=username
Group=username
ExecStart=/usr/local/bin/caddy -conf=/home/username/caddy/Caddyfile -agree -email="firstname.lastname@example.com"
Restart=on-failure
StartLimitInterval=86400
StartLimitBurst=5
RestartSec=10
ExecReload=/bin/kill -USR1 $MAINPID
; limit the number of file descriptors, see `man systemd.exec` for more limit settings
LimitNOFILE=1048576
LimitNPROC=64
; create a private temp folder that is not shared with other processes
PrivateTmp=true
PrivateDevices=true
ProtectSystem=full
CapabilityBoundingSet=CAP_NET_BIND_SERVICE
AmbientCapabilities=CAP_NET_BIND_SERVICE
NoNewPrivileges=true

[Install]
WantedBy=multi-user.target
```