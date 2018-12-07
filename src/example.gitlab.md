---
date: 2018-11-28 22:38:34 +0800
title: "Gitlab的Caddy配置"
sitename: "Caddy配置示例"
template: "example"
---

# Gitlab的Caddy配置

这是使用Caddy运行[Gitlab](https://gitlab.com/)的配置示例。

## 更新Gitlab配置

使用你喜欢的文本编辑器打开`/etc/gitlab/gitlab.rb`，更新下面的值。

* 替换`external_url`为`https`协议
* 把`gitlab_workhorse['listen_network']`从"unix"改成"tcp"
* 把`gitlab_workhorse['listen_addr']`从"000"改成"127.0.0.1:8181"
* 除了root，把`web_server['external_users']`改成运行caddy的用户
* 把`nginx['enable'] = "true"`改成`nginx['enable'] = "false"`
* 保存并退出配置文件，然后运行`gitlab-ctl reconfigure`使配置生效

## 更新Caddyfile
将`gitlab.example.com`指向你的FQDN。

## Caddyfile

**代理到http**

```caddy
https://gitlab.example.com {
    log git.access.log 
    errors git.errors.log {
        404 /opt/gitlab/embedded/service/gitlab-rails/public/404.html
        422 /opt/gitlab/embedded/service/gitlab-rails/public/422.html
        500 /opt/gitlab/embedded/service/gitlab-rails/public/500.html
        502 /opt/gitlab/embedded/service/gitlab-rails/public/502.html
    }

    proxy / http://127.0.0.1:8181 {
        fail_timeout 300s
        transparent
        header_upstream X-Forwarded-Ssl on
    }
}
```

**代理到socket文件**

```caddy
https://gitlab.domain.tld {

    errors {
        404 /opt/gitlab/embedded/service/gitlab-rails/public/404.html
        422 /opt/gitlab/embedded/service/gitlab-rails/public/422.html
        500 /opt/gitlab/embedded/service/gitlab-rails/public/500.html
        502 /opt/gitlab/embedded/service/gitlab-rails/public/502.html
    }

    proxy / unix:/home/git/gitlab/tmp/sockets/gitlab.socket {
        fail_timeout 300s

        transparent
    }
}
```