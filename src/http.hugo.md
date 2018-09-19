---
date: 2018-09-19 08:41:28 +0800
title: "http.hugo"
sitename: "Caddy中文文档"
---

# http.hugo

hugo填补了[Hugo](https://gohugo.io/)和浏览器之间的空白。Hugo是一个简单快速的静态网站生成器。这个插件填补了Hugo和最终用户之间的空白，提供了一个web界面来管理整个网站。

使用这个插件，你不需要用自己的电脑来编辑帖子，也不需要重新生成你的静态网站，因为你可以通过你的浏览器完成所有这些。

需求：你需要在你的`PATH`环境变量中有hugo可执行文件。你可以从它的[官方页面](https://gohugo.io/getting-started/installing/)下载。

[完整文档](https://filebrowser.github.io/caddy/)

## 示例

__基本用法__

```caddy
root public
hugo
```

在`/admin`管理当前工作目录的Hugo网站，并向用户显示`public`文件夹。

__自定义站点根目录__

```caddy
root /var/www/mysite/public
hugo /var/www/mysite
```

管理位于`/var/www/mysite`的Hugo网站，并将`public`文件夹显示给用户。

__自定义网站根目录及基本网址__

```caddy
root /var/www/mysite/public
hugo /var/www/mysite /private
```

通过网址`/private`管理位于`/var/www/mysite`的Hugo网站，并将`public`目录展示给用户。