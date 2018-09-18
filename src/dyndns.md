---
date: 2018-09-18 22:00:01 +0800
title: "dyndns"
sitename: "Caddy中文文档"
---

# dyndns

使用cloudflare.com或pdd.yandex.ru作为动态dns模式。

[完整文档](https://github.com/linkonoid/caddy-dyndns/blob/master/README.md)

## 示例

__完整的指令配置例子__

```caddy
dyndns {
    provider cloudflare     
    ipaddress http://whatismyip.akamai.com/
    auth *****af380b8d3 *****@*****.com
    domains *****.com www.*****.com
    period 30m
}
```

* __provider__: cloudflare/yandex - DNS服务商名称。

* __ipaddress__: 
    * __http__ 从远程服务器获取外部IP（http://whatismyip.akamai.com/, http://ipv4.myexternalip.com/raw或其他以原始格式的正文）。
    * __remote__ 通过本地模式自动获取远程IP。
    * __local__ 自动获得本地IP。
    * __xxx.xxx.xxx.xxx__ 使用你自己的IPxxx.xxx.xxx.xxx。


* __auth__: 
    * __AuthApikeyToken__ 授权token
    * __Email__  Email地址（目前只用于yandex）

* __domains__: 通过空格隔开的用于更新的域名列表。

* __period__: `XXs`/`XXm`/`XXh`/`XXd` - IP更新周期 (s - 秒, m - 分, h - 小时, d - 天)