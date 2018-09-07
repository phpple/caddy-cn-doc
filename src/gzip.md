---
title: "gzip"
sitename: "Caddy中文文档"
---

# gzip

`gzip`在客户端支持的情况下将启用gzip支持。默认情况下响应内容没有被gzip压缩。如果启用，默认配置将保证图片、视频、档案文件（已经被压缩）不会被压缩。


注意到，即使没有使用`gzip`指令，Caddy也支持.gz(gzip)或者.br(brotli)压缩文件，只要客户端支持这种编码。


## 语法

```caddy
gzip
```

大多数时候保持空白的`gzip`配置就够了，但是如果你需要也可以做更多的控制：

```caddy
gzip {
    ext        extensions...
    not        paths
    level      compression_level
    min_length min_bytes
}
```

* __extensions...__ 表示需要被压缩的文件后缀，多个后缀用用空格隔开。支持用通配符"*"表示所有后缀。

* __paths__ 表示哪些路径不需要被压缩，多个路径用空格隔开。

* __compression_level__ 压缩级别，可以是从1（速度最快）到9（压缩率最高）的数字。默认为6。

* __min_bytes__ 响应内容开始压缩的最小字节数。默认值没有最小长度。
 
## 示例

* 启用gzip压缩

```caddy
gzip
```

* 除了`/images`和`/videos`均启用最快但是最小压缩率（注意，图片和视频不论如何都不会被压缩）

```caddy
gzip {
    level 1
    not   /images /videos
}
```

