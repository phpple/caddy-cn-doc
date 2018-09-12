---
name: "自动HTTPS"
sitename: "Caddy中文文档"
---

# 自动HTTPS

当符合下面一些合理的标准时，Caddy会自动为所有站点启用HTTPS:

* 主机名
    - 不为空
    - 不是localhost
    - 不是一个IP地址
    - 不超过一个通配符（*）
    - 通配符必须是最左边的标签
* 没有显式指定端口为80
* 没有显式指定使用http协议
* TLS没有在站点的定义中被关闭
* 不是你自己提供的证书和密钥
* Caddy能够绑定到端口80和443（除非使用DNS验证）

Caddy还会将所有HTTP请求重定向到与HTTPS对应的地址，只要Caddyfile中没有定义主机名的纯文本变体。

所有相关的资源都被完全管理，包括更新——你不需要任何操作。这是一个28秒的视频，展示了它的工作原理:

<iframe width="654" height="480" src="https://www.youtube.com/embed/nk4EWHvvZtI?ecver=1" frameborder="0" allow="autoplay; encrypted-media" allowfullscreen></iframe>

## 话题:

1. [要知道的问题/FAQ](#要知道的问题/FAQ)
    * [端口80和443](#端口80和443必须从外部打开)
    * [.caddy文件夹](#.caddy文件夹)
    * [测试、开发和高级设置](#测试、开发和高级设置)
    * [在负载均衡或代理之后](#在负载均衡或代理之后)
    * [多个Caddy实例共享证书](#多个Caddy实例共享证书)
    * [通配符证书](#通配符证书)
    * [透明度报告](#透明度报告)
2. [DNS验证](#DNS验证)
3. [按需TLS](#按需TLS)
4. [获得证书](#获得证书)
5. [更新证书](#更新证书)
6. [撤销证书](#撤销证书)
7. [OCSP Stapling](#OCSP Stapling)
8. [HTTP严格传输安全](#HTTP严格传输安全)

## 要知道的问题/FAQ

为了充分享受这一标志性功能，请阅读以下内容。

### 端口80和443必须从外部打开

默认情况下，Caddy将绑定到端口80和443端口，以服务于HTTPS并将HTTP重定向到HTTPS。这通常需要权限提升。在Linux系统中，使用[setcap](http://man7.org/linux/man-pages/man8/setcap.8.html)你就不需要用`root`权限就可将Caddy绑定到端口80和443。例如:`setcap cap_net_bind_service=+ep caddy`。不要忘记配置所有相关的防火墙，以允许Caddy使用这些端口建立进入和出去的连接！Caddy必须占用这些端口以获得证书，除非您在内部启用DNS 验证或将端口80和443转发到不同的端口(在这种情况下，您可以使用[命令行参数](cli.md)更改HTTP和HTTPS端口)。

### .caddy文件夹

Caddy将在您的家目录中创建一个名为`.caddy`的文件夹。它用来存储和管理通过HTTPS为你的站点提供私有服务所需的加密资源。__你的站点的证书和私钥存储在这里，需要注意备份和保护好这个文件夹。__如果没有家目录，除非设置了`$CADDYPATH`，否则将在当前工作目录中创建`.caddy`文件夹。家目录是通过环境变量指定的（`$HOME`或者`%HOMEPATH%`）。多个Caddy实例可以使用或者挂载`acme`子目录作为磁盘，Caddy将自动共享证书并协调维护它们。

### 测试、开发和高级设置

要测试或试验你的Caddy配置，请确保使用`-ca`参数将ACME端点更改为模拟或开发网址，否则你很可能达到速率限制，这可能会阻止您访问HTTPS长达一周。这在使用流程管理器或容器时尤其常见。Caddy的默认CA是[Let's Encrypt](https://letsencrypt.org/)，它的模拟端点不受相同的速率限制。

### 在负载均衡或代理之后
如果Caddy处于其他基础设施(如负载均衡)后端，那它可能难以获得证书。确保在所有计算机上都获得和正确设置SSL证书是你的责任。在大多数情况下，我们建议使用DNS验证(后面将会介绍)来获得证书。它不是默认使用的，但是配置起来很容易。如果您有一组Caddy实例，只要它们共享(挂载)相同的$CADDYPATH/acme目录，它们将自动协调证书的管理。

### 多个Caddy实例共享证书
在版本0.10.12中，Caddy通过在磁盘上共享证书，支持在fleet/集群配置中使用自动HTTPS。所有访问同一个$CADDYPATH/acme文件夹的Caddy实例都将从磁盘共享证书，并相应地同步它们的自动更新。它需要将文件夹挂载为本地文件系统的一部分。这允许您运行数千个Caddy实例，共享相同的证书，而不需要每个都尝试更新它们：只有一个会更新，其余的将加载刷新的证书并使用它。

### 通配符证书
当站点配置了合格的通配符主机名时，Caddy可以获得和管理通配符证书。如果一个站点的最左边的域标签是通配符，那么该站点名称就属于通配符。例如，`*.example.com`有资格，但这些不行：`sub.*.example.com`, `foo*.example.com`， `*bar.example.com`， `*.*.example.com`等等。要获得通配符，只需启用DNS验证(后面将会介绍;它使用非常简单)。我们建议只在您有很多子域名时才使用通配符，因为尝试给他们全部获取证书时可能会遇到CA限速。如果您的Caddyfile中有许多不同配置的子域名，您还可以使用[tls](tls.md)指令的`wildcard`子指令为它们强制使用通配符。

### 透明度报告
当Caddy从发布证书透明日志的CA获得证书时，必须将您的域名和/或IP地址包含在这些日志中，因为它们不被视为私有信息。(Let's Encrypt就是这样一个CA)这是件好事；证书透明度报告[促使CA负责](https://googleonlinesecurity.blogspot.com/2015/10/sustaining-digital-certificate-security.html)。

## DNS验证

Caddy可以通过多种验证类型获得证书。只有一种验证Caddy不需要任何配置；另一种DNS验证类型需要配置，在其他验证类型失败后可以使用。Caddy支持许多DNS服务商。

要使用DNS验证，你必须做三件事：
1. 下载Caddy时绑定对应的供应商插件。
2. 在Caddyfile中告知Caddy使用哪家供应商。
3. 通过环境变量给Caddy提供访问你账户的凭证以解决验证。

#### 启用DNS验证
在Caddyfile中，你可以如下使用[tls指令](tls.md)和`dns`关键字：

```caddy
tls {
    dns provider
}
```

将"provider"替换为你的DNS服务商的名称(在下表中)。另外，你还需要使用你帐户的凭证设置环境变量：

| 服务商   |  Caddyfile中使用的名称 | 需要设置的环境变量 |
|---------|----------------------|-----------------|
| Aurora DNS by PCExtreme | auroradns |  AURORA_USER_ID<br>AURORA_KEY<br>AURORA_ENDPOINT (可选) |
| Azure DNS |  azure |  AZURE_CLIENT_ID<br>AZURE_CLIENT_SECRET<br>AZURE_SUBSCRIPTION_ID<br>AZURE_TENANT_ID |
| Cloudflare | cloudflare | CLOUDFLARE_EMAIL<br>CLOUDFLARE_API_KEY |
| CloudXNS | cloudxns | CLOUDXNS_API_KEY<br>CLOUDXNS_SECRET_KEY |
| DigitalOcean | digitalocean | DO_AUTH_TOKEN |
| DNSimple | dnsimple | DNSIMPLE_EMAIL<br>DNSIMPLE_OAUTH_TOKEN<br>DNS Made Easy   dnsmadeeasy DNSMADEEASY_API_KEY<br>DNSMADEEASY_API_SECRET<br>DNSMADEEASY_SANDBOX (true/false) |
| DNSPod | dnspod | DNSPOD_API_KEY |
| DynDNS | dyn | DYN_CUSTOMER_NAME<br>DYN_USER_NAME<br>DYN_PASSWORD |
| Gandi | gandi/gandiv5 | GANDI_API_KEY / GANDIV5_API_KEY |
| GoDaddy | godaddy | GODADDY_API_KEY<br>GODADDY_API_SECRET |
| Google Cloud DNS  |  googlecloud | GCE_PROJECT<br>GCE_DOMAIN<br>GOOGLE_APPLICATION_CREDENTIALS<br>(or GCE_SERVICE_ACCOUNT_FILE) |
| Lightsail | by | AWS    lightsail   AWS_ACCESS_KEY_ID<br>AWS_SECRET_ACCESS_KEY<br>AWS_SESSION_TOKEN （可选）<br>DNS_ZONE （可选） |
| Linode | linode | LINODE_API_KEY |
| Namecheap | namecheap | NAMECHEAP_API_USER<br>NAMECHEAP_API_KEY |
|NS1.   | ns1 | NS1_API_KEY |
| Name.com  |  namedotcom | NAMECOM_USERNAME<br>NAMECOM_API_TOKEN |
| OVH | ovh | OVH_ENDPOINT<br>OVH_APPLICATION_KEY<br>OVH_APPLICATION_SECRET<br>OVH_CONSUMER_KEY |
| Open Telekom Cloud Managed DNS | otc | OTC_DOMAIN_NAME<br>OTC_USER_NAME<br>OTC_PASSWORD<br>OTC_PROJECT_NAME<br>OTC_IDENTITY_ENDPOINT （可选） |
| PowerDNS | pdns | PDNS_API_URL<br>PDNS_API_KEY |
| Rackspace | rackspace | RACKSPACE_USER<br>RACKSPACE_API_KEY<br>rfc2136 RFC2136_NAMESERVER<br>RFC2136_TSIG_ALGORITHM<br>RFC2136_TSIG_KEY<br>RFC2136_TSIG_SECRET |
| Route53 | by | AWS  route53 AWS_ACCESS_KEY_ID<br>AWS_SECRET_ACCESS_KEY |
| Vultr | vultr | VULTR_API_KEY |

当您配置DNS验证时，Caddy将专门使用该验证类型。注意，一些服务商使更改生效的速度可能很慢(按分钟计算)。

## 按需TLS
Caddy在试验一种叫做按需TLS的新技术。这意味着Caddy可以在第一次TLS握手时为尚未拥有证书的主机名获取站点证书。

要启用On-Demand TLS，可以将`tls`指令与`max_certs`或`ask`一起使用。例如，你的Caddyfile可能会像这样：

```caddy
*.example.com
proxy / localhost:4001 localhost:4002
tls {
    max_certs 10
}
```

这个Caddyfile将代理所有example.com子域名的请求到后端的前10个唯一的主机名。这意味着你可以动态地提供新的DNS记录，而且它们将开始使用HTTPS。与通配符证书不同，按需证书不限于子域名。

您还可以使用`ask`来查询本地后端是否允许主机名获得证书：

```caddy
tls {
    ask http://localhost:9005/allowed
}
```

如果HTTP请求返回状态码200,CA将按需请求证书。对于按需TLS，至少需要一个`max_certs`或`ask`。

> 减少滥用：这个特性故意限制了速率。`tls`指令的`max_certs`属性对以这种方式发出的新证书的数量设置了强制性限制，因此即使在很长一段时间内，攻击者也无法发出无限制的证书并填满您的磁盘空间。如果这种限速在你的情况下是不可接受的，那么您可以使用`ask`子指令指定一个内部网址, Caddy可以从中询问某个主机名是否被授权使用证书(Caddy的内置速率限制在使用ask时不适用)。

随需TLS是一种特殊的托管TLS，因此除了不提供自己的证书和密钥的要求外，上述所有要求仍然适用：您可以使用自己的证书来提供给随需TLS。和常规托管TLS一样，HTTP将被重定向到HTTPS。

> 未来支持：这个特性依赖于CA发出证书没有延迟。如果在ACME CA中经常不能及时发出证书，我们可以在Caddy中停止此功能。

一旦按需获得证书，它就像其他托管证书一样存储在磁盘上。它还存储在内存中，以便在未来握手时能快速检索。

随需TLS受以下速率限制：

* 同一时间只能进行一次证书验证。
* 在成功获得10个证书之后，新的证书验证要在最后一次成功的验证10分钟后才会出现。
* 在验证过程中失败的域名将不允许在5分钟内再次尝试。

注意，当进程退出时，速率限制将被重置。建议使用`-log`选项，因为所有证书验证都会被记录起来。__注意，如果在配置中指定了ask网址，这些内置的速率限制就不起效果了。__在使用ask时，节点必须为名称返回200状态码，以便进行证书验证。

> 测试你的配置:如果你的CA有一个模拟端点，强烈建议你使用它来测试你的配置。Let's Encrypt是Caddy的默认CA，它有一个模拟端点，不受严格的速率限制。

本页面的其余部分将解释有关自动HTTPS的更多细节，但使用Caddy并不需要这些知识。


## 获取证书

要通过HTTPS为站点提供服务，需要从受信任证书颁发机构(CA)获得有效的SSL证书。当Caddy启动时，它将从[Let's Encrypt](https://letsencrypt.org/)中获得符合条件的站点的证书。以后的过程几乎完全是自动的，默认情况下是打开的。

如果有必要，Caddy会在CA的服务器上创建一个带有(或不带有)你的电子邮件地址的帐户。如果Caddy无法从Caddyfile、命令行标志或之前运行的磁盘中找到电子邮件地址，那么它可能必须提示你输入电子邮件地址。在自动化环境中使用时，使用`-agree`标志并提供电子邮件地址，以确保不会提示你同意条款。但是这应该只在第一次使用自动HTTPS时才需要。

一旦手续办妥，Caddy会为每个站点生成私钥和证书签名请求(CSR)。私钥永远不会离开服务器，并且被安全地存储在文件系统中。

Caddy与CA的服务器建立了一个连接。一个简短的加密发生，以证明Caddy确实服务于它所说的网站。一旦CA服务器验证了这一点，它就会通过连接将该站点的证书发送给Caddy, Caddy将证书放在.caddy目录中。

这个过程通常对每个域名而言将花费几秒钟的时间，一旦获得了站点的证书，之后就会直接从磁盘加载，下次再运行Caddy也能继续重用。换句话说，延迟启动是一次性事件。如果现有证书需要更新，Caddy会立即处理。

Caddy同步多个实例之间的证书，只要它们共享磁盘上的同一个.caddy/acme文件夹。这意味着需要相同证书的多个实例不会同时从CA请求一个证书，它们将从磁盘共享相同的副本。


## 更新证书

证书只能在有限的时间内有效，所以Caddy定期检查每个证书，并自动更新即将过期的证书(30天)。如果更换失败，Caddy将继续尝试。

一旦Caddy获得新证书，它就会将用新证书替换旧证书。这种替换不会导致服务中断。

像获取证书一样，在一个集群中使用时，只要实例共享同一个.caddy/acme文件夹，Caddy就会协调进行证书的更新。实际上只有一个实例将执行更新，其他实例将重新加载更新后的证书。


## 撤销证书

Caddy不会自动撤销证书，但是您可以使用`-revoke`选项来指定域名。只有当你的站点的私钥或证书颁发机构被破坏时，才需要这样做。在撤销之后，Caddy将从磁盘删除证书文件，以防止下次运行时使用它。

## OCSP Stapling

Caddy会固化所有证书的OSCP信息，里边包含了一个OCSP的链接，用来保护你的网站客户的隐私和减少OCSP服务器的压力。缓存的OCSP状态将定期检查，如果有更改，服务器将固化新的响应。

当获得新的OCSP响应时，Caddy将响应保存在磁盘上，以便能够经受长时间的OCSP响应中断。与证书一样，持久化的OCSP响应在.caddy文件夹中得到了充分维护。

## HTTP严格传输安全

HTTP严格传输安全(HSTS)是一种web安全策略机制，有助于保护网站免受协议降级攻击和cookie劫持。启用HSTS意味着web浏览器只应该使用安全的HTTPS连接与服务器交互，而绝不应该通过不安全的HTTP连接。策略指定了必须以安全方式访问服务器的一段时间。

Caddy默认不启用HSTS，因为如果你希望在不使用HTTPS的情况下使用域，而HSTS已经启用并被记住了，这意味着浏览器在这段时间内将不允许连接到你的服务器。只有当你知道将来不希望禁用HTTPS时，才应该在生产环境中启用HSTS。通过将下面的header添加到Caddyfile中，可以很容易地启用它。

```caddy
header / Strict-Transport-Security "max-age=31536000;"
```
