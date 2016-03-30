#!/bin/bash -e

if echo $1 | egrep -q '^[0-9]+$';then 
    echo "$1 is a number"
else
    echo "$1 is not a number"
fi
exit 0
for i in `seq 100`
do
cksum_v=`echo -n $i | cksum | awk '{print $1}'`
echo $(($chsum_v%2))
done
