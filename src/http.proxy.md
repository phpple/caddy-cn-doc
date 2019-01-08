---
date: 2018-09-11 20:39:46 +0800
title: "http.proxy"
sitename: "Caddy中文文档"
---

# http.proxy

proxy保证了基本的反向代理和健壮的负载均衡。代理支持多个后端和添加自定义标头。负载平衡特性包括多个策略、健康检查和failovers。Caddy也可以代理WebSocket连接。

这个中间件添加了一个占位符，可以通过在日志格式中使用`{upstream}`获取到被代理的上游主机的名称。


## 语法

最基本的形式，一个简单的反向代理使用以下语法：

```caddy
proxy from to
```

* __from__ 用来匹配代理请求的基本路径
* __to__ 要代理的目标地址(可能包括端口范围)

然而，高级功能，包括负载平衡，可以利用一个扩展的语法：

```caddy
proxy from to... {
	policy name [value]
	fail_timeout duration
	max_fails integer
	max_conns integer
	try_duration duration
	try_interval duration
	health_check path
	health_check_port port
	health_check_interval interval_duration
	health_check_timeout timeout_duration
	fallback_delay delay_duration
	header_upstream name value
	header_downstream name value
	keepalive number
	timeout duration
	without prefix
	except ignored_paths...
	upstream to
	insecure_skip_verify
	preset
}
```

* __from__是匹配要代理的请求的基本路径。
* __to__ 是要代理的目标地址。至少需要一个，但可以指定多个。如果没有指定模式(http/https/quic/srv)，则使用http。Unix套接字也可以通过前缀“Unix:”来使用。QUIC连接是实验性的，要尝试它只需配置使用“QUIC://”。同时也支持使用SRV查找的服务发现。如果地址以`srv://`或`srv+https://`开头，它将被视为服务定位器，Caddy将尝试通过srv DNS查找来解析可用的服务。
* __policy__ 是要使用的负载平衡策略；只适用于多个后端。可以是random、least_conn、round_robin、first、ip_hash、uri_hash或header中的一个。如果选择header，还必须提供header名称。默认是random的。如果目标地址是服务定位器，则此设置不可用。
* __fail_timeout__ 指定向后端记住失败请求的时间。超时> 0允许请求失败计数，并且在发生故障时需要在后端之间进行负载平衡。如果失败请求的数量累积到`max_failed`值，主机将被认为是挂掉的，知道失败请求被忘记前都不会将请求路由到该主机。默认情况下，这是禁用的(0)，这意味着失败的请求将不会被记住，后端将始终被认为是可用的。必须设置成一个持续时间值(如“10s”或“1m”)。
* __max\_fails__ 表示在禁用对应后端服务前需要的失败请求数。如果`fail_timeout`为0，则不使用。默认值为1。
* __max\_conns__ 是每个后端并发请求的最大数量。0表示没有极限。当达到该限制时，其他请求将因网关错误(502)而失败。默认值为0。
* __try\_duration__ 为每个请求尝试选择可用上游主机的时间。默认情况下，此重试是禁用的(“0”)。当代理试图找到可用的上游主机时，客户机可能会挂起很长时间。此值仅在对初始选择的上游主机的请求失败时使用。
* __try\_interval__ 选择另一个上游主机来处理请求之间的等待时间。默认是250ms。仅当对上游主机的请求失败时才相关。请注意，如果使用非零try_duration将其设置为0，则会导致非常密集地循环，如果所有主机都宕机，则会导致CPU旋转。
* __health\_check__ 将使用`path`检查每个后端的健康状况。如果后端返回200-399的状态码，则认为该后端是健康的。如果没有，则后端被标记为不健康，至少health_check_interval是不健康的，并且没有路由到它的请求。如果未提供此选项，则禁用健康检查。
* __health\_check\_port__ 将使用端口执行健康检查，而不是为上游提供的端口。如果您将内部端口用于调试目的，而您的健康检查端点对公共视图是隐藏的，那么这将非常有用。当目的地是服务定位器时，不支持此设置。
* __health\_check\_interval__ 指定不健康后端上每个健康检查之间的时间。默认间隔是30秒(“30s”)。
* __health\_check\_timeout__ 设置健康检查请求的最后期限。如果健康检查在health_check_timeout内没有响应，则认为健康检查失败。默认值是60秒(“60s”)。
* __fallback\_delay__ 设置双堆栈回退尝试之间的持续时间。默认300 ms。
* __header\_upstream__ 设置要传递到后端的标题。字段名是name，值是value。可以多次为多个标题指定此选项，还可以使用[请求占位符](placeholders.md)插入动态值。默认情况下，现有的头字段将被替换，但是你可以通过在字段名称前面加上加号(+)来添加/合并字段值。你可以通过在标题名称前加上减号(-)并将值留空来删除字段。
* __header\_downstream__ 修改从后端返回的响应头。它的工作方式与header_upstream相同。
* __keepalive__ 是保持对后端打开的空闲连接的最大数量。默认启用；设置为0禁用keepalives。对于负载高的服务器，需要设置为更高的值。
* __timeout__ 为上游连接超时前的持续时间;默认是30秒。
* __without__ 是在上游代理请求之前要去掉的URL前缀。例如，对/api/foo`without /api`的请求将导致对/foo的代理请求。
* __except__ 是要从代理中排除的路径列表，以空格分隔。匹配忽略路径的请求将不经过代理被直接访问。
* __upstream__ 指定另一个后端。如果需要，它可以使用“:8080-8085”这样的端口范围。当有许多后端要路由到时，通常会多次使用它。如果to指定的后端目标是服务定位器，则不支持此子指令。
* __insecure\_skip\_verify__ 覆盖后端TLS证书的验证，基本上禁用HTTPS上的安全特性。
* __preset__ 是配置代理以满足某些条件的一种可选的简写方式。请参阅下面的预设。

