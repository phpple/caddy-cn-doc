---
date: 2019-08-01 23:37:37 +0800
title: "consul"
sitename: "Caddy中文文档"
---

# consul

这个插件允许Caddy使用Consul的KV存储，允许在集群中的多个Caddy实例之间共享TLS数据。

[完整文档](https://github.com/pteich/caddy-tlsconsul/blob/master/README.md)

## 示例

### 启用Consul集群支持

```bash
# 启用Consul集群插件
export CADDY_CLUSTERING="consul"

# 设置k/v路径前缀
export CADDY_CLUSTERING_CONSUL_PREFIX="caddy/tls"

# 设置用来加密的AES密钥(32个字节)
export CADDY_CLUSTERING_CONSUL_AESKEY="consultls-1234567890-caddytls-32"

# 设置Consul地址
export CONSUL_HTTP_ADDR="127.0.0.1:8500"

# 设置Consul的访问token
export CONSUL_HTTP_TOKEN=""
```

这个插件是使用环境变量配置的。要启用consule集群支持，请将CADDY_CLUSTERING设置为“consul”。