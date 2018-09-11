---
date: 2018-09-11 22:32:16 +0800
title: "http.status"
sitename: "Caddy中文文档"
---

# http.status

status将状态码写入响应。它不写响应体。

## 语法

```caddy
status code path
```

* __code__ 响应的HTTP状态码(必须是数字的)。
* __path__ 匹配的基本请求路径。

如果你有很多状态重写到组，通过创建一个表来共享状态码:

```
status code {
    path
}
```

每一行都描述了应该返回该状态码的基本路径。

## 示例

全部使用一个状态码：

```caddy
status 404 /
```

隐藏/secrets目录的存在:

```caddy
status 404 /secrets
```

隐藏多个目录：

```
status 404 {
    /hidden
    /secrets
}
```