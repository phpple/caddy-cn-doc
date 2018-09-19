---
date: 2018-09-19 20:26:35 +0800
title: "http.jekyll"
sitename: "Caddy中文文档"
---

# http.jekyll

jekyll指令填补了[jekyll](https://jekyllrb.com/)和终端用户之间的间隙，为你提供了一个管理整个网站的web界面。

要求：你需要让Jekyll在你的`PATH`变量。你可以从它的[官方页面](https://jekyllrb.com/docs/installation/)下载。

[完全文档](https://filebrowser.github.io/caddy/)

## 示例

__基本用法__

```caddy
root _site
jekyll
```

在`/admin`管理当前工作目录的Jekyll网站，并向用户显示`_site`文件夹。
