#!/bin/bash
#Function:start capture data from 10gbps link
#author: Melon Li
DRIVER_PATH='/home/node1/PF_RING/drivers/ZC/intel/ixgbe/ixgbe-4.1.5-zc/src/load_driver.sh'
CAP_PORT='eth0'
CAP_FILES_DIR='/home/node1/Documents/n2disk/'
sudo bash $DRIVER_PATH
n2disk10gzc -i zc:$CAP_PORT -o $CAP_FILES_DIR -b 1024 -C 102400 -t 2 -q 1 -S 0 -w 4 -R 1,2,3


