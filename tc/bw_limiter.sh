#!/bin/bash
tc qdisc delete dev ns0b1e0654-ba root
tc qdisc add dev ns0b1e0654-ba root handle 1: htb default 30
tc class add dev ns0b1e0654-ba parent 1: classid 1:1 htb rate 1000mbps ceil 1000mbps
tc class add dev ns0b1e0654-ba parent 1:1 classid 1:10 htb rate 10kbps ceil 10kbps
tc class add dev ns0b1e0654-ba parent 1:1 classid 1:20 htb rate 20kbps ceil 20kbps
tc class add dev ns0b1e0654-ba parent 1:1 classid 1:30 htb rate 30kbps ceil 30kbps
tc filter add dev ns0b1e0654-ba parent 1: protocol ip prio 1 u32 match ip dst 192.168.99.66/32 flowid 1:10
#tc filter add dev ns0b1e0654-ba parent 1: protocol ip prio 1 handle 1001 fw classid 1:10
tc filter add dev ns0b1e0654-ba parent 1: protocol ip prio 1 u32 match ip dst 192.168.99.112/32 flowid 1:20
#tc filter add dev ns0b1e0654-ba parent 1: protocol ip prio 1 handle 1002 fw classid 1:20
tc qdisc add dev ns0b1e0654-ba parent 1:10 netem delay 10ms
tc qdisc add dev ns0b1e0654-ba parent 1:20 netem delay 20ms

#iptables -t mangle -A POSTROUTING  -d 192.168.99.66/32 -o ns0b1e0654-ba -j MARK --set-xmark 1001
#iptables -t mangle -A POSTROUTING  -d 192.168.99.126/32 -o ns0b1e0654-ba -j MARK --set-xmark 1002

