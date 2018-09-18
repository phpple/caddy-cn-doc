---
date: 2018-09-18 23:20:16 +0800
title: "http.cgi"
sitename: "Caddy中文文档"
---

# http.cgi

这个插件为Caddy实现了通用网关接口(CGI)。它允许通过命令行脚本在你的网站上生成动态内容。为了收集关于入站HTTP请求的信息，你的脚本会检查某些环境变量，例如`PATH_INFO`和`QUERY_STRING`。然后，要将动态生成的web页面返回给客户机，脚本只需将内容写入标准输出。对于POST请求，脚本从标准输入读取额外的入站内容。

[完整文档](https://jung-kurt.github.io/cgi/)

## 示例

__简单的CGI脚本__

Caddyfile配置：
```caddy
cgi /report /usr/local/cgi-bin/report
```

`/usr/local/cgi-bin/report`的内容：

```bash
#!/bin/bash

printf "Content-type: text/plain\n\n"

printf "PATH_INFO    [%s]\n" $PATH_INFO
printf "QUERY_STRING [%s]\n" $QUERY_STRING

exit 0
```

当`https://example.com/report`或`https://example.com/report/weekly`等请求到达时，cgi中间件将检测匹配并调用名为`/usr/local/cgi-bin/report`的脚本。

环境变量PATH_INFO和QUERY_STRING被自动填充并传递给脚本。[文档](https://jung-kurt.github.io/cgi/)中还描述了其他一些标准CGI变量。如果需要传递任何特殊的环境变量或允许任何属于Caddy进程的环境变量传递给你的脚本，你就需要使用到文档中描述的高级指令语法了。