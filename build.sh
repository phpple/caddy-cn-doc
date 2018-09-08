#! /bin/bash

function output() {
    msg=$1
    echo [$(date +"%Y/%m/%d %H:%I:%S")] $msg >&2
}

output "开始构建"

output "当前位置：$pwd"
if [[ "$(pwd)" =~ "/repo" ]];then
    cd ../
    output "切换到：$pwd"
fi

source ./env

# 根据环境来设置拷贝来源
destdir="dist"
cpdir="repo/src"
if [ "$ENVNAME" = "development" ];then
    cpdir="src"
fi

if [ -d $destdir ];then
    rm -rf $destdir
fi
mkdir $destdir
cp -rf $cpdir/* $destdir

# 开始替换
output "修改md后缀为html"
for file in $(find $destdir -type f -name *.md)
do
    cp $file ${file/.md/.html}
done

# 替换后缀
output "修改url后缀为html"
if [ $ISMAC = 1 ];then
    find $destdir -type f|xargs sed -i '' -E "s@.md(\"|\))@.html\1@g"
else
    find $destdir -type f|xargs sed -i -E "s@.md(\"|\))@.html\1@g"
fi

output "构建成功"
