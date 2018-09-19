---
date: 2018-09-19 20:33:29 +0800
title: "http.jwt"
sitename: "Caddy中文文档"
---

# http.jwt

这个中间件基于JSON Web令牌(JWT)为Caddy实现了一个授权层。

## 示例

__基本语法__

```caddy
jwt [path]
```

默认情况下，路径下的所有资源都将使用JWT验证进行保护。要指定需要保护的资源列表，请使用多个声明。请务必阅读插件文档，以正确配置服务器以验证令牌。

__高级语法__

```caddy
jwt {
   path [path]
   redirect [location]
   allow [claim] [value]
   deny [claim] [value]
}
```

你可以选择使用声明信息进一步控制对路由的访问。在jwt块中，可以根据`claim`的值指定允许或拒绝访问的规则。你还可以指定一个重定向URL，以便将无效的令牌发送到登录页面。有关如何使用高级语法的更多信息，请参阅插件文档。它有更详细的例子说明插件将如何向你的应用程序传递声明。
