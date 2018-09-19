---
date: 2018-09-19 21:39:58 +0800
title: "http.proxyprotocol"
sitename: "Caddy中文文档"
---

# http.proxyprotocol

这个指令启用Caddy的代理协议(v1)支持。

[代理协议](http://www.haproxy.org/download/1.8/doc/proxy-protocol.txt)允许通过负载均衡传递客户机IP，就像[AWS](https://docs.aws.amazon.com/elasticloadbalancing/latest/classic/enable-proxy-protocol.html#enable-proxy-protocol-cli)或[Gooble Cloud](https://cloud.google.com/compute/docs/load-balancing/tcp-ssl/#proxy-protocol)中使用的那样。

[完整文档](https://github.com/mastercactapus/caddy-proxyprotocol/blob/master/README.md)

## 示例

__从本地子网和固定IP启用__

```caddy
proxyprotocol 10.22.0.0/16 10.23.0.1/32
```

允许来自10.22.0.0/16子网和10.23.0.1 IP的IPv4流量发送代理报头。

__从任何来源启用__

```caddy
proxyprotocol 0.0.0.0/0 ::/0
```

这允许任何客户端指定代理数据。(不建议用于生产环境)
