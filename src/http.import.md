---
date: 2018-09-10 09:40:42 +0800
title: "http.import"
sitename: "Caddy中文文档"
---

# http.import

import允许您从另一个文件或可重用代码片段中使用配置。它被替换为该文件或代码片段的内容。

这是一个唯一可以出现在服务器块之外的指令。换言之，它可以出现在Caddyfile的顶部，这通常用来放置网址。和其他指令一样，它不能在其他指令内部使用。

注意，导入路径是相对于Caddyfile的位置，而不是当前工作目录。


## 语法
```bash
import pattern
```

* __pattern__ 要包含的文件或glob模式(*)或代码段名称。它的内容将替换这一行，就好像文件的内容出现在这里一样。这个值是指相对于Caddyfile的位置。如果确定的文件没有找到会导致错误，但实际文件为空的glob模式则不会导致报错。Glob可以只有一个通配符，且不支持`[ ]`模式。


## 示例

导入一个共享配置：

```caddy
import config/common.conf
```

导入任何vhosts目录的文件：

```caddy
import ../vhosts/*
```

导入前面定义的代码片段:

```caddy
import mysnippet
```