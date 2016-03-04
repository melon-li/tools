#!/bin/bash
num=`cat /proc/stat | grep cpu | grep grep -v| grep color -v| wc -l`
cpunum=`echo "$num -1"|bc`
maxseq=`echo "$cpunum -1" |bc`
names="cpu\t"
for i in `seq 0 $maxseq`
do
    name="cpu"$i    
    names="$names$name\t"
done

sleep_time=$1
if [ "$sleep_time" == "" ];then
    sleep_time=2
fi

function cpuusage(){
    cpuinfo_user=()
    cpuinfo_sys=()
    cpuinfo_idle=()

    user_total=`cat /proc/stat | grep "cpu " | grep color -v | grep grep -v| awk -F" " '{print $2}'`
    sys_total=`cat /proc/stat | grep "cpu " | grep color -v | grep grep -v| awk -F" " '{print $4}'`
    idle_total=`cat /proc/stat | grep "cpu " | grep color -v | grep grep -v| awk -F" " '{print $5}'`
    for i in `seq 0 $maxseq`
    do
        name="cpu"$i    
        names="$names$name\t"
        cpuinfo_user[$i]=`cat /proc/stat | grep $name | grep color -v | grep grep -v| awk -F" " '{print $2}'`
        cpuinfo_sys[$i]=`cat /proc/stat | grep $name | grep color -v | grep grep -v| awk -F" " '{print $4}'`
        cpuinfo_idle[$i]=`cat /proc/stat | grep $name | grep color -v | grep grep -v| awk -F" " '{print $5}'`
    done
    
    sleep $sleep_time
    user_total_new=`cat /proc/stat | grep "cpu " | grep color -v | grep grep -v| awk -F" " '{print $2}'`
    sys_total_new=`cat /proc/stat | grep "cpu " | grep color -v | grep grep -v| awk -F" " '{print $4}'`
    idle_total_new=`cat /proc/stat | grep "cpu " | grep color -v | grep grep -v| awk -F" " '{print $5}'`
    str=`echo "scale=2;($user_total_new + $sys_total_new - $user_total - $sys_total)*100/($user_total_new + $sys_total_new + $idle_total_new - $user_total - $sys_total - $idle_total)" |bc`"\t"
    for i in `seq 0 $maxseq`
    do
        name="cpu$i"
        user=`cat /proc/stat | grep $name | grep color -v | grep grep -v| awk -F" " '{print $2}'`
        sys=`cat /proc/stat | grep $name | grep color -v | grep grep -v| awk -F" " '{print $4}'`
        idle=`cat /proc/stat | grep $name | grep color -v | grep grep -v| awk -F" " '{print $5}'`
        str=$str`echo "scale=2;($user+$sys-${cpuinfo_sys[$i]} -${cpuinfo_user[$i]})*100/($user+$sys+$idle-${cpuinfo_user[$i]}-${cpuinfo_sys[$i]}-${cpuinfo_idle[$i]})" |bc`"\t"
    #    echo ${cpuinfo[$i]} | awk -F" " 'BEGIN{user=0;sys=0;idle=0}{user=$2-$user;sys=$4-sys;idle=$5-idle}END{print user}'
    done
    echo -e $str
}

echo -e $names| tee cpuusage.txt
while [ 1 ]
do
    cpuusage | tee -a cpuusage.txt
done
