---
date: 2018-12-04 22:25:53 +0800
title: "Concrete5的Caddy配置"
sitename: "Caddy配置示例"
template: "example"
---

# Concrete5的Caddy配置

这是让Caddy支持[Concrete5](http://www.concrete5.org/)的配置示例。

这个示例基于如下配置：

* Ubuntu 16.04 Server
* PHP version 7.0
* MariaDB

## 安装配置

安装caddy，切换用户。


创建Caddy的目录

```bash
mkdir ~/caddy
```

下载Caddyfile，将域名改成你自己的。

下载caddy@.service, 改成php文件使用的用户名，将email改成你的，添加到`/etc/systemd/system/caddy@.service`。

安装Caddy。将用户名和`~/caddy`的用户名保持一致。

```bash
curl https://getcaddy.com | bash -s ipfilter,ratelimit
sudo setcap cap_net_bind_service=+ep /usr/local/bin/caddy
sudo systemctl daemon-reload
sudo systemctl stop caddy@username
sudo systemctl start caddy@username
sudo systemctl enable caddy@username
```

为了方便重启，你可以把下面的内容保存为`reload-caddy.sh`脚本，将域名改成你自己的，将`caddy@username`的用户改成你的PHP文件对应的用户：

```bash
#!/bin/bash
sudo systemctl daemon-reload
sudo systemctl stop caddy@username
sudo systemctl stop php7.0-fpm
sudo systemctl start php7.0-fpm
sudo systemctl start caddy@username
```

添加可执行权限：

```bash
chmod +x ./reload-caddy.sh
```

然后你可以它来重启：

```bash
./reload-caddy.sh
```

## 安装PHP和MariaDB

在Ubuntu操作系统，你可以使用下面的命令安装它们：

```bash
sudo apt update

sudo apt install php7.0-common php7.0-cli php7.0-curl php7.0-fpm php7.0-gd \
php7.0-gd php7.0-json php7.0-mbstring php7.0-mysql php7.0-mysql \
php7.0-opcache php7.0-readline php7.0-xml mariadb-server curl zip unzip
```

__安全安装MariaDB并创建数据库__


```bash
# 1) 用sudo切换到root账号
sudo su

# 2) 按步骤安全安装数据库，给数据库设置root账号的密码。
mysql_secure_installation

# 3) 使用上一步设置的root账号密码启动MariaDB数据库
mysql -hlocalhost -uroot -p

# 4) 将数据库编码设置为UTF-8.
SET character_set_server = 'utf8';

# 5) 设置数据库结果集，你也可以设置成其他的。
SET collation_server = 'utf8_swedish_ci';

# 6) 创建Concrete5的数据库，你可以改成其他的。
CREATE DATABASE concrete5;

# 7) 给数据库创建用户和密码。改成你自己的。
CREATE USER 'concrete5'@'localhost' IDENTIFIED BY 'password';

# 8) 授权给上一步创建的用户
GRANT ALL PRIVILEGES ON concrete5.* to 'concrete5'@'localhost';

# 9) 使设置马上生效。
FLUSH PRIVILEGES;
exit
```

可以参考下面的设置修改`/etc/php/7.0/fpm/php.ini`：

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

修改`/etc/php/7.0/fpm/pool.d/www.conf`的用户和Concrete5文件保持一致：

```
user = username
group = username
listen.owner = username
listen.group = username
```

[下载](http://www.concrete5.org/download)Concrete5的发行版本，我使用的是8.x。

对于开发版，你可以按下面的指导克隆代码库。

[下载](http://www.concrete5.org/developers/translate/)管理界面的语言包。我下载了8.x的开发版的。

## 安装Concrete5

```bash
# 1) 给你的域名创建一个目录
mkdir -p ~/caddy/example.com

# 2) 进入该目录
cd ~/caddy/example.com

# 3a) 解压Concrete5的压缩包
unzip ~/concrete[VERSION].zip

# 重命名目录为public
mv concrete[VERSION] public

# 3b) 对于开发板，直接clone代码库即可
git clone https://github.com/concrete5/concrete5.git public

# 4) 进入public下的concrete子目录
cd public/concrete

# 5) 解压你的语言包
unzip ~/core-dev-[VERSION-LANGUAGE].zip
```

6. 访问`https://example.com`按照向导完成安装。

7. 在安装前，你可以选择好管理界面的语言。如果你想先选择英语，然后对漂亮的网址做一些必要的修改，它也之后在`System & Settings/Basics/Languages`中进行修改。

8. 安装以后，在`https://example.com/index.php/login`登录（或者随后在`https://example.com/login`登录)。默认的管理员账号是admin。

9. 进入`System & Settings/SEO & Statistics/URLs`设置重定向。

10. 如果想要漂亮网址，勾选"[X] Remove index.php from URLS"并点击保存。

11. 进入`System & Settings/Optimization/Clear Cache`，点击“清除缓存”。

12. 退出。现在网站的网址应该都没有index.php了。但是在管理界面还有，但是正常网站访问者是看不到的。

## Caddyfile

```caddy
example.com {

	root /home/username/caddy/example.com/public

	fastcgi / /var/run/php/php7.0-fpm.sock php

	rewrite {
		to {path} {path}/index.html {path}/index.php /index.php/{uri_escaped}
	}

}
```

## caddy@.service

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