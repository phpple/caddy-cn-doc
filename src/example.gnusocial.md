---
date: 2018-12-07 23:17:20 +0800
title: "GNU Social的Caddy配置"
sitename: "Caddy配置示例"
template: "example"
---

# GNU Social的Caddy配置

Caddyfile应该能在[GNU Social](https://git.gnu.io/gnu/gnu-social)的任何一个分支运行。有关先决条件和安装信息，请参阅包含的自述文件。

要获得最新版本，请输入以下你希望\[gs\]\[GNU Social\]安装位于的位置：`git clone https://git.gnu.io/gnu/gnu-social`。如果你喜欢冒险，你可以在你的gnusocial目录运行下面的命令：

```bash
git checkout nightly
```

## Caddyfile

```caddy
example.com www.example.com

# Your fastcgi for php-fpm will be different if you are listening on a socket
# or port. Here Are examples for both methods.
# Uncomment the one you need.
# fastcgi / 127.0.0.1:9000 php
# fastcgi / /var/run/php-fpm/php-fpm.sock php

rewrite {
    to {path} {path}/ /index.php?p={path}
}

root /var/www/html/gnusocial
```