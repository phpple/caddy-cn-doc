---
date: 2018-09-18 21:53:54 +0800
title: "http.gopkg"
sitename: "Caddy中文文档"
---

# http.gopkg

gopkg指令允许你创建Go导入网址的镜像。

[完整文档](https://github.com/zikes/gopkg/blob/master/README.md)

## 示例

__基本用法__

```caddy
mydomain.com {
  gopkg /gopkg https://github.com/zikes/gopkg
}
```

允许使用`go get mydomain.com/gopkg`。

__指定仓库类型__

```caddy
gopkg /myrepo hg https://bitbucket.com/zikes/myrepo
```

明确仓库类型为Mercurial。