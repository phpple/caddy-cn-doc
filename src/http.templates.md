---
date: 2018-09-11 22:40:03 +0800
title: "http.templates"
sitename: "Caddy中文文档"
---

# http.templates

templates允许你向页面添加模板操作。模板可以方便地呈现当前时间戳、请求URL、访问者的IP地址等等。你还可以得到基本的控制语句，如`if`和`range`。有关如何使用模板，请参阅[模板操作](template-actions.md)。

模板的一些常见用法包括包含其他文件的内容、显示当前日期或时间，以及根据请求路径、cookie或标题隐藏或显示页面的某些部分。

请注意，即使启用了此指令，自定义错误页面也不会作为模板执行。错误页面由独立的中间件提供。

模板可以来自静态文件，也可以由其他中间件加载。例如，您可以代理到一个后端，该后端输出一个模板，Caddy随后使用此指令执行该模板。

## 语法
```caddy
templates [path [extensions...]]
```

* __path__ 调用模板之前要匹配的路径
* __extensions...__ 指定哪些文件后缀会被当成模板，用空格分开。

要指定某些后缀，必须提供一个路径。默认路径是/，被作为模板执行的默认扩展名是.html、.htm、.tpl、.tmpl和.txt。

更多选择，需要打开一个块：

```caddy
templates {
    path    basepath
    ext     extensions...
    between open_delim close_delim
}
```

* __path__ 为要调用的模板匹配的基本路径。
* __ext__ 是作为模板执行的以空格分隔的文件后缀的列表。
* __between__ 为模板指定打开和关闭分隔符。默认值是`{{`和`}}`。

## 模板格式

查看[模板操作](template-actions.md)。


## 模板文件示例

```html
<!DOCTYPE html>
<html>
    <head>
        <title>Example Templated File</title>
    </head>
    <body>
        {{.Include "/includes/header.html"}}
        <p>
            Welcome {{.IP}}! You're visiting {{.URI}}.
        </p>
        {{.Include "/includes/footer.html"}}
    </body>
</html>
```

## 示例
对所有的.html、.htm、.tpl、.tmpl、和.txt文件启用模板支持。

```caddy
templates
```

文件后缀和上个例子一样，但是只针对/portfolio路径：

```caddy
templates /portfolio
```

只对/portfolio路径的.html和.txt文件启用模板支持：

```caddy
templates /portfolio .html .txt
```