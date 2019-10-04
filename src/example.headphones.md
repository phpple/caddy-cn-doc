---
date: 2018-12-08 00:03:23 +0800
title: "Headphones的Caddy配置"
sitename: "Caddy配置示例"
template: "example"
---

# Headphones的Caddy配置

![Headphones](https://raw.githubusercontent.com/rembo10/headphones/master/data/images/headphoneslogo.png)

这是如何用[Headphones](https://github.com/rembo10/headphones)使用Caddy访问的配置示例。

这个配置文件采用了如下的假设：

* Headphones监听端口8181。
* 你的域名是`myheadphones.com`。
* Headphones的http域名是在`Settings` -> `Web Interface` -> `HTTP Host`中，被设置为`0.0.0.0`。

请将上述内容替换为实际的值。

## Caddyfile

```caddy
myheadphones.com {
    proxy / localhost:8181 {
        transparent
    }
}
```