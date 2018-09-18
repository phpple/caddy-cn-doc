---
date: 2018-09-19 00:34:43 +0800
title: "http.filter"
sitename: "Caddy中文文档"
---

# http.filter

http.filter用来过滤响应体。

这对于修改静态HTML文件以向其添加(例如)谷歌统计代码非常有用。

[完整文档](https://github.com/echocat/caddy-filter/blob/master/README.md)

## 示例

```caddy
filter rule {
    path                          <regexp pattern>
    content_type                  <regexp pattern>
    path_content_type_combination <and|or>
    search_pattern                <regexp pattern>
    replacement                   <replacement pattern>
}
filter rule ...
filter max_buffer_size    <maximum buffer size in bytes>
```

* __rule__：为要响应的文件定义一个新的筛选规则。
    
    重要提示：不要同时定义`path`和/或`content_type`。松弛规则会极大地影响系统性能，因为每个响应在返回之前都会被记录到内存中。
  
    * __path__：匹配请求路径的正则表达式。
    * __content_type__ 与请求的内容类型匹配的正则表达式，该内容类型在整个请求的评估之后产生。
    - __path_content_type_combination__ (从0.8版本开始) 可以是`and`或者`or`。（默认值为`and`，在这个参数存在之前是`or`）
    - __search_pattern__ 在响应体中查找正则表达式来替换它。
    - __replacement__ 替换`search_pattern`的模式。
    你可以使用参数，每个参数的格式必须是这样的：{name}。
        * 正则表达式组：`search_pattern`的每一组都可以使用{index}进行对应。
            * 例如：

                ```caddy
                &#34;My name is (.*?) (.*?).&#34; =&gt; &#34;Name: {2}, {1}.&#34;
                ```
        * 请求上下文：像URL...类似的参数都可以使用。
            例如:
            
            主机: {request_host}

>           * `request_header<header name>` 请求的头信息(如果提供或为空)。
            * `request_url` 完整的请求网址
            * `request_path` 请求路径
            * `request_method` 请求方法
            * `request_host` 目标主机
            * `request_proto` 使用协议
            * `request_remoteAddress` 调用客户端的远程地址
            * `response_header_<header name>` 响应的头信息(如果提供或为空)。
        * 文件替换符：如果替换的前缀是@字符，那么将尝试查找具有这个名称的文件并从那里加载替换。这将帮助你添加更大的有效负载的替换，也会直接丑陋地存在于Caddyfile。
            * 示例：`@myfile.html`
    * __max_buffer_size__ 将缓冲区大小限制为指定的最大字节数。如果一个规则匹配，在发送到HTTP客户端之前，首先将整个主体记录到内存中。如果达到这个限制，将不会执行任何过滤，内容将直接转发给客户端，以防止内存过载。默认值：10485760 (=10MB)


__在每个HTML页面中插入服务器名__

```caddy
filter rule {
    content_type text/html.*
    search_pattern Server
    replacement "This site was provided by {response_header_Server}"
}
```

__向文件中的每个HTML页面添加谷歌统计代码__

```caddy
filter rule {
    path .*\.html
    search_pattern </title>
    replacement @googleAnalyticsSnippet.html
}
```

__将每个文本文件中的Foo替换为Bar__

```caddy
filter rule {
    path .*\.txt
    search_pattern Foo
    replacement Bar
}
```