#!/bin/bash
#calculate total out traffic 
genfile_path=$2

net_dir=$1
if [ ! -d "$net_dir" ];then
    echo "ERROR:net_dir does not exist!"
    echo "Usage: $0 <net_dir> <genfile_path>"
    exit 1
fi

genfile_dir=`dirname $2`
if [ ! -d "$genfile_dir" ];then
    echo "ERROR:genfile_dir does not exist!"
    echo "Usage: $0 <net_dir> <genfile_path>"
    exit 2
fi

str_len=${#net_dir}
pos=$(($str_len - 1))
if [ "${net_dir:pos}" != "/" ];then
    net_dir=$net_dir"/"
fi

echo "# name  total_out_traffic avg_rate" > $genfile_path
if [ $? != 0 ];then
    echo "ERROR: genfile_path does not exist!"
    exit 3
fi

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
        echo $val$2
        exit 0
    fi


    val=$((`echo "$1/1"|bc` + 0)) 
    if [ $val -le 1024 ];then
        echo $val$2
    elif [ $val -le `echo "1024*1024" | bc` -a $cnt -le 3 ];then
        cnt=$(($cnt+1))
        str=`echo "scale=2;$val/1024" |bc`
        str=$str${units[$cnt]}
        echo $str
    elif [ $val -le `echo "1024*1024*1024" | bc` -a $cnt -le 2 ];then
        cnt=$(($cnt+2))
        str=`echo "scale=2;$val/1024/1024" |bc`
        str=$str${units[$cnt]}
        echo $str
    elif [ $cnt -le 1 ];then 
        cnt=$(($cnt+3))
        str=`echo "scale=2;$val/1024/1024/1024" |bc`
        str=$str${units[$cnt]}
        echo $str
    else
        echo  $val$2
    fi
}

t_sum=0
cnt=0
for name in `ls $net_dir`
do
    cnt=$(($cnt + 1))
    file_path=$net_dir$name
    str=`cat $file_path  | awk 'BEGIN{sum=0}{if($1 ~ /^[0-9|.]+$/)sum=sum+$2;}END{print sum, sum/11000}'`
    total=`echo $str | awk '{print $1}'`
    t_sum=`echo "$t_sum+$total" |bc`
    str="$name $str"
    echo "$str" >> $genfile_path
done

avg=`echo "scale=2;$t_sum/$cnt" | bc`
avg_rate=`echo "scale=4;$avg/11000" |bc`
str="$t_sum $avg $avg_rate"
echo "# total_traffic(KB) avg_traffic avg_rate" | tee $genfile_path
echo "$str" | tee $genfile_path

t_sum=`unit_readable $t_sum KB`
avg=`unit_readable $avg KB`

echo "$t_sum $avg $avg_rate""KB/s"
