---
name: "HTTPS劫持诊断"
sitename: "Caddy中文文档"
---

# HTTPS劫持诊断

Caddy有能力检测是否有中间人(MITM)在攻击HTTPS连接，虽然浏览器和最终用户可能看不到这些攻击。这意味着Caddy可以确定TLS代理是否“可能”或“不可能”正在积极地拦截HTTPS连接。

<iframe src="/mitm/check" frameborder="0" width="100%" height="200"></iframe>

根据Durumeric, Halderman等人在他们的[NDSS '17 paper](https://jhalderm.com/pub/papers/interception-ndss17.pdf)中描述的技术，所有传入的HTTPS连接都会自动检查是否被篡改。检查结果在通过各种方式传达给Caddy，因此你可以选择如何处理可疑的MITM攻击您的客户。(请记住，许多TLS代理以“仁慈的”反病毒或防火墙产品的形式出现。)