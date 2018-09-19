---
date: 2018-09-19 22:34:50 +0800
title: "hook.service"
sitename: "Caddy中文文档"
---

# hook.service

一直想把Caddy当作服务？这就是你一直在等待的。

这个插件是由[Fábio Ferreira
](https://github.com/fabiofcferreira)和[Henrique Dias](https://github.com/hacdias)编写的，Henrique Dias是[FileManager](http.filemanager.md)的主要贡献者。
    
注意：如果你安装的服务的名称不是默认的，那么每次使用标记`-name`使用其他命令时，都需要指定它。

[完整文档](https://github.com/hacdias/caddy-service/blob/master/README.md)

## 示例

__安装服务__

```bash
caddy -service install [-name optionalName]
```

__删除服务__
```bash
caddy -service uninstall [-name optionalName]
```

__启动服务__

```bash
caddy -service start [-name optionalName]
```

__停止服务__

```bash
caddy -service stop [-name optionalName]
```

__重启服务__

```caddy
caddy -service restart [-name optionalName]
```
