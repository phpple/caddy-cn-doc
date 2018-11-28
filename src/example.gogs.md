---
date: 2018-11-28 22:33:58 +0800
title: "Caddy的gogs配置"
sitename: "Caddy配置示例"
template: "example"
---

# Caddy的gogs配置

这是一个使用Caddy运行[Gogs](https://gogs.io/)的配置示例。

配置做了如下假设：

1. 你已经用`git`安装了Gogs，家目录是`/home/git`。
2. Gogs的安装目录是`/home/git/gogs`。
3. Gogs的监听端口是`3000`。
4. 你的域名是`mygogs.com`。

请使用真实的值进行替换。


## Caddyfile

```caddy
mygogs.com {
    proxy / localhost:3000 {
        except /css /fonts /js /img
    }
    root /home/git/gogs/public
}
```