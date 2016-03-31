#!/bin/bash
#Please access course at http://dak1n1.com/blog/7-performance-tuning-intel-10gbe/ 
sudo service irqbalance stop
sudo setpci -v -d 8086:10fb e6.b=2e
