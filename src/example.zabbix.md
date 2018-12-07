---
date: 2018-12-08 00:23:32 +0800
title: "Zabbix的Caddy配置"
sitename: "Caddy配置示例"
template: "example"
---

# Zabbix的Caddy配置

<img src="https://assets.zabbix.com/img/logo.svg" width="150"/>

如果你已经准备好了[zabbix](https://www.zabbix.com/)服务器，但是希望把apache切换成caddy服务器，那么下面的Caddyfile对你可能会有所帮助。

注意，在启动caddy之前需要关闭apache，因为两者都试图绑定相同的端口(可能)。

```bash
apache2ctl stop
```

而且，这也假定你已经安装了php5-fpm，仍然使用默认套接字运行。

## Caddyfile

```bash
zabbix.mydomain.tld {
    root /usr/share/zabbix
    status 404 {
        /conf
        /app
        /include
        /local
    }
    fastcgi / /var/run/php5-fpm.sock php
}
```
