---
title: "Caddy中文文档"
sitename: "Caddy中文文档"
---

# Caddy中文文档

## 参考手册
这部分文档介绍了如何使用和配置Caddy。如果你是一个Caddy新手，可以尝试阅读[开始启动](tutorial.md)。当你了解如何运行Caddy了，可以查阅[Caddyfile](caddyfile.md)配置你的站点。

## [教程](tutorial.md)
开始使用Caddy，了解如何安装、运行和修改配置。

## [示例](https://github.com/caddyserver/examples)
浏览我们提供的一些常用的简单的Caddyfile例子，了解Caddy的一些常见使用方式。

<center>
## 专家推荐

Caddy因其安全默认值和无与伦比的可用性而受到研究人员和行业专家的赞扬。

</center>

<div class="row">
    <div class="col-sm-4">
        <h3>USENIX 2017</h3>
        <blockquote>
            "TLS must be enabled by default ... and the Caddy web server is a good and usable example..."
        </blockquote>
        <a href="https://www.usenix.org/conference/usenixsecurity17/technical-sessions/presentation/krombholz"><img src="https://caddyserver.com/resources/images/usenix-2017-paper.png" style="width:12rem"/></a>
    </div>
    <div class="col-sm-4">
        <h3>NY LUG 2016</h3>
        <blockquote>"Caddy is impressive. This is what we want, setting up a secure website."</blockquote>
        <div class="text-right">
            <small><i>-—Josh Aas</i></small><br/>
            <small><i>Executive Director, ISRG</i></small>
        </div>
        <a href="https://www.youtube.com/watch?v=OE5UhQGg_Fo" ><img src="https://caddyserver.com/resources/images/josh-aas-demos-caddy.png" width="200" style="width:12rem;margin-top:3rem;"/></a>
    </div>
    <div class="col-sm-4">
        <h3>ACM IMC 2016</h3>
        <blockquote>
            "No popular server software does [session ticket key rotation], with the exception of the most recent release of Caddy."
        </blockquote>

        <a href="https://dl.acm.org/citation.cfm?id=2987480"><img src="https://caddyserver.com/resources/images/acm-imc-2016-paper.png" width="200"/></a>
    </div>
</div>

<center>
    <h2>如何使用Caddy</h2>
</center>

<div class="row">
    <div class="col-sm-6">
        <h3>1. 制作Caddyfile</h3>
<p>Caddyfile是一个配置Caddy的文本文件。它被设计成易于打字，不易出错。</p>

<p>Caddyfile的第一行始终是要服务的站点的地址。</p>

<p>你可以定义任意多的站点；Caddy支持虚拟主机和许多其他功能！</p>
    </div>
    <div class="col-sm-6">
        <pre><code class="language-caddy">matt.life   # 你的站点地址

ext .html   # 美化网址
errors error.log {       # 错误日志
    404 error-404.html   # 自定义错误页面
}

# PHP后端
fastcgi /blog localhost:9000 php

# API负载均衡
proxy /api localhost:5001 localhost:5002
</code></pre>
    </div>
</div>

<div class="row">
    <div class="col-sm-6">
        <h3>2. 运行Caddy</h3>
        <p>瞧！你所要做的就是运行<code>caddy</code>。如果你的Caddyfile在同一个文件夹中，它会被自动加载。对于生产站点，<code>HTTPS</code>是<a href="automatic-https.md">默认开启</a>的！</p>
    </div>
    <div class="col-sm-6">
        <pre><code class="language-bash">$ caddy
Activating privacy features... done.
http://matt.life
https://matt.life</code></pre>
        <div style="animation: blink 1s step-start 0s infinite;">_</div>
    </div>
</div>

<div class="row">
    <div class="col-sm-6">
        <h3>打开浏览器</h3>
        <p>
            输入你的站点地址，查看它的运行情况。在线站点被重定向到HTTPS。
        </p>
        <p>
            Caddy非常适合在家里或工作时开发网站，并服务于生产环境。赶紧尝试一下！
        </p>
    </div>
    <div class="col-sm-6">
        <img src="https://caddyserver.com/resources/images/open-your-browser.png" style="width:20rem;">
    </div>
</div>

<div class="row">
    <div class="col-sm-2">
        <a href="https://caddyserver.com/download" class="btn btn-lg btn-info">下载Caddy</a>
    </div>
    <div class="col-sm-2">
        <a href="https://caddyserver.com/features" class="btn btn-lg btn-info">特性</a>
    </div>
</div>
<br>


