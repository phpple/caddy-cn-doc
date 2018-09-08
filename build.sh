#! /bin/bash
pwd
cd ../
pwd
function handlemd() {
    file=$1

    # 充命名
    newfile=${file/.md/.html}
    cp $file $newfile
}

destdir="dist"
if [ -d $destdir ];then
    rm -rf $destdir
fi
mkdir $destdir
cp -rf repo/src/* $destdir

# 开始替换
for md in $(find $destdir -type f -name *.md)
do
    handlemd $md
done

find $destdir -type f|xargs sed -i '' -E "s@.md(\"|\))@.html\1@g"
