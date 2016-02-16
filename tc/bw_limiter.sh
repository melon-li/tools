#!/bin/bash
# arg1=start, arg2=end, format: %s.%N  
function getTiming() {
    start=$1
    end=$2

    start_s=$(echo $start | cut -d '.' -f 1)
    start_ns=$(echo $start | cut -d '.' -f 2)
    end_s=$(echo $end | cut -d '.' -f 1)
    end_ns=$(echo $end | cut -d '.' -f 2)


# for debug..  
#    echo $start  
#    echo $end  


    time=$(( ( 10#$end_s - 10#$start_s ) * 1000 + ( 10#$end_ns / 1000000 - 10#$start_ns / 1000000 ) ))


    echo "$time"  #ms
}

function test_time(){
    end=$((1+$1))
    tc qdisc delete dev eth3 root
    start=`date +%s.%N`
    tc qdisc add dev eth3 root handle 1: htb default 30
    tc class add dev eth3 parent 1: classid 1:1 htb rate 1000mbps ceil 1000mbps
    for i in `seq 2 1 $end`
    do
        tc class add dev eth3 parent 1:1 classid "1:$i" htb rate 10kbps ceil 10kbps
        tc filter add dev eth3 parent 1: protocol ip prio 1 u32 match ip dst "192.168.99.1/32" flowid "1:$i"
        tc qdisc add dev eth3 parent "1:$i" netem delay "$i""ms"
    done
    #tc filter add dev eth3 parent 1: protocol ip prio 1 handle 1001 fw classid 1:10
    #tc filter add dev eth3 parent 1: protocol ip prio 1 handle 1002 fw classid 1:20
    end=`date +%s.%N`
    
    
    #iptables -t mangle -A POSTROUTING  -d 192.168.99.66/32 -o eth3 -j MARK --set-xmark 1001
    #iptables -t mangle -A POSTROUTING  -d 192.168.99.126/32 -o eth3 -j MARK --set-xmark 1002
    
    getTiming $start $end
}
for i in `seq 10 10 800`
do
test_time 10
done
