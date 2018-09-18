---
date: 2018-09-18 22:16:39 +0800
title: "http.authz"
sitename: "Caddy中文文档"
---

# http.authz

Caddy-authz是Caddy的授权中间件，它基于Caddy-authz：<https://github.com/casbin/casbin>。

Casbin是一个基于Golang实现的功能强大、高效的开源访问控制库。它提供了基于ACL、RBAC、ABAC等各种模型的强制授权支持。

[完整文档](https://github.com/casbin/caddy-authz/blob/master/README.md)

## 示例

__简单示例__

```caddy
package main

import (
    "net/http"

    "github.com/casbin/caddy-authz"
    "github.com/casbin/casbin"
    "github.com/mholt/caddy/caddyhttp/httpserver"
)

func main() {
    // load the casbin model and policy from files, database is also supported.
    e := casbin.NewEnforcer("authz_model.conf", "authz_policy.csv")

    // define your handler, this is just an example to return HTTP 200 for any requests.
    // the access that is denied by authz will return HTTP 403 error.
    handler := authz.Authorizer{
        Next: httpserver.HandlerFunc(func(w http.ResponseWriter, r *http.Request) (int, error) {
            return http.StatusOK, nil
        }),
        Enforcer: e,
    }
}
```

使用简单的模型文件和策略文件对HTTP请求进行授权。