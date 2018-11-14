---
date: 2018-11-14 10:20:07 +0800
title: "QUIC"
sitename: "Caddy开发者wiki"
template: "wiki"
---

# QUIC

_<small>英文原文：<https://github.com/mholt/caddy/wiki/QUIC></small>_

----------------------------

Caddy的0.9版本已经提供由[lucas-clemente/quic-go](https://github.com/lucas-clemente/quic-go)提供的供实验用的QUIC支持。想要试试它，可以运行caddy的时候使用-quic标识：

```bash
caddy -quic
```

如果客户支持使用TLS，那么你使用TLS服务的站点将与QUIC一起穿梭。

## 客户端支持

Chrome 52+支持QUIC，不需要白名单，但要确保将#enable-quic标记设置为启用(还可以使用命令行标志`--enable-quic`)。然后打开Chrome到你的网站，它应该是通过QUIC提供的访问了！你可以通过打开检查器工具并转到__Security__选项卡来验证这一点。重新加载页面并单击以查看连接详细信息：

![](https://c.dengxiaolong.com/caddy/quic.png)

如果你运行的是旧版本的Chrome，不想痛苦的话，那就升级吧。

但是，如果你愿意感受麻烦，你可以运行带有特殊参数的Chrome。在Mac上(用站点的主机名替换两次YOUR_SITE):

```bash
/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome \
    --user-data-dir=/tmp/chrome \
    --no-proxy-server \
    --enable-quic \
    --quic-host-whitelist="YOUR_SITE" "YOUR_SITE"
```

## QUIC的好处

QUIC是基于UDP的TLS+HTTP的可靠传输。它使TLS的握手速度加快到只有1次往返，避免了TCP的缓慢启动，并在交换网络时提供了可靠性。有了QUIC，网站加载更快，更可靠！

然而，初始连接仍然会在TCP上发生，直到客户端接收到第一个HTTP响应，它知道它可以切换到QUIC。为了在QUIC上强制进行初始连接(并从更快的连接设置中获益)，Chrome必须在开始时使用参数`--origin-to-force-quic-on=<host>:<port>`启动。

## 测试服务器

gQUIC测试服务器和版本检查器:[hnrk.io/quic](https://hnrk.io/quic/)。

## 故障排除

首先，确保你的域名正确设置在你的Caddyfile和命令启动Chrome在所有地方。

接下来，因为QUIC需要加密，你的站点必须使用可信的证书。你可以自己创建CA并将其添加到CA数据库中。当使用这个自签名证书时，为了使Chrome能正确发送QUIC的ClientHello消息，你的站点必须有一个具有顶级域名的主机名，例如`foo.bar`。对于本地主机的测试，你可以添加一个条目到/etc/hosts或使用主机解析规则选项运行Chrome：`--host-resolver-rules='MAP foo.bar:<port> 127.0.0.1:<local_port>'`。

如果这一切都很好，并且你需要更详细的输出，那么可以使用环境变量`QUIC_GO_LOG_LEVEL=DEBUG`和`-log stdout`或类似的方法启动caddy。

当你访问`chrome://net-internals/#events`时，你会看到一些用红色标记的QUIC事件。

这些提示来自于<https://github.com/mholt/caddy/pull/857> ，但是请不要把那个帖子当成支持论坛!

如果你仍然有问题，请在<https://github.com/lucas-clemente/quic-go/issues>报告该问题。谢谢!

## 反馈和贡献

由于这是一个我们非常期望能成功的实验，请让我们知道任何bug/问题/建议——一起来吧！如果你的反馈是与quic相关的，请拿到quic-go官网上。
