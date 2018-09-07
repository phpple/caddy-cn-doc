---
name: "http.rewrite"
sitename: "Caddy中文文档"
---

# http.rewrite

__rewrite__用来完成内部网址重写。允许客户端请求一个资源，但实际上提供的是另一个资源且没有产生HTTP重定向。重写对于客户而言是透明的。

有简单重写（快）和复杂重写（慢）两种方式，但它们都足够强大，能适应大部分动态后端应用的需求。

## 语法

```caddy
rewrite [not] from to...
```

* __not__ 如果指定，将反转模式和匹配逻辑。

* __from__ 匹配的确切路径或与之匹配的正则表达式

* __to__ 通过空格分隔的用来重写的一组目标路径（响应的资源）；将按顺序对每个目标路径进行尝试，直到找到第一个存在真实存在的目标路径。

资深用户可以通过块来做一个复杂的重写规则：

```caddy
rewrite [basepath] {
    regexp pattern
    ext    extensions...
    if     a cond b
    if_op  [and|or]
    to     destinations...
}
```

* __basepath__ 是在用正则表达式重写之前匹配的基本路径。默认为"/"。

* __regexp__ （简写:__r__） 将根据给定的正则表达式模式匹配路径。
> 负载非常高的服务器应该避免使用正则表达式。

* __extensions...__ 是一个用于包含或忽略的文件的扩展名列表（带点前缀），以空格进行分隔。在扩展名前加上"!"表示排除该扩展名。正斜杠"/"符号匹配没有文件扩展名的路径。

* __if__ 指定重写条件。多个if语句会通过AND连接。__a_和__b__为任意字符串，可以使用[请求占位符](placeholders.md)。__cond__是条件，可能是下面提到的值。

* __if_op__ 指出所有的if条件如何连接；默认值是`and`。

* __destinations...__ 是一个或多个空格分隔的重写路径，支持[请求占位符](placeholders.md)以及编号的正则表达式捕获，如{1}、{2}等。重写将检查每个目标的顺序，并重写到第一个存在的目标。每一个都被视为一个文件，除非以/结尾才被当做一个目录。如果不存在其他目标，则最后一个目标将作为默认值。


## "if"条件
if关键字是描述规则的一种强大的方式。它采用的格式是`a cond b`，其中值`a`和`b`被条件`cond`分隔。条件可以是下面的任何一种：

* `is` = a 等于 b
* `not` = a 不等于 b
* `has` = a 包含 b 子串 （b 是 a 的子串）
* `not_has` = b 不是 a 的子串
* `starts_with` = b 是 a 的前缀
* `not_starts_with` = b 不是 a 的前缀
* `ends_with` = b 是 a 的结尾
* `not_ends_with` = b 不是 a 的结尾
* `match` = a 匹配 b, b 是一个正则表达式
* `not_match` = a 不匹配 b, b 是一个正则表达式


注意：作为一条通用规则，你可以使用`not_`作为前缀否定任何`cond`条件。

## 示例

* 把所有请求都重写到/index.php。（`rewrite / /index.php`只会匹配/）

```caddy
rewrite .* /index.php
```

* 当请求来自/mobile，实际提供的是/mobile/index。

```caddy
rewrite /mobile /mobile/index
```

* 如果不是访问favicon.ico，而且不是有效文件或者目录，则返回维护页面，还没有则重写到index.php。

```caddy
rewrite {
    if {file} not favicon.ico
    to {path} {path}/ /maintenance.html /index.php
}
```

* 如果user-agent包含"mobile"，而且路径不是有效的文件或路径，则重写到移动主页。
```caddy
rewrite {
    if {>User-agent} has mobile
    to {path} {path}/ /mobile/index.php
}
```

* 重写/app到/index，并且携带一个查询参数。{1}表示匹配到的组(.*)。

```caddy
rewrite /app {
    r  (.*)
    to /index?path={1}
}
```

* 重写请求/app/example到/index.php?category=example。

```caddy
rewrite /app {
    r  ^/(\w+)/?$
    to /index?category={1}
}
```

