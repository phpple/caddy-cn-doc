---
date: 2018-12-01 01:44:49 +0800
title: "Caddy的Drupal配置"
sitename: "Caddy配置示例"
template: "example"
---

# Caddy的Drupal配置

Drupal ♥️ Caddy

本示例用来通过Caddy运行Drupal 7。定义了很多访问模块文件、SQL文件以及其他不应该被访问到的扩展名的文件。同时也禁止访问.开头的文件。

为了能正常运行，你需要更换网站地址，根目录，以及php-fpm信息。

## Caddyfile

```caddy
# 更换为你的网站地址
https://localhost:8080

# 设置网站根目录
# 在UNIX/Mac系统，则应该类似于 /var/www/example.com这样的路径。
root W:\localhost\d7

# 设置php-fpm进程的访问路径
fastcgi / 127.0.0.1:9000 php

# 这个重写用来阻止对.开头的文件及目录的访问
# 比如 .htaccess、.git等等。
rewrite {
  if {path} starts_with .
  if {path} not_starts_with .well-known
  to error/index.html
}

# 这个重写用来保护一些特定后缀的文件不被访问
rewrite {
  if {path} match .(bak|config|sql|fla|psd|ini|log|sh|inc|swp|dist|engine|inc|info|install|make|module|profile|test|po|sh|sql|theme|tpl|tpl.php|xtmpl|sw|bak|orig|save)$
  to error/index.html
}
status 404 error/index.html

# 最重要的重写，用来将没有后缀的网址重写到index.php文件
rewrite {
  if {file} not favicon.ico
  to {path} {path}/ /index.php?{path}&{query}
}

# Security-HTTP-Header to reduce exposure to drive-by downloads 
# and the risks of clever-named user uploaded content that could be 
# treated as a different content-type (e.g. as executable).
header / {
  X-Content-Type-Options nosniff
}

# 压缩传输数据
gzip
```