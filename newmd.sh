#! /bin/bash

if [ $# -lt 2 ];then
    echo "usage: ./newmd.sh [name] [title]"
    exit 1
fi

name=$1
title=$2
sitename="Caddy中文文档"
template=""

if [[ "$name" =~ "wiki." ]];then
    sitename="Caddy开发者wiki"
    template="wiki"
fi
if [[ "$name" =~ "example." ]];then
    sitename="Caddy配置示例"
    template="example"
fi

touch src/$name.md

now=$(date +"%Y-%m-%d %H:%M:%S +0800")

if [ "$template" = "" ];then
    cat > src/$name.md <<MARKDOWN
---
date: $now
title: "$title"
sitename: "$sitename"
---

# $title

MARKDOWN

else
    cat > src/$name.md <<MARKDOWN
---
date: $now
title: "$title"
sitename: "$sitename"
template: "$template"
---

# $title

MARKDOWN

fi

echo "create markdown file src/$name.md finished."
exit 0
