---
date: 2018-09-19 22:01:52 +0800
title: "http.reauth"
sitename: "Caddy中文文档"
---

# http.reauth

reauth插件是用于对各种和多种身份验证系统进行身份验证的通用基础。

这是因为我们希望根据gitlab-ci动态地验证docker注册表，并避免在gitlab中存储凭证，同时仍然允许用户使用自己的凭证登录。

[完整文档](https://github.com/freman/caddy-reauth/blob/master/README.md)

## 示例

__配置__

```caddy
reauth {
    path /v2
    simple username=password,root=badpractice
    upstream url=https://accounts.example.com/check
    gitlab url=https://gitlab.example.com/
}
```

对/v2的访问进行身份验证(按照以下顺序)：
1. 用户名和密码是否与任何给定的通过逗号分隔的凭证匹配；
2. 对https://accounts.example.com/check进行BASIC校验；
3. 通过gitlab-ci-token用户访问gitlab项目(docker login docker.example.com -u "$CIPROJECTPATH" -p "$CIBUILDTOKEN")