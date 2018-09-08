#! /bin/bash
pwd

if [[ "$(pwd)" =~ "/repo" ]];then
    cd ../
fi

pwd
source ./env

function handlemd() {
    file=$1

    # 充命名
    newfile=${file/.md/.html}
    cp $file $newfile
}

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
for md in $(find $destdir -type f -name *.md)
do
    handlemd $md
done

find $destdir -type f|xargs sed -i '' -E "s@.md(\"|\))@.html\1@g"
