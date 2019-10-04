---
date: 2018-12-07 22:40:10 +0800
title: "Flask基于Fastcgi协议的Caddy配置"
sitename: "Caddy配置示例"
template: "example"
---

# Flask基于Fastcgi协议的Caddy配置

Flask ♥️ Caddy

本示例配置文件用来通过Caddy的[fastcgi](http.fastcgi.md)指令提供对[Flask](http://flask.pocoo.org/)的访问。


## 如何运行

1. 安装如下必须项：

    ```bash
    pip3 install -r requirements.txt
    ```

2. 运行迷你Flask服务器

    ```bash
    python3 app.py
    ```

3. 通过localhost:9000访问Flask。

## Caddyfile

```caddy
localhost:9000
fastcgi / unix:hello-world.sock
```

## app.py

```python
import sys
import os
import logging

from flup.server.fcgi import WSGIServer
from flask import Flask
app = Flask(__name__)

@app.route('/')
def hello_world():
    return 'Hello, World!'

def main(app):
    try:
        WSGIServer(app, bindAddress='./hello-world.sock', umask=0000).run()
    except (KeyboardInterrupt, SystemExit, SystemError):
        logging.info("Shutdown requested...exiting")
    except Exception:
        traceback.print_exc(file=sys.stdout)


if __name__ == '__main__':
    main(app)
```

## requirements.txt

```plain
Flask==1.0.2
flup-py3==1.0.3
```