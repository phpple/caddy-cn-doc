---
date: 2018-10-09 17:44:24 +0800
title: "在Android运行Caddy"
sitename: "Caddy开发者wiki"
template: "wiki"
---

# 在Android运行Caddy

_<small>英文原文：<https://github.com/mholt/caddy/wiki/Running-Caddy-on-Android></small>_

----------------------------

到目前为止，在Android上运行Caddy有两种确定的方式：`Termux`和`adb`。(如果你有其他方法，请添加你的说明！)如果你你在路由器设置了端口转发，你应该能够直接从你的手机或平板电脑上提供即时服务。很酷!

## 使用[Termux](https://termux.com/)（不要求root）

### 方法1：getcaddy.com

这是最简单的方法。确保已安装curl(`apt install curl`)，然后：

```bash
curl https://getcaddy.com | bash
```

你可以使用`-s`获取Caddy以及相应的插件：

```bash
curl https://getcaddy.com | bash -s http.ipfilter,http.jwt
```

在提交命令后，需要等待约一分钟开始执行。

然后运行`caddy`启动服务。

### 方法2：从源代码构建

这个方法从直接在你的设备上从源码下载下载并构建Caddy。

将这些命令放入bash脚本中并运行它。当然，你可以根据需要对其进行定制。例如，你可以用可用[包列表](https://github.com/termux/termux-packages/tree/master/packages)中的任何其他编辑器替换nano。

```go
apt install git gcc golang nano
export GOPATH=~/dev
export CGO_ENABLED=0
export PATH=$PATH:$GOPATH/bin
go get github.com/mholt/caddy
```

注意，构建步骤可能需要两到三分钟，这取决于你的设备。在Nexus 9上大约需要一分钟。

设置好`GOPATH`，且把`$GOPATH/bin`加入到`PATH`变量，你已经完成了运行Caddy的准备：

```bash
$ caddy
```

如果你想用cgo构建Caddy，追加选项`-buildmode=archive`。

## 使用adb进行侧载(Side-loading)(不需要root)

### 方法1：为Linux ARM编译

Caddy可用于Linux ARM，这意味着它可以在大多数较新的Android设备上运行。

#### 需求
* Android与ARM架构
* adb (Android SDK的一部分；如果你有Android Studio，你已经有adb了。
* [ARM Linux版](https://caddyserver.com/download)的Caddy

#### 基本指令

假设ARM二进制文件被称为caddy，运行：
```bash
$ adb push caddy /data/local/tmp
$ adb shell "cd /data/local/tmp; chmod 755 caddy; ./caddy"
```

你可能还想通过Caddyfile来定制Caddy的运行方式。

### 方法2：使用`gomobile`编译

> 注意：这个方法不完整，还没有做任何有用的事情。只是我修补的一些笔记。

#### 需求
* 安装[gomobile](https://godoc.org/golang.org/x/mobile)(然后运行`gomobile init`)
* 出于某种原因，在编写本文时，如果你使用的是Mac(即使你只是在编译Android)，那么还需要安装XCode
* 在main.go导入`golang.org/x/mobile/app`，然后将`main()`函数修改为：

```go
func main() {
    app.Main(func(a app.App) {
        run()
    })
}
```
* 在caddy/caddy文件夹(`main`所在目录)创建一个名为`AndroidManifest.xml`，添加这个权限：`<uses-permission android:name="android.permission.INTERNET" />`。例如：

```xml
<?xml version="1.0" encoding="utf-8"?>
<manifest
    xmlns:android="http://schemas.android.com/apk/res/android"
    package="org.golang.todo.caddy"
    android:versionCode="1"
    android:versionName="1.0">

    <uses-permission android:name="android.permission.INTERNET" />

    <application
        android:label="Caddy"
        android:debuggable="true"
        android:label="@string/app_name">
    <activity android:name="org.golang.app.GoNativeActivity"
        android:label="Caddy"
        android:configChanges="orientation|keyboardHidden">
        <meta-data android:name="android.app.lib_name" android:value="caddy" />
        <intent-filter>
            <action android:name="android.intent.action.MAIN" />
            <category android:name="android.intent.category.LAUNCHER" />
        </intent-filter>
    </activity>
    </application>
</manifest>
```

运行`gomobile install -target android github.com/mholt/caddy/caddy`。如果你的手机接入了开发者USB调试，Caddy会作为一个本地应用程序安装到你的手机上。通过运行这个应用程序，Caddy可以在端口2015上提供当前的目录，但是http状态码是403 Forbidden。这是没有用的，需要做一些工作来给它一个实际的Caddyfile。但这只是一个开始。(大家说对吗？)


