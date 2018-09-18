---
date: 2018-09-18 22:50:26 +0800
title: "http.awslambda"
sitename: "Caddy中文文档"
---

# http.awslambda

awslambda插件用来充当[AWS Lambda函数](https://amazonaws-china.com/cn/documentation/lambda/)的网关。

[完整文档](https://github.com/coopernurse/caddy-awslambda/blob/master/README.md)

## 示例

__将/api/*的请求代理到Lambda__

```caddy
awslambda /api/ {
    aws_region  us-west-2
    qualifier   prod
    include     api-*
    exclude     *-internal
}
```

通过以/api/为前缀的网址代理到`us-west-2`这个region的AWS Lambda的请求，用于从以"api-"开始但不以"-internal"结尾的函数。`qualifier`用于将每个函数指向`prod`这个[别名](https://docs.aws.amazon.com/zh_cn/lambda/latest/dg/aliases-intro.html)。

例如，对/api/api-user的请求将分别调用AWS Lambda函数“api-user”。
