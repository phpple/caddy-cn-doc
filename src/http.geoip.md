---
date: 2018-09-19 01:36:54 +0800
title: "http.geoip"
sitename: "Caddy中文文档"
---

# http.geoip

geoip插件允许基于[MaxMind](https://www.maxmind.com/)数据库通过IP地址确定用户的地理位置。

[完整文档](https://github.com/kodnaplakal/caddy-geoip/blob/master/README.md)

## 示例

__代理将头信息传递到后端__

```caddy
localhost
geoip /path/to/db/GeoLite2-City.mmdb
proxy / localhost:3000 {
  header_upstream Country-Name {geoip_country_name}
  header_upstream Country-Code {geoip_country_code}
  header_upstream Country-Eu {geoip_country_eu}
  header_upstream City-Name {geoip_city_name}
  header_upstream Latitude {geoip_latitude}
  header_upstream Longitude {geoip_longitude}
  header_upstream Time-Zone {geoip_time_zone}
}
```
这将传递国家名称/国家代码等相关头信息到后台，你必须通过`r.Header.Get("Country-Name")`或其他与你后台语言/框架相关的方式获取。
