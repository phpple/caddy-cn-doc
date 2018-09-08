---
name: "HTTPS自动化"
sitename: "Caddy中文文档"
---

# HTTPS自动化

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
* Caddy能够绑定到端口80和443（除非使用DNS challenge）

Caddy还会将所有HTTP请求重定向到与HTTPS对应的地址，只要Caddyfile中没有定义主机名的纯文本变体。

所有相关的资源都被完全管理，包括更新——你不需要任何操作。这是一个28秒的视频，展示了它的工作原理:

<iframe width="654" height="480" src="https://www.youtube.com/embed/nk4EWHvvZtI?ecver=1" frameborder="0" allow="autoplay; encrypted-media" allowfullscreen></iframe>

## 话题:

1. 要知道的问题/FAQ
    * 端口80和443
    * .caddy目录
    * 测试、开发和高级设置
    * 在负载均衡或代理之后
    * 在Caddy示例间共享证书
    * 通配符证书
    * 透明度报告
2. DNS Challenge
3. On-Demand TLS
4. 获得证书
5. 更新证书
6. 撤销证书
7. OCSP Stapling
8. HTTP严格传输安全性

