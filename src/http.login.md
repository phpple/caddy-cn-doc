---
date: 2018-09-19 20:43:06 +0800
title: "http.login"
sitename: "Caddy中文文档"
---

# http.login

Caddy的login指令基于`github.com/tarent/loginsrv`。login将根据后端进行检查，然后作为JWT令牌返回。此指令被设计与http.jwt中间件一起使用。