---
date: 2018-09-19 21:16:03 +0800
title: "http.nobots"
sitename: "Caddy中文文档"
---

# http.nobots

nobots保护你的网站免受网络爬虫和机器人。

[完整文档](https://github.com/Xumeiquer/nobots/blob/master/README.md)

## 示例

__通过User-Agent禁止机器人__

```caddy
nobots "bomb.gz" {
    "Mozilla/5.0 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)"
    "Googlebot/2.1 (+http://www.google.com/bot.html)"
    "Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/41.0.2272.96 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)"
    "Googlebot-News"
    "Googlebot-Image/1.0"
    "Googlebot-Video/1.0"
    "compatible; Mediapartners-Google/2.1; +http://www.google.com/bot.html"
    "Mediapartners-Google"
    "AdsBot-Google (+http://www.google.com/adsbot.html)"
    "AdsBot-Google-Mobile-Apps"
    "APIs-Google (+https://developers.google.com/webmasters/APIs-Google.html)"
}
```

它会发送`bomb.gz`到指令块中列出的Google机器人。

__使用正则表达式禁止机器人__

```caddy
nobots "bomb.gz" {
    regexp "bingbot"
}
```

它会发送`bomb.gz`给所有包含bingbot的用户代理。

__混合字符串和正则表达式__

```caddy
nobots "bomb.gz" {
    "msnbot-media/1.1 (+http://search.msn.com/msnbot.htm)"
    regexp "bingbot"
}
```

它会发送`bomb.gz`给所有包含bingbot的用户代理，以及和上面一致的字符串的用户代理。

__指定不保护的网址__

```caddy
nobots "bomb.gz" {
    "Googlebot"
    public "^/public"
    public "^/[a-z]{,5}/public"
}
```

它会发送`bomb.gz`给user agent为Googlebot，且不是访问public关键字定义的网址的请求。
