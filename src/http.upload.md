---
date: 2018-09-17 10:07:39 +0800
title: "http.upload"
sitename: "Caddy中文文档"
---

# http.upload

使用API或者HTTP方法POST/PUT完成图片上传。

使用curl之类的工具上传构建构件、即将下载的文件或一些千奇百怪的文件，非常方便。

[完整文档](https://hub.blitznote.com/src/caddy.upload/blob/master/README.md)

## 示例

__快速简单上传__

```bash
curl \
  -T /etc/os-release \
  https://127.0.0.1/wp-upload/os-release
```

上传`os-release`到路径`wp-upload`。

__快速删除__

```bash
curl -X DELETE \
  https://127.0.0.1/wp-upload/os-release
```

如果存在`wp-upload/os-release`，删除之。

__移动或者重命名文件__

```bash
curl -X MOVE \
  -H "destination: /wp-upload/old-release" \
  https://127.0.0.1/wp-upload/os-release
```

字后该文件将能通过新名称访问。