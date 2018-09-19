---
date: 2018-09-19 21:26:49 +0800
title: "http.prometheus"
sitename: "Caddy中文文档"
---

# http.prometheus

这个指令给Caddy启用[prometheus](https://prometheus.io/)指标。

[完整文档](https://github.com/miekg/caddy-prometheus/blob/master/README.md)

## 示例

__启用指标__

```caddy
prometheus
```

对于你想要查看指标的每个虚拟主机。

它可以选择暴露指标的地址，默认是localhost:9180。维度路径固定是`/metrics`。

你需要将这个模块放在链的前面，这样持续时间直方图才有意义。我把它放在下标0的位置。
