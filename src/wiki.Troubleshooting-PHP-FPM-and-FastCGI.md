---
date: 2018-10-01 17:45:47 +0800
title: "PHP FPM和FastCGI故障排除"
sitename: "Caddy开发者wiki"
template: "wiki"
---

# PHP FPM和FastCGI故障排除


_<small>英文原文：<https://github.com/mholt/caddy/wiki/Troubleshooting-PHP-FPM-and-FastCGI></small>_

----------------------------

Caddy通过[FastCGI](http.fastcgi.md)指令支持PHP。大部分用户都使用PHP运行没有任何问题，但有些用户遇到了问题。

这个wiki更关注于Caddy，并假设用户知道安装/配置PHP-FPM。

这些是一些有价值的故障排除技巧。

## 启用错误日志

这是故障排除的第一步。你可以使用简单的单行语法启用它。

```caddy
errors errors.log
```

## 重启

对Caddyfile的任何更改都需要重启Caddy。

对PHP-FPM配置(通常是`php-fpm.conf`或者`www.conf`)的任何更改则需要重启PHP-FPM。

## 畸形的MIME标头

错误示例：

```bash
[ERROR 502 /index.php] malformed MIME header line: Primary script unknown
```

更新到Caddy 0.8.1，这将修复它或得到一个更有描述性的错误消息。在类unix系统上，这个问题也可能发生，因为Caddy和php-fpm不在同一个用户/组下运行。确保在相同的用户/组下运行它们，并给予文档根目录(chmod/chown)适当的权限。还可以在php-fpm配置文件(如`pool.d/www.conf`)中检查`chroot`的配置。

## 连接拒绝

错误示例：

```bash
[ERROR 502 /index.php] dial tcp 127.0.0.1:9000: getsockopt: connection refused
```

确保PHP-FPM在指定的端口上运行和监听。如果需要请同时检查`php-fpm.conf`。

```
listen = 9000
```

## 没有这个文件或文件夹

错误示例：

```bash
[ERROR 502 /index.php] dial unix /var/run/php5-fpm.sock: connect: no such file or directory
```
确保PHP-FPM正在运行并监听指定的unix套接字。如果需要请同步检查`php-fpm.conf`。

```
listen = /var/run/php5-fpm.sock
```

确保运行Caddy的用户具有对unix套接字文件的读权限。

## 没有权限

错误示例：

```bash
[ERROR 502 /info.php] dial unix /var/run/php5-fpm.sock: connect: permission denied
```

如果你不是作为www-data用户（或其他运行php-fpm的用户）运行caddy，则会发生此错误。根据你的php-fpm版本修改`/etc/php5/fpm/pool.d/www.conf`或`/etc/php/7.0/fpm/pool.d/www.conf`，并更改用户：

```
listen.owner = caddy
listen.group = caddy
```

## 重写

PHP框架通常需要重写；或者作为要求，或者干净的url。更新到Caddy 0.8.1，该版本引入了更强大的重写功能，然后[阅读文档](http.rewrite.md)。

下面的格式将满足一些流行的框架：

```caddy
rewrite {
    to {path} {path}/ /index.php?url={uri}
}
```

有些框架需要版本的值进行转义用以作为有效的查询参数：

```caddy
rewrite {
    to {path} {path}/ /index.php?url={path_escaped}&{query}
}
```

或者如果项目在子目录中，使用`regex`（或`r`）来捕获子路径。

```caddy
rewrite /subdirectory/ {
    r (.*)
    to {path} {path}/ /subdirectory/index.php?url={1}&{query}
}
```

## 示例

如何使用PHP与Caddy？感谢你对我们示例库<https://github.com/caddyserver/examples>所做的贡献。

