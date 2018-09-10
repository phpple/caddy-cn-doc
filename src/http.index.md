---
date: 2018-09-11 00:37:27 +0800
title: "http.index"
sitename: "Caddy中文文档"
---

# http.index

index设置用作“索引”文件的文件名列表。当请求一个目录路径而不是特定的文件时，将检查目录中的索引文件。会将第一个匹配的文件用来响应请求。


默认的索引文件按顺序依次是：
1. index.html
2. index.htm
3. index.txt
4. default.html
5. default.htm
6. default.txt

使用这个指令可以覆盖这个列表，不会追加到默认列表后面。

## 语法

```caddy
index filenames...
```

* __filenames...__ 以空格分隔的文件名作为索引文件。至少需要一个名字。

## 示例

只使用goaway.png和easteregg.html作为索引文件：

```caddy
index goaway.png easteregg.html
```