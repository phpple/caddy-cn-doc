---
date: 2018-09-09 21:58:25 +0800
title: "http.browse"
sitename: "Caddy中文文档"
---

# http.browse

browse允许在指定的基本路径内进行目录浏览。它显示没有主文件(index file)的目录的文件列表，在其他服务器软件中，这通常称为索引(indexing)。

默认情况下，列举文件是被禁止的，如果访问目录（没有主文件）的请求将导致404错误。

该中间件可以通过设置cookie来保存用户更改的UI选项。

## 语法

```caddy
browse [path [tplfile]]
```

* __path__ 用来匹配的基本路径。任何在这个基本路径的目录都是可以浏览的。
* __tplfile__ 使用的模板文件的路径。

如果没有指定模板文件，将使用默认模板。在没有任何参数的情况下，可以在整个站点上进行浏览(path=/)。

## 模板格式

模板就是一个简单的HTML文件，里面有一些操作。操作被解析并执行以显示动态内容。这个指令支持Caddy的[模板操作](template-actions.md)以及一些browse指令的额外的操作。您可以使用呈现[这些结构类型](https://github.com/mholt/caddy/blob/060ab92d295ba9dd8e34115c92557d5eff5896ff/middleware/browse/browse.go#L41-L118)的模板操作(请注意，有些帮助方法是可用的)。

下面是一个相当简单的模板示例：

```html
<html>
    <head>
        <title>{{html .Name}}</title>
    </head>
    <body>
        {{if .CanGoUp}}<a href="..">Up one level</a><br>{{end}}
        <h1>{{.Path}}</h1>
        {{range .Items}}
        <a href="{{html .URL}}">{{html .Name}}</a><br>
        {{end}}
    </body>
</html> 
```

... 然而默认的模板更有好。

注意，为了在浏览器中安全呈现，文件名和网址都经过了处理。模板被认为是受信任的，所以如果您的文件名不受信任，请确保它们是转义的，以便在HTML文档中使用。

## `JSON`响应

可以通过在`Accept`头中使用`application/json`，要求返回JSON格式的内容而不是页面:

```bash
$ curl -H "Accept: application/json" 'localhost:2015/?limit=1'
[{"IsDir":true,"Name":".git","Size":476,"URL":".git/","ModTime":"2015-09-11T03:20:09+03:00","Mode":2147484141}]
```
上面的示例演示了如何请求JSON，以及如何通过名称为`limit`的查询条件限制所需条目的数量。要生成整个清单则需要去掉limit查询。

## 示例

允许目录列举所有缺少主文件的文件夹

```caddy
browse
```

通过一个指定的模板展示相册内容（在/photos目录）：

```caddy
browse /photos ../photo_album.tpl
```