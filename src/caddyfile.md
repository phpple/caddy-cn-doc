+++
title = "Caddyfile入门"
sitename = "caddy中文文档"
template = "tutorial"
+++

# Caddyfile入门

这篇文档将为你展示使用Caddyfile配置Caddy是非常easy的事情。

`Caddyfile`是用来配置Caddy如何运行的文本文件。

Caddyfile的第一行总是表示站点的访问地址，比如：

`localhost:8080`

当你把这行内容保存到Caddyfile，当你启动Caddy时它将被自动发现：
> __Windows__

> `caddy`

> __macOS__

> `$ caddy`

> __Linux__

> `$ caddy`

如果Caddyfile放在另外的目录，你需要告诉Caddy准确的位置：

> __Windows__

> `caddy -conf C:\path\to\Caddyfile`

> __macOS__

> `$ caddy -conf ../path/to/Caddyfile`

> __Linux__

> `$ caddy -conf ../path/to/Caddyfile`

紧接网站地址的将是一系列的`指令`。__指令__是Caddy识别的关键字。比如，`gzip`是一个`HTTP`的指令。

```caddy
localhost:8080
gzip
```
每个指令会跟随一个或者更多数量的参数：
```caddy
localhost:8080
gzip
log ../access.log
```

有些指令需要配置很多内容，不能在一行完成。对于这些指令，你可以通过`{`打开一个块来设置更多参数，在最后一行你需要使用`}`将块关闭掉：

```caddy
localhost:8080
gzip
log ../access.log
markdown /blog {
    css /blog.css
    js  /scripts.js
}
```

如果指令块是空的，你必须把花括号整个删除掉。

包含空白的参数必须使用`"`两边包含起来。

Caddyfile也支持通过`#`标记注释内容：

```caddy
# Comments can start a line
foobar # or go at the end
```
如果需要在一个Caddyfile配置多个站点，你必须将每个站点的配置通过花括号区分开来：

```caddy
mysite.com {
    root /www/mysite.com
}

sub.mysite.com {
    root /www/sub.mysite.com
    gzip
    log ../access.log
}
```

跟随指令的左花括号必须出现在行尾，而右花括号则必须出现在单独的一行。所有指定都必须在站点的定义之内。

对于有相同配置的站点，允许一行标记多个地址：
```caddy
localhost:8080, https://site.com, http://mysite.com {
    ...
}
```
除了域名，也可以指定特定的路径，或者在域名左边使用通配符:

```caddy
example.com/static, *.example.com {
    ...
}
```

需要注意的是，使用站点地址的路径，将以最长的匹配前缀进行路由完成请求。如果你的基本路径是一个目录，你可以用斜杠`/`作为路径的结束。

网址和参数是允许使用环境变量的。它们必须通过花括号包围，格式则可以是Unix或者Windows风格的:

```caddy
localhost:{$PORT}
root {%SITE_ROOT%}
```

每种语法都被任何平台支持。一个单独的环境变量不会因为带有空格等特殊字符而变成多个参数或者值。

Caddyfile不支持`继承和脚本`，你不能多次指定同一个站点地址。是的，有的时候这会导致你需要拷贝+复制一些重复的行。如果你有很多重复的行，你可以考虑使用`[import](import.md)`指令来减少重复。

好了，你应该对[Caddy的文档](doc.md)有更多的了解了，让我们开启新的征途！
