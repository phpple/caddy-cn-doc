---
date: 2018-09-09 23:17:47 +0800
title: "http.ext"
sitename: "Caddy中文文档"
---

# http.ext

ext允许你的站点在URL没有后缀时假定一个文件后缀，从而拥有干净的URL。

URL的后缀是通过检查路径的(.)获取路径的最后一个元素获得的。

## 语法
```caddy
ext extensions...
```

* __extensions...__ 是要尝试的以空格分隔的后缀(包括.)的列表。将按列出的顺序尝试后缀。至少需要指定一个后缀。

## 示例

假设您有一个名为/contact.html的文件，你可以让Caddy尝试.html的文件，通过/contact提供对该文件的访问。

按顺序尝试.html、.htm、和.php：

```caddy
ext .html .htm .php
```