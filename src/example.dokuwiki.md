---
date: 2018-12-04 23:43:45 +0800
title: "DokuWiki的Caddy配置"
sitename: "Caddy配置示例"
template: "example"
---

# DokuWiki的Caddy配置

这是如何使用Caddy支持[DokuWiki](https://www.dokuwiki.org/)的示例配置。

* Caddyfile_root - 当DokuWiki是运行在根目录的时候的配置文件
* Caddyfile_subdir - 当DokuWiki是在一个子目录运行时的配置文件

## 前提条件
DokuWIKI有这些[必要条件](https://www.dokuwiki.org/requirements/)。


## Caddyfile_root

```caddy

localhost:8080
root <Dir Where Your Dokuwiki Site PHP files are>
gzip

fastcgi / /var/run/php-fpm/php-fpm.sock php {
  index doku.php
}

internal /forbidden

rewrite {
  r /(data/|conf/|bin/|inc/|install.php)
  to /forbidden
}
rewrite /_media {
  r (.*)
  to /lib/exe/fetch.php?media={1}
}
rewrite /_detail {
  r (.*)
  to /lib/exe/detail.php?media={1}
}
rewrite /_export {
  r /([^/]+)/(.*)
  to /doku.php?do=export_{1}&id={2}
}
rewrite {
  if {path} not_match /lib/.*
  if {path} not_match /forbidden
  r /(.*)
  to {uri} /doku.php?id={1}&{query}
}
```

## Caddyfile_subdir

```caddy
localhost:8080
root <Dir Where Your WP Site PHP files are>
gzip

# 本示例dokuwiki所在子目录是"wiki"
fastcgi /wiki/ /var/run/php-fpm/php-fpm.sock php {
  index doku.php
}

internal /wiki/forbidden

rewrite /wiki {
  r /(data/|conf/|bin/|inc/|install.php)
  to /wiki/forbidden
}
rewrite /wiki/_media {
  r (.*)
  to /wiki/lib/exe/fetch.php?media={1}
}
rewrite /wiki/_detail {
  r (.*)
  to /wiki/lib/exe/detail.php?media={1}
}
rewrite /wiki/_export {
  r /([^/]+)/(.*)
  to /wiki/doku.php?do=export_{1}&id={2}
}
rewrite /wiki {
  if {path} not_match /lib/.*
  if {path} not_match /forbidden
  r /(.*)
  to {uri} /wiki/doku.php?id={1}&{query}
}
```
