---
date: 2018-11-28 22:38:34 +0800
title: "Gitlab的Caddy配置"
sitename: "Caddy配置示例"
template: "example"
---

# Gitlab的Caddy配置

<svg height="100" viewBox="0 0 1231 342" xmlns="http://www.w3.org/2000/svg" class="nav-logo"> <g fill="none" fill-rule="evenodd"> <g fill="#8C929D" class="wordmark"> <path d="M764.367 94.13h-20.803l.066 154.74h84.155v-19.136h-63.352l-.066-135.603zM907.917 221.7c-5.2 5.434-13.946 10.87-25.766 10.87-15.838 0-22.22-7.797-22.22-17.957 0-15.354 10.637-22.678 33.332-22.678 4.255 0 11.11.472 14.655 1.18v28.586zm-21.51-93.787c-16.8 0-32.208 5.952-44.23 15.858l7.352 12.73c8.51-4.962 18.91-9.924 33.802-9.924 17.02 0 24.585 8.742 24.585 23.39v7.56c-3.31-.71-10.164-1.184-14.42-1.184-36.404 0-54.842 12.757-54.842 39.454 0 23.86 14.656 35.908 36.876 35.908 14.97 0 29.314-6.852 34.278-17.954l3.782 15.118h14.657v-79.14c0-25.04-10.874-41.815-41.84-41.815zM995.368 233.277c-7.802 0-14.657-.945-19.858-3.308v-71.58c7.093-5.908 15.84-10.16 26.95-10.16 20.092 0 27.893 14.174 27.893 37.09 0 32.6-12.53 47.957-34.985 47.957m8.742-105.364c-18.592 0-28.6 12.64-28.6 12.64V120.59l-.066-26.458H955.116l.066 150.957c10.164 4.25 24.11 6.613 39.24 6.613 38.768 0 57.442-24.804 57.442-67.564 0-33.783-17.26-56.227-47.754-56.227M538.238 110.904c18.438 0 30.258 6.142 38.06 12.285l8.938-15.477c-12.184-10.678-28.573-16.417-46.053-16.417-44.204 0-75.17 26.932-75.17 81.267 0 56.935 33.407 79.14 71.624 79.14 19.148 0 35.46-4.488 46.096-8.976l-.435-60.832V162.76h-56.734v19.135h36.167l.437 46.184c-4.727 2.362-13 4.252-24.11 4.252-30.73 0-51.297-19.32-51.297-60.006 0-41.34 21.275-61.422 52.478-61.422M684.534 94.13h-20.33l.066 25.988v89.771c0 25.04 10.874 41.814 41.84 41.814 4.28 0 8.465-.39 12.53-1.126v-18.245c-2.943.45-6.083.707-9.455.707-17.02 0-24.585-8.74-24.585-23.387v-61.895h34.04v-17.01H684.6l-.066-36.617zM612.62 248.87h20.33V130.747h-20.33v118.12zM612.62 114.448h20.33V94.13h-20.33v20.318z"></path> </g> <path d="M185.398 341.13l68.013-209.322H117.39L185.4 341.13z" fill="#E24329" class="logo-svg-shape logo-dark-orange-shape"></path> <path d="M185.398 341.13l-68.013-209.322h-95.32L185.4 341.128z" fill="#FC6D26" class="logo-svg-shape logo-orange-shape"></path> <path d="M22.066 131.808l-20.67 63.61c-1.884 5.803.18 12.16 5.117 15.744L185.398 341.13 22.066 131.807z" fill="#FCA326" class="logo-svg-shape logo-light-orange-shape"></path> <path d="M22.066 131.808h95.32L76.42 5.735c-2.107-6.487-11.284-6.487-13.39 0L22.065 131.808z" fill="#E24329" class="logo-svg-shape logo-dark-orange-shape"></path> <path d="M185.398 341.13l68.013-209.322h95.32L185.4 341.128z" fill="#FC6D26" class="logo-svg-shape logo-orange-shape"></path> <path d="M348.73 131.808l20.67 63.61c1.884 5.803-.18 12.16-5.117 15.744L185.398 341.13 348.73 131.807z" fill="#FCA326" class="logo-svg-shape logo-light-orange-shape"></path> <path d="M348.73 131.808h-95.32L294.376 5.735c2.108-6.487 11.285-6.487 13.392 0l40.963 126.073z" fill="#E24329" class="logo-svg-shape logo-dark-orange-shape"></path> </g> </svg>

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