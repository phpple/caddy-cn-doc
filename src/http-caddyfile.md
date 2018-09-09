---
name: "HTTP Caddyfile"
sitename: "Caddy中文文档"
---

# HTTP Caddyfile

这个页面记录了HTTP服务器如何使用Caddyfile。如果您还没有学习过[Caddyfile教程](caddyfile.md)，那么请先学习[Caddyfile语法](caddyfile.md)。


## 主题

1. [网站地址](#网站地址)
2. [路径匹配](#路径匹配)
3. [指令](#指令)
4. [占位符](#占位符)

## 网站地址

HTTP服务器使用站点地址作为标签。地址必须使用这种格式：`scheme`://`host`:`port`/`path`，只有一个是可选的。

主机部分通常是localhost或域名。默认端口是2015(除非该站点符合自动[HTTPS标准](automatic-https.md)，在这种情况下，它为您更改为443)。scheme部分是指定端口的另一种方法。有效的schema包括“http”或“https”，它们分别表示端口80和443端口。如果指定了schema和端口，则端口优先。例如(此表假设满足自动HTTPS的资格):

```caddy
:2015                    # 主机： (any), 端口： 2015
localhost                # 主机： localhost; 端口： 2015
local主机：8080           # 主机： localhost; 端口： 8080
example.com              # 主机： example.com; 端口: 80->443
http://example.com       # 主机： example.com; 端口： 80
https://example.com      # 主机： example.com; 端口: 80->443
http://example.com:1234  # 主机： example.com; 端口： 1234
https://example.com:80   # 错误！HTTPS不能在80端口
*                        # 主机：*; 端口： 2015
*.example.com            # 主机：*.example.com; 端口： 443
*.*.example.com          # 主机： *.*.example.com; 端口： 2015
example.com/foo/         # 主机： example.com; 端口： 80, 443; Path: /foo/
/foo/                    # 主机： (any), 端口： 2015, Path: /foo/
```

网站地址必须是唯一的；同一个站点的所有配置必须组合在同一个定义内。

通配符`*`可以用于主机名。通配符必须替换整个域标签：*.example.com有效，但foo*.example.com无效。主机名可能有多个通配符标签，但它们必须是最左边的标签。(请注意，要获得通配符证书，只允许有一个通配符标签；这种特殊情况允许自动HTTPS继续存在。定义为`*`的站点只匹配"localhost"这样的单标签名称，而不匹配"example.com"。要匹配所有主机，请将主机名保持为空。

## 路径匹配

有些指令接受一个指定基本路径的参数。基本路径是一个前缀。如果URL以基本路径开头，它将是匹配的。例如，基本路径`/foo`能匹配`/foo`、`/foo.html`、`/foobar`和`/foo/bar.html`。如果你想限制一个基本路径只匹配一个特定的目录，可以在后面追加一个正斜杠，如`/foo/`，这将不匹配`/foobar`。

## 指令
大多数指令调用中间件层。中间件是应用程序中处理HTTP请求并能很好地完成一件事情的一个小层。中间件在启动时链接在一起(也可以预先编译好)。只有在Caddyfile中调用的中间件处理器才会被链接到其中，因此小小的Caddyfile非常快速和高效。

参数的语法因指令而异。有些有必填的参数，有些没有。参考每个指令的文档以获得其特征。

对于注册为插件的指令，文档页面将显示带有服务器类型前缀的指令名称，例如`http.realip`或`dns.dnssec`。在Caddyfile中使用它们时需要去掉前缀(`http.`)。前缀只是为了确保命名唯一，但在Caddyfile中不使用。

## 占位符

在某些情况下，指令将接受[占位符](placeholders.md)(可替换值)。这些是用花括号`{ }`括起来的词，HTTP服务器在请求时解释这些词。例如，`{query}`或`{>Referer}`。把它们想成变量即可。这些占位符与你可以在Caddyfiles中使用的环境变量没有关系，只是为了熟悉起见借用了类似的语法。