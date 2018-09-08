---
title: "http.git"
sitename: "Caddy中文文档"
---

# http.git

`git`插件是的可以部署一个支持git push的站点。

> Caddy默认不支持此功能。如果需要，[下载](https://dengxiaolong.com/caddy/doc/download.html)之前需要勾选上`http.cors`插件。

`git`指令在服务生命周期开启一个服务例程。当服务启动后，开始克隆git仓库。服务运行期间，它将经常拉取最新的内容。你可以设置一个`webhook`在推送后立刻拉取。以常规的git方式，拉取只包含变化的内容，所以效率通常很高。


[完整文档](https://github.com/abiosoft/caddy-git/blob/master/README.md)

## 示例

### 基本语法

```caddy
git repo [path]
```

`repo`表示仓库的网址；支持`SSH`和`HTTPS`两种协议。

`path`表示相对于网站根目录的路径，用来克隆仓库，默认就是网站的根目录。

这个简单的语法将每隔1个小时拉取master分支，且只对公开仓库有用。


### 完整语法

```caddy
git [repo path] {
    repo        repo
    path        path
    branch      branch
    key         key
    interval    interval
    clone_args  args
    pull_args   args
    hook        path secret
    hook_type   type
    then        command [args...]
    then_long   command [args...]
}
```

* `repo` 表示仓库的网址；支持`SSH`和`HTTPS`两种协议。

* `path` 存储克隆的仓库的路径，默认就是网站的根目录。可以是绝对路径或者相对路径（相对于网站根目录）。

* `branch` 拉取的分支或者标签；默认是`master`分支。`{latest}`是一个占位符，表示最近的标签，用来确保最近的标签都被拉取过。

* `key` SSH私钥的路径；只有私库才需要。

* `interval` 每次拉取的时间间隔（单位为s）；默认值是3600（1小时），最低可以设置为5。如果设置成-1，表示禁止定期的拉取。

* `clone_args` 调用`git clone`命令时附加的参数。比如"--depth=1"。`git clone`是在来源第一次被拉取时才会调用。

* `pull_args` 调用`git pull`命令时附加的参数。比如"-s recursive -X theirs`。`git pull`是在更新来源时使用。

* `hook` `path`和`secret`是用来创建拉取最新更新后的`webhook`。只仅限于受到支持的webhook。`secret`目前只被Github、Gitlab和Travis的hook所支持。

* `command` 当成功拉取后执行的命令；后面跟随的是传给这个命令的参数。你可以定义多行以运行多个命令。`then_long`是运行时间长的命令，会放入后台执行。

这个块中的每一个属性都是可选的。`path`和`repo`可以在第一行的指令之后定义，也可以在块里边定义。

### 基本示例
```caddy
git github.com/user/myproject subfolder
```
将一个公开仓库拉取到网站根目录下的`subfolder`目录。

### 更多控制
```caddy
git {
    repo     git@github.com:user/myproject
    branch   v1.0
    key      /home/user/.ssh/id_rsa
    path     subfolder
    interval 86400
}
```
每天1次，从私库拉取标签为"v1.0"的私库到`subfolder`目录。

### 拉取后运行一个命令
```caddy
git github.com/user/site {
    path  ../
    then  hugo --destination=/home/user/hugosite/public
}
```
这个例字在每次拉取后将使用`Hugo`创建一个静态站点。

### 定义一个webhook

```caddy
git git@github.com:user/site {
    hook /webhook secret-password
}
```
`/webhook`是路径，而`secret-password`是hook的私钥（如果可用）。webhook被GitHub、 Gitlab、BitBucket、Travis和Gogs支持。

如果私钥名称包含特殊字符，需要用引号包含起来。

### 一般webhook

```json
{
    "ref" : "refs/heads/branch"
}
```
这是一个一般webhook的可能的`payload`。`branch`是分支的名称，如master。

