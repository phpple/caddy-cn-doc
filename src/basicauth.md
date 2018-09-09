---
date: 2018-09-09 21:06:24 +0800
title: "http.basicauth"
sitename: "Caddy中文文档"
---

# http.basicauth

basicauth实现HTTP基本身份验证。基本身份验证可用于通过用户名和密码保护目录和文件。注意，基本身份校验在纯HTTP协议访问时也是不安全的。请谨慎考虑决定使用HTTP基本身份验证来保护什么。

当用户请求受保护的资源时，如果用户尚未提供用户名和密码，浏览器将提示用户输入用户名和密码。如果`Authorization`头中存在正确的凭证，服务器将授予对资源的访问权，并将`{user}`[占位符](placeholders.md)设置为用户名的值。如果头信息丢失或凭证不正确，服务器将返回"HTTP 401 Unauthorized"。

此指令允许使用.htpasswd文件，方法是在密码参数前面加上`htpasswd=`和要使用的.htpasswd文件的路径。

> 对.htpasswd的支持只针对遗留站点，将来可能会被删除;不要在新站点上使用.htpasswd。

## 语法

```caddy
basicauth path username password
```

* __path__ 要保护的文件或目录
* __username__ 用户名
* __password__ 密码

这种语法使用默认范围(realm)"Restricted"，对于保护单个文件或基本路径/目录非常方便。为了保护多个资源或指定一个范围，使用下面的变体：

```caddy
basicauth username password {
    realm name
    resources
}
```

* __username__ 用户名
* __password__ 密码
* __realm__ 标识保护范围；它是可选的，不能重复。realm用于指定应用保护的范围。对于配置为记住身份验证细节(大多数浏览器都是这样)的用户代理来说非常方便。
* __resources__ 要保护的文件/目录列表，每行一个。

## 例子
保护"/secret"下所有文件，只有Bob使用密码"hiccup"才能访问：

```caddy
basicauth /secret Bob hiccup
```

使用范围"Mary Lou's documents"保护多个文件和目录，用户"Mary Lou"可以使用她的密码"milkshakes"访问：

```caddy
basicauth "Mary Lou" milkshakes {
    realm "Mary Lou's documents"
    /notes-for-mary-lou.txt
    /marylou-files
    /another-file.txt
}
```



