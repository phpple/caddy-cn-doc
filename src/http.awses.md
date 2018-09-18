---
date: 2018-09-18 22:21:01 +0800
title: "http.awses"
sitename: "Caddy中文文档"
---

# http.awses

awses是用于将签名和代理请求到AWS Elasticsearch (AWS ES)的插件。

配置对AWS ES域的访问可能很棘手。AWS ES域的访问策略基于一个[当事人](https://docs.aws.amazon.com/IAM/latest/UserGuide/reference_policies_elements_principal.html)(需要签名请求)或一个IP白名单。IP白名单IP地址通常不是一个可行的选择，标准工具(如curl或浏览器)不能正确对请求签名。

这正是这个插件要解决的问题。标准工具可以向Caddy服务器发出未经身份验证的请求，然后对这些请求签名并代理给AWS ES服务。

[完整文档](https://github.com/miquella/caddy-awses/blob/master/README.md)

## 示例

__所有region和domain__

```caddy
awses
```

对任何region和AWS ES的domain的请求用这样的格式代理：`/<region>/<domain>/<destination>`。

__指定region（全部domain）__

```caddy
awses {
    region us-west-2
}
```

对特定区域(us-west-2)的任何AWS ES的domain按照以下格式代理：`/<domain>/<destination>`。

__复杂/多种前缀__

```caddy
awses /docs/ {
    region us-east-1
    domain the-docs
}

awses /logs/ {
    domain es-logs
}

awses /other-account/logs/ {
    domain es-logs
    role arn:aws:iam::123456789012:role/elasticsearch-logs-us-east-2
}
```

对特定domain(the-docs)和region(us-east-1)的使用带有前缀(/docs/)的格式代理：`/docs/<destination>`

同时按照这样的格式代理特定domain（es-logs）的任意region的Amazon ES请求：`/logs/<region>/<destination>`。

还可以通过另一个帐户(基于角色访问)为特定的AWS ES的domain(es-logs)的任何region代理请求，格式为：`/other-account/logs/<region>/<destination>`。