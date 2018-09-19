---
date: 2018-09-19 22:19:46 +0800
title: "http.webdav"
sitename: "Caddy中文文档"
---

# http.webdav

提供支持路径限制规则和用户的WebDAV功能。

[完整文档](https://github.com/hacdias/caddy-webdav/blob/master/README.md)

## 示例

__语法__

```caddy
webdav [url] {
    scope       path
    modify      [true|false]
    allow       path
    allow_r     regex
    block       path
    block_r     regex
}
```

所有选项都是可选的。

* __url__ 是你可以访问WebDAV接口的地方。默认为/。
* __scope__ 是指示WebDAV范围的一个绝对路径或相对路径(与Caddy当前工作目录相对)。默认为`.`.
* __modify__ 指示用户是否有权编辑/修改文件。默认值为`true`。
* __allow__和__block__ 用于允许或拒绝使用特定文件或目录到作用域的相对路径访问它们。您可以使用魔术单词`dotfiles`来允许或拒绝访问以点开始的每个文件。
* __allow_r__和__block_r__ 是前面选项的变体，你可以对它们使用正则表达式。

强烈推荐将这个指令和[basicauth](http.basicauth.md)一起来保护WebDAV接口。

```caddy
webdav {
    # 这里放置全局配置
    # 所有用户都会继承他们
    user1:
    # 你可以在这里为`user1`放置特殊的设置
    # 它们将覆盖这个特定用户的全局变量。
}
```


__基本__

```caddy
webdav
```

通过`/`访问的当前工作目录的WebDAV。

__自定义范围__

```caddy
webdav {
    scope /admin
}
```

通过`/admin`访问的整个文件系统的WebDAV。

__拒绝规则__

```caddy
webdav {
    scope /
    block /etc
    block /dev
}
```

通过`/`访问的整个文件系统的WebDAV，不能访问`/etc`和`/dev`目录。

__用户权限__

```caddy
basicauth / sam pass
webdav {
    scope /
    
    sam:
    block /var/www
}
```

通过`/`访问的整个文件系统的WebDAV。用户`sam`不能访问`/var/www`，但其他用户可以。
