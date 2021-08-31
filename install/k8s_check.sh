#!/bin/bash
mem=`free  |grep -i mem | awk '{print $2}'`
cpu=`lscpu |grep "CPU(s)" |head -n1 |awk '{print $2}'`
swap=`lsblk |grep -i swap |wc -l`
host=`cat /etc/hosts |wc -l`
i=0

##MEM CHECK
if [ "$mem" -gt 2000000 ];then
        echo "mem okey"
else
        echo "you must check the memory"
fi
#cpu check
if [ "$cpu" -ge 4 ];then
        echo "cpu okey"
else
        echo "you must check the cpu"
fi
#swap check
if [ "$swap" -eq 0 ];then
        echo "SWAP okey"
else
#스왑 켜져있으면 꺼지게 만듦
        swapoff -a
        sed -i.bak -r 's/(.+ swap .+)/#\1/' /etc/fstab
        echo "SWAP okey"
fi

