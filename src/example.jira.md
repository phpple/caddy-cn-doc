---
date: 2018-12-08 22:57:11 +0800
title: "Jira的Caddy配置"
sitename: "Caddy配置示例"
template: "example"
---

# Jira的Caddy配置

<img src="https://wac-cdn.atlassian.com/dam/jcr:e348b562-4152-4cdc-8a55-3d297e509cc8/Jira%20Software-blue.svg?cdnVersion=kn" width="120">

1. 已经安装[Jira](https://www.atlassian.com/software/jira)程序（默认端口是8080）
2. 仔细阅读[这篇文章](https://confluence.atlassian.com/adminjiraserver071/integrating-jira-with-apache-using-ssl-802593043.html)，按照第1步和第3步实施（第2步是针对Apache的）
3. 编辑Caddyfile，将域名修改成你的域名（host.yourdomain.tld）
4. 使用此Caddyfile启动Caddy


## Caddyfile

```caddy
jira.hostname.tls {
    proxy / yourip:8080 {
        websocket
        transparent
    }
}
```
