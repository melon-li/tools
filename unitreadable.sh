#!/bin/bash

#@param: value
#@param: unit: B KB MB GB
function unit_readable(){
    units=('B' 'KB' 'MB' 'GB' 'TB')
    cnt=0
    for unit in `echo ${units[*]}`
    do
        if [ "$2" == "$unit" ];then
            break
        fi
        cnt=$(($cnt + 1))
    done
    
    if [ $cnt -eq 4 ];then
        echo $1$2
        exit 0
    fi

    if [ $1 -le 1024 ];then
        echo $1$2
    elif [ $1 -le `echo "1024*1024" | bc` -a $cnt -le 3 ];then
        cnt=$(($cnt+1))
        str=`echo "scale=2;$1/1024" |bc`
        str=$str${units[$cnt]}
        echo $str
    elif [ $1 -le `echo "1024*1024*1024" | bc` -a $cnt -le 2 ];then
        cnt=$(($cnt+2))
        str=`echo "scale=2;$1/1024/1024" |bc`
        str=$str${units[$cnt]}
        echo $str
    elif [ $cnt -le 1 ];then 
        cnt=$(($cnt+3))
        str=`echo "scale=2;$1/1024/1024/1024" |bc`
        str=$str${units[$cnt]}
        echo $str
    else
        echo  $1$2
    fi
}

unit_readable 2048 B
