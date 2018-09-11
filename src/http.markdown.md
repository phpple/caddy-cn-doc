---
date: 2018-09-11 08:48:02 +0800
title: "http.markdown"
sitename: "Caddy中文文档"
---

# http.markdown

markdown会根据需要将[Markdown](http://daringfireball.net/projects/markdown/)文件作为HTML页面提供。您可以指定整个自定义模板，或者只指定页面上要使用的CSS和JavaScript文件，以给它们一个自定义的外观和行为。


## 语法

```caddy
markdown [basepath] {
    ext         extensions...
    [css|js]    file
    template    [name] path
    templatedir defaultpath
}
```

* __basepath__ 是要匹配的基本路径。如果请求URL没有以此路径为前缀，则Markdown将不会激活。默认是站点根目录。
* __extensions...__ 以空格分隔的文件扩展名列表，将其视为Markdown(默认为.md、.标记和.mdown)；这与[ext](http.ext.md)指令不同，ext指令假定文件扩展名缺失。
*  __css__ 指示下一个参数是要在页面上使用的CSS文件。
* __js__ 表示下一个参数是要包含在页面上的JavaScript文件。
* __file__ 是要添加到页面的JS或CSS文件。
* __template__ 对给定路径定义一个给定名称的模板。若要指定默认模板，请省略名称。Markdown文件可以通过使用其前面的名称来选择模板。
* __templatedir__ 在列出模板时使用给定的defaultpath设置默认路径。

可以多次使用js和css参数向默认模板添加更多文件。如果你想接受默认值，你应该完全省略大括号。

## 扉页（文档元数据）

标记文件可以从扉页(front matter)开始，是指关于文件的特殊格式的元数据块。例如，它可以描述用于呈现文件的HTML模板，或者定义内容的标签。前面的内容可以是YAML、TOML或JSON格式。

[TOML](https://github.com/toml-lang/toml) 扉页使用`+++`作为开始和结束:

```toml
+++
template = "blog"
title = "Blog Homepage"
sitename = "A Caddy site"
+++
```

[YAML](http://yaml.org/) 通过`---`包围:

```yaml
---
template: blog
title: Blog Homepage
sitename: A Caddy site
---
```

[JSON](http://json.org/) 直接通过`{`和`}`标识：

```json
{
    "template": "blog",
    "title": "Blog Homepage",
    "sitename": "A Caddy site"
}
```

扉页字段"author"、"copyright"、"description"和"subject"将用于在呈现的页面上创建`<meta>`标记。

## Markdown模板

模板文件只是带有模板标记（成为动作）的HTML文件，可以根据所服务的文件插入动态内容。元数据中定义的变量可以从`{{.Doc.variable}}`之类的模板访问。其中"ariable"是变量的名称。`{{.Doc.body}}`代表Markdown文件的主体。

下面是一个简单的示例模板(虚构的)：

```html
<!DOCTYPE html>
<html>
    <head>
        <title>{{.Doc.title}}</title>
    </head>
    <body>
        Welcome to {{.Doc.sitename}}!
        <br><br>
        {{.Doc.body}}
    </body>
</html>
```

除了这些模板操作之外，在Markdown模板中还可以使用所有标准的Caddy[模板操作](template-actions.md)。请确保清除所有呈现为HTML的内容(使用`html`、`js`和`urlquery`函数)!

## 示例

在/blog路径下提供Markdown页面服务，没有特殊的格式(设定.md是Markdown后缀):

```caddy
markdown /blog
```

和上面类似，但是自定义CSS和JS文件：

```caddy
markdown /blog {
    ext .md .txt
    css /css/blog.css
    js  /js/blog.js
}
```

使用自定义模板：

```caddy
markdown /blog {
    template default.html
    template blog  blog.html
    template about about.html
}
```