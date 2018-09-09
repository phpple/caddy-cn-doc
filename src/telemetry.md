---
date: 2018-09-09 18:17:58 +0800 
title: "遥测"
sitename: "Caddy中文文档"
---

# 遥测

Caddy遥测项目的首要目标是从服务端角度，从全局和准实时的角度，深入了解网络的状态和健康情况，而不受限于特定的网络或专有资源。第二个目标是向服务器运维人员提供关于服务器及其与客户端的交互的信息。

## 话题

1. [遥测的益处](#遥测的益处)
2. [实现](#实现)
3. [指标](#指标)
4. [禁用遥测](#禁用遥测)


## 遥测的益处

__站点拥有者__：遥测数据使操作员能够对他们的web服务器有一个直观的(白盒的)理解。当异常发生时，传统的监控工具通常需要进行冗长的分析，因为它们对过程只有一个外部视角。另一方面，Caddy遥测技术可以在过程中进行操作，当你需要答案时，它可以提供详细的分析。当一切都是名义上的时候，看看你的web服务器是如何工作的也很有趣。遥测是除了日志之外非常有用的技术，因为它提供了关于客户端对服务器的影响的独特数据点。

__研究人员__：尽管对互联网的客户端扫描并不少见，但现在你第一次可以使用全局的、服务器端视角来观察网络的行为和健康状况。Caddy遥测是唯一定位在于提供匿名的网络客户端的聚合数据，并结了web服务器应答的内部视图。我们的长期的目标是，有了您的参与和反馈，我们可以构建实时检测新兴僵尸网络、DDoS攻击和其他威胁的方法，并能够自动减轻这些威胁。

__行业专家__：Caddy遥测技术提供的信息在决定新的Web标准、构建或监视网络基础设施以及开互联网软件时肯定是有用的。

## 实现
当遥测启用后，Caddy在运行时将记录各种数据并在后台记录某些事件。它定期向收集器节点发送更新，刷新数据的本地缓冲区。

遥测技术的实现方式对你的流程不会产生干扰，而且是无阻塞的。您的Caddy实例不应该受到任何明显的性能影响。它有一些内置的安全措施来确保最佳的性能，即使是以牺牲数据为代价，包括对可缓冲的数据点数量的限制。收集节点可能会注意到某些指标过于昂贵，则会在每个实例的基础上临时禁用它们以提高性能。收集节点还可以完全终止来自任何实例的遥测报告。此外，收集更新的速度受到严格限制，确保遥测不会干扰网络吞吐量。

每个Caddy实例都生成自己唯一的、随机的ID，称为UUID。它存储在一个名`·$CADDYPATH/uuid`的文件中(默认的CADDYPATH是`$HOME/.caddy`)。这个UUID不以任何方式与收集节点连接生成，也不与任何个人关联。我们建议您运行的每个Caddy实例都有自己的CADDYPATH，这样在你的报告中查找实例将更容易识别。

如你所料，所有传输都使用HTTPS加密。

## 指标

这个表格列出了Caddy的核心和标准插件收集的指标，它们按字母顺序排序；但是请记住，第三方插件可能会添加它们自己的指标，并没有记录在这里，可以通过他们的文档加以了解。

| 指标名称 | 描述                                      |
|---------|-----------------------------------------|
| arch | 编译的微体系架构 |
| caddy_version | Caddy版本 |
| container | 进程是否在容器中运行 |
| cpu.aes_ni | AES-NI是否可用 |
| cpu.brand_name | CPU的品牌名 |
| cpu.num_logical | 逻辑核数 |
| directives | 使用的指令列表(仅指令名) |
| disabled_metrics | 已禁用的单个指标的列表 |
| goroutines | 目前正在运行的goroutines数量 |
| http_deployment_guess | 大致猜测它看起来像开发实例还是生产实例 |
| http_mitm | 是否检测到MITM的次数 |
| http_num_sites | HTTP Caddyfile中网站数量（∑ 块数 * 每个块的key数量） |
| http_request_count | 处理的HTTP(s)请求数量 |
| http_user_agent | 所有User-Agent请求头的值 |
| http_user_agent_count | 带有关联的User-Agent字符串的请求数 |
| memory.heap_alloc | 分配堆对象的字节(可访问的，或不可访问但尚未释放的) |
| memory.sys | 从操作系统获得的内存大小（单位为byte） |
| instance_id | 实例的UUID |
| num_listeners | 打开的监听器数量 |
| num_server_blocks | Caddyfile中定义的服务器块的数量 |
| os | 编译的操作系统 |
| server_type | 正在运行的服务器类型(HTTP、DNS等) |
| sigtrap | 被捕获的信号(或中断)的名称和计数 |
| timestamp | 遥测更新的时间戳 |
| tls_acme_certs_obtained | 使用ACME自动获得的证书数量 |
| tls_acme_certs_renewed | 使用ACME自动更新的证书数量 |
| tls_acme_certs_revoked | 使用ACME撤消的证书数量|
| tls_client_hello.cipher_suites | TLS ClientHello标定的密码套件 |
| tls_client_hello.compression | TLS ClientHello标定的压缩方法 |
| tls_client_hello.curves | TLS ClientHello标定的Curves |
| tls_client_hello.extensions | TLS ClientHello标定的扩展 |
| tls_client_hello.points | TLS ClientHello标定的Points |
| tls_client_hello.version | TLS ClientHello标定的版本 |
| tls_client_hello_ua | 使用与相关TLS ClientHello连接的给定的User-Agent值的HTTPS请求数量 |
| tls_handshake_count | 完成TLS握手次数|
| tls_managed_cert_count | 管理证书的数量 |
| tls_manual_cert_count | 手动提供证书的数量 |
| tls_on_demand_count | 通过[按需TLS](automatic-https.md#on-demand)配置的站点数量 |
| tls_self_signed_count | 使用集成自签名证书配置的站点数量 |

## 禁用遥测

遥测在源代码中默认启用，在下载页面中默认禁用。为了更好地了解聚合数据的代表性，遥测可以在编译时进行切换，也可以在运行时进行定制。

请注意，遥测不针对个人信息。遥测程序只报告关于机器、连接和Caddy实例的技术数据；不是终端用户、会话id、cookie等等。如果你因为适用的法律而考虑关闭遥测，确认一下这些法律是否真的适合于你。

禁用遥测的推荐的方法是只关闭你不想报告的指标。您可以使用`-disable-metrics`的[命令行参数](cli.md#disabled-metrics)来予以实现。(disabled_metrics、timestamp和instance_id指标不能单独禁用。)这将阻止Caddy收集整个生命周期过程中的指定信息,这个参数是，比如你发现一个特定的指标在负载较重的情况下很快导致你的遥测缓冲区填满(多少项可以被发送到缓冲是有限制的)。

但是，如果您希望完全禁用遥测，可以在编译时完成。当您从网站下载Caddy，您可以选择禁用遥测。如果从源代码构建，您将`enableTelemetry`设置为false就可以关闭这个功能。请注意，如果禁用遥测，您将无法查找实例并查看其指标。于此同时，这将导致没有可能对其研究工作做出贡献，它使诊断问题和改进Caddy变得困难。我们建议保留遥测技术，以获得它的益处，并全面改进Web。

