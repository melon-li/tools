#!/bin/bash
ps axu | grep nova | grep color -v | grep grep -v | awk '{cmd="sudo kill -9 "$2;system(cmd)}'
ps axu | grep neutron | grep color -v | grep grep -v | awk '{cmd="sudo kill -9 "$2;system(cmd)}'
ps axu | grep ovs | grep color -v | grep grep -v | awk '{cmd="sudo kill -9 "$2;system(cmd)}'
mkfs -t ext4 -q /dev/ram0 10g
if [ ! -d "/home/node1/Documents/n2disk" ];then
    mkdir -p /home/node1/Documents/n2disk
fi

mount /dev/ram0 /home/node1/Documents/n2disk

chmod -R 777 /home/node1/Documents/n2disk

