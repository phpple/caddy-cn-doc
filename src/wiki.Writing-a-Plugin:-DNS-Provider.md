---
date: 2018-10-07 19:33:21 +0800
title: "开发插件：DNS提供者"
sitename: "Caddy开发者wiki"
template: "wiki"
---

# 开发插件：DNS提供者

_<small>英文原文：<https://github.com/mholt/caddy/wiki/Writing-a-Plugin:-DNS-Provider></small>_

----------------------------

加入[Caddy交流论坛](https://caddy.community/)和其他开发者一起分享。

Caddy通过三种方式神奇地获得站点的TLS证书：HTTP、TLS-SNI和DNS。前两个是默认使用的，可以在不需要你干预的情况下完成。第三种方法在某些环境中更加通用，在这些环境中，你不能启动外部网络可以访问的侦听器等等。问题是，使用DNS方法需要定制代码与你的域的名称服务器指向的DNS提供者交互。

Caddy使用[xenolf/lego](https://github.com/xenolf/lego)实现ACME协议并解决领域挑战(lego最初是为Caddy编写的)。它支持可插入的DNS提供者，但要在Caddy中使用它们，必须对它们进行调整。它只需要几行代码。

如果你想添加一个新的DNS提供者，那么必须构建它来与lego一起工作(有关说明和文档，请参阅代码库)。一旦这管用了，你可以很容易让与Caddy适配：

```go
package myprovider

import (
    "errors"

    "github.com/mholt/caddy/caddytls"
    "github.com/xenolf/lego/providers/dns/myprovider"
)

func init() {
    caddytls.RegisterDNSProvider("myprovider", NewDNSProvider)
}

// NewDNSProvider returns a new MyProvider DNS challenge provider.
// The credentials are interpreted as follows:
//
// len(0): use credentials from environment
// len(2): credentials[0] = API user
//         credentials[1] = API key
func NewDNSProvider(credentials ...string) (caddytls.ChallengeProvider, error) {
    switch len(credentials) {
    case 0:
        return myprovider.NewDNSProvider()
    case 2:
        return myprovider.NewDNSProviderCredentials(credentials[0], credentials[1])
    default:
        return nil, errors.New("invalid credentials length")
    }
}
```

注意，我们不直接将DNS提供者插入到caddy包中；我们把它插进Caddy。

你可以在[caddyserver/dnsproviders](https://github.com/caddyserver/dnsproviders)中看到所有正式支持的适配器。如果你已经编写了一个DNS提供商，请随时提交一个Pull请求去适配它，供Caddy使用！

一旦你的提供者被插入，你可以在Caddyfile这样使用它：

```go
tls {
    dns myprovider
}
```

就是这样。