#!/bin/bash
/sbin/mkfs -t ext4 /dev/vdb
/bin/mkdir /mnt/vol-01
/bin/mount /dev/vdb /mnt/vol-01
/bin/echo "`/sbin/ifconfig | grep 'inet addr:' | head -1 | awk '{print $2}'|awk -F":" '{print $2}' `  `hostname` " >> /etc/hosts
