---
title: "模板动作"
sitename: "Caddy中文文档"
---

# 模板指令

Caddy的模板功能使得可以在静态站点中添加动态内容，也能通过包含页面减少重复内容。很多指令都支持模板，比如`templates`、`browse`和`markdown`。

模板动作只被支持它们的指令才能起作用。可以查阅文档检查你的指令是否支持模板，以及应该如何使用。Caddy的模板使用Go的`text/template`中的语法。使用`text/template`将帮助你体验模板的所有优势，不过对于并非程序员的我们，只需要一些简单的指令。Caddy还提供一些额外的有用的函数帮助模板网页的使用，我们在这里列举出来。

## 基本语法
模板动作被包含在`{{`和`}}`标记中间。模板单词是大小写敏感的。

## 常用函数

__包含其他文件__

```html
{{.Include "path/to/file.html"}}  // 没有参数
{{.Include "path/to/file.html" "arg1" 2 "value 3"}}  // 带参数
```

__在被包含文件内获取参数__

```html
{{index .Args 0}} // 0表示第一个参数，以此类推
```

__包含和渲染一个文件__（不需要[markdown](markdown.md)中间件）

```html
{{.Markdown "path/to/file.md"}}
```

__显示当前时间戳__([格式](https://golang.org/pkg/time/#pkg-constants))

```html
{{.Now "Monday, 2 Jan 2006"}}
```

__获取Cookie值__

```html
{{.Cookie "name"}}
```

__HEADER头的值__
```html
{{.Header "name"}}
```

__访问者IP__
```html
{{.IP}}
```

__服务器IP__
```html
{{.ServerIP}}
```

__访问者主机名__ (需要进行DNS查询，可能慢)
```html
{{.Hostname}}
```

__请求URI__
```html
{{.URI}}
```

__请求主机__
```html
{{.Host}}
```

__请求端口__
```html
{{.Port}}
```

__请求方法__
```html
{{.Method}}
```
__请求路径是否匹配另一个路径__
```html
{{.PathMatches "/some/path"}}
```

__网址的一部分__
```html
{{.URL.RawQuery}}
```

`RawQuery`返回查询字符串。你还可以把`RawQuery`换成`Host`、`Scheme`、`Fragment`、`String`或者`Query.Get` "参数"等.

__环境变量__
```html
{{.Env.ENV_VAR_NAME}}
```

__将值截取一定长度__（从开始或者结尾）
```html
{{.Truncate "value" 3}}  // "val"
{{.Truncate "value" -3}} // "lue"
```

__字符串替换__
```html
{{.Replace "haystack" "needle" "replacement"}}
```

__当前日期/时间对象__（日期相关的函数中非常有用）
```html
{{.NowDate}}
```

__获取路径的后缀__
```html
{{.Ext "path/filename.ext"}}
```

__去掉文件名的后缀__
```
{{.StripExt "filename.ext"}}
```

__去掉HTML保留纯文本__
```html
{{.StripHTML "Shows <b>only</b> text content"}}
```

__字符串小写__
```html
{{.ToLower "Makes Me ONLY lowercase"}}
```
__字符串大写__
```html
{{.ToUpper "Makes me only UPPERCASE"}}
```
__分割字符串__
```html
{{.Split "123-456-7890" "-"}}
```

__将系列值变成切片__（数组）
```html
{{.Slice "a" "b" "c"}}
```

__把键和值匹配__（在`advanced cases`，有子模板等是有用）
```html
{{.Map "key1" "value1" "key2" "value2"}}
```

__列举目录中的文件__
```html
{{.Files "sub/directory"}}
{{.Context.Files "sub/directory"}} // markdown的模板里边需要加上前缀.Context
```

__Whether HTTPS interception is likely:
{{.IsMITM}}
Random string of random length between min and max length:
{{.RandomString 100 10000}}
Built-in Sanitization Functions
These functions are built into text/template but you may find them helpful.

Make HTML-safe (escape special characters):
{{html "Makes it <i>safe</i> to render as HTML"}}
Make JavaScript-safe:
{{js "Makes content safe for use in JS"}}
URL-escape (query-encode):
{{urlquery "Makes safe for URL query strings"}}
Control Statements
If:
{{if .PathMatches "/secret/sauce"}}
    Only for secret sauce pages
{{end}}
If-else:
{{if .PathMatches "/secret/sauce"}}
    Only for secret sauce pages
{{else}}
    No secret sauce for you
{{end}}
If-elseif-else:
{{if .PathMatches "/secret/sauce"}}
    Only for secret sauce pages
{{else if eq .URL "/banana.html"}}
    You're on the banana page
{{else}}
    No bananas or secret sauce
{{end}}
Range: (iterate data; this example dumps request headers)
{{range $field, $val := .Req.Header}}
    {{$field}}: {{$val}}
{{end}}
Server-side comments:
{{/* This isn't sent to the client */}}
Comparison Functions
Useful in "if" statements, you can use comparison functions:

eq Equal
ne Not equal
lt Less than
le Less than or equal
gt Greater than
ge Greater than or equal
Or these logic functions:

not Reverses the if condition
or Returns first non-empty argument or the last argument
and Returns first empty argument or the last argument
Further Reading
These are just a few examples of what you can do. If you need even more template power, read the description of the text/template package which goes into much more detail.