第一个to之后的所有内容都是可选的，包括由花括号括起来的属性块。

## 预设

有下面一些可用的预设：

* __websocket__

	指示此代理正在转发WebSocket连接。相当于：

	```caddy
	header_upstream Connection {>Connection}
	header_upstream Upgrade {>Upgrade}
	```

* __transparent__

	正如大多数后端应用程序所期望的那样，通过原始请求中的主机信息进行传递。相当于：

	```caddy
	header_upstream Host {host}
	header_upstream X-Real-IP {remote}
	header_upstream X-Forwarded-For {remote}
	header_upstream X-Forwarded-Proto {scheme}
	```

## 策略

有几种负载平衡策略可用：

* __random__(default) - 随机选择一个后端地址
* __least\_conn__ - 选择活动连接最少的后端
* __round\_robin__ - 以循环方式选择后端
* __first__ - 按照在Caddyfile中定义的顺序选择第一个可用后端
* __ip\_hash__ - 通过散列请求IP选择后端，根据后端总数在散列空间中均匀分布
* __uri\_hash__ - 通过散列请求URI选择后端，根据后端总数在散列空间中均匀分布
* __header__ - 通过散列指定头的值(由策略名后面的[value]指定)进行选择，根据后端总数在散列空间中均匀分布

## 示例

将/api中的所有请求代理到后端系统：

```caddy
proxy /api localhost:9005
```

使用随机策略访问三个后端之间的所有请求：

```caddy
proxy / web1.local:80 web2.local:90 web3.local:100
```

同上，不过使用header策略：

```caddy
proxy / web1.local:80 web2.local:90 web3.local:100 {
	policy header X-My-Header
}
```

round-robin策略：

```caddy
proxy / web1.local:80 web2.local:90 web3.local:100 {
	policy round_robin
}
```

通过健康检查和代理头文件来传递主机名、IP和预设”transparent“：

```caddy
proxy / web1.local:80 web2.local:90 web3.local:100 {
	policy round_robin
	health_check /health
	transparent
}
```

代理websocket连接：

```caddy
proxy /stream localhost:8080 {
	websocket
}
```

代理除请求/static或/robots.txt的所有请求：

```caddy
proxy / backend:1234 {
	except /static /robots.txt
}
```

代理到后端与HTTPS在标准HTTPS端口：

```caddy
proxy / https://backend
```






