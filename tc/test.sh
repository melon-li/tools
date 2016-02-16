#!/bin/bash
for i in `ifconfig | grep veth| awk '{printf($1" ")}'`
do
    ip link delete $i
done
