#!/bin/bash
if [ -z "$1" ];then
    echo "Usage:$0 + command"
    exit $number
fi
for arg in $*
do
    str="${str} ${arg}"    
done
nohup $str >>/var/log/mservice.log 2>&1 &
exit 0
