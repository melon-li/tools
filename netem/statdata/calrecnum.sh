#!/bin/bash
#calucalate received message number
#if size is the specified size, received

data_path=$1
if [ ! -f "$data_path" ];then
    echo "Usage: $0 <data_path>"
    exit 1
fi


cat $data_path | awk -F" " 'BEGIN{cnt=0}{if($1!="#"){if($2==1024)cnt++}}END{print cnt}'
