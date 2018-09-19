---
date: 2018-09-19 22:14:08 +0800
title: "http.restic"
sitename: "Caddy中文文档"
---

# http.restic

restic插件在路径上提供一个restic存储库。Restic是一个安全和快速的备份程序，请点击<https://restic.github.io>查看详情。

[完整文档](https://github.com/restic/caddy/blob/master/README.md)

## 示例

__在网址/foo上提供一个restic存储库__

```caddy
basicauth /foo user pass
restic    /foo /home/me/backups
```

Caddy将通过网址/foo提供对/home/me/backup目录的restic仓库的访问。