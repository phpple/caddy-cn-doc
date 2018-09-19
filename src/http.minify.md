---
date: 2018-09-19 21:01:33 +0800
title: "http.minify"
sitename: "Caddy中文文档"
---

# http.minify

动态压缩静态资源。支持CSS, HTML, JS, JSON, SVG和XML。

[完整文档](https://github.com/hacdias/caddy-minify/blob/master/README.md)

## 示例

__基本语法__

```caddy
minify
```

压缩网站上所有支持的文件。

__复杂语法__

```caddy
minify paths...  {
    if          a cond b
    if_op       [and|or]
    disable     [js|css|html|json|svg|xml]
    minifier    option value
}
```

* __path__ 用空格隔开的需要被压缩的路径列表。如果没有指定，整个网站将被压缩。
* __if__ 指定一个条件。默认情况下，多个if通过AND连接在一起。__a__和__b__是任何字符串，可以使用[请求占位符](placeholders.md)。__cond__是条件，在[rewrite](http.rewrite.md)指令中解释了可能的值(也有`if`语句)。
* __if_op__ 指定多个if语句如何关联；默认值是and。
* __disable__ 用于指示要禁用哪些缩小器。默认情况下，它们都被激活了。
* __minifier__ 设置缩小器的`option`为`value`。当`option`的值为true或false时，如果省略`value`则认为是true。要了解具体的选项，请阅读[完整的文档](https://github.com/hacdias/caddy-minify/blob/master/README.md#minifiers-options)。

__压缩一个路径__

```
minify /assets
```

只压缩`/assets`目录的文件。

__除了一个目录其他都被压缩__

```caddy
minify  {
    if {path} not_match ^(\/api).*
}
```

压缩除了/api目录外的整个网站。
