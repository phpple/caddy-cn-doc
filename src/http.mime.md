---
date: 2018-09-11 12:53:11 +0800
title: "http.mime"
sitename: "Caddy中文文档"
---

# http.mime

mime根据请求中的文件扩展名在响应中设置内容类型。

通常，Caddy通过嗅探内容自动检测静态文件的Content-type，但这并不总是可行的。如果您遇到使用错误Content-type的响应，或者正在提供静态文件以外的内容，您可以使用这个中间件来设置正确的内容类型。

## 语法

```caddy
mime ext type
```

* __ext__ 是要匹配的文件扩展名，包括前面的点。
* __type__ Content-Type


如果你有很多MIME类型设置，打开一个块:

```caddy
mime {
	ext type
}
```

每一行都定义了一对扩展名和MIME类型。在mime块中可以有任意多的行。

## 示例

给Flash文件自定义Content-type：

```caddy
mime .swf application/x-shockwave-flash
```

自定义更多文件：

```caddy
mime {
	.swf application/x-shockwave-flash
	.pdf application/pdf
}
```