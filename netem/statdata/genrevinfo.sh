#!/bin/bash
#name size  create_time reach_time 
genfile_path=$2

rec_dir=$1
if [ ! -d "$rec_dir" ];then
    echo "ERROR:rec_dir does not exist!"
    echo "Usage: $0 <rec_dir> <genfile_path>"
    exit 1
fi

genfile_dir=`dirname $2`
if [ ! -d "$genfile_dir" ];then
    echo "ERROR:genfile_dir does not exist!"
    echo "Usage: $0 <rec_dir> <genfile_path>"
    exit 2
fi

str_len=${#rec_dir}
pos=$(($str_len - 1))
if [ "${rec_dir:pos}" != "/" ];then
    rec_dir=$rec_dir"/"
fi

echo "# name size  create_time reach_time" > $genfile_path
if [ $? != 0 ];then
    echo "ERROR: genfile_path does not exist!"
    exit 3
fi

for name in `ls $rec_dir`
do
    file_path=$rec_dir$name
    str=`stat -t $file_path  | awk -F" " '{print $2" "$12" "$13}'`
    str="$name $str"
    echo "$str" >> $genfile_path
done
