---
date: 2018-12-04 23:14:10 +0800
title: "Caddy的Discourse配置"
sitename: "Caddy配置示例"
template: "example"
---

# Caddy的Discourse配置

通过Caddy运行[Discourse](https://www.discourse.org/)非常简单。安装完Discourse以后，你需要稍微调整容器的配置。

```bash
cd /var/discourse
sudo nano containers/app.yml
```

找到有`expose:`的一行并修改为：

```yaml
expose:
  - "8080:80"   # http
# - "443:443"   # https
```

这几行将主机端口映射到容器端口。因此，我们将真实的端口8080设置为映射到容器的端口80。你可以将8080更改为你想要的任意高端口号。然后禁用443映射，因为Caddy已经为我们准备好了TLS。

同时，关于证书的几行也可以注释掉了，因为caddy会取代它们。

```yaml
#  - "templates/web.ssl.template.yml"
#  - "templates/web.letsencrypt.ssl.template.yml"
```

请参阅后面的Caddyfile，了解如何反向代理到Discourse。正如你所料的，非常简单。

修改好`app.yml`后，启动Caddy，重启容器：

```bash
sudo ./launcher rebuild app
```

稍等一会后，Discourse的安装就将随Caddy在线展示了。