#!/bin/bash
if [ -z "$1" ];then
    echo "Usage:$0 + command"
    exit $!
elif [ "deny" = "$1" ];then
    ps -ef|grep "$2"|grep -v grep|awk '{print $2}'|xargs kill -9
    exit $!
fi
echo 2
for arg in $*
do
    str="${str} ${arg}"
done
nohup $str >>/var/log/mservice.log 2>&1 &
exit 0
