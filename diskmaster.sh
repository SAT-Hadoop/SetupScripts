#!/bin/bash
/sbin/mkfs -t ext4 /dev/vdb
/bin/mkdir -p /mnt/vol-01
/bin/mount /dev/vdb /mnt/vol-01
/bin/echo "`/sbin/ifconfig | grep 'inet addr:' | head -1 | awk '{print $2}'|awk -F":" '{print $2}' `  `hostname` " >> /etc/hosts
sed '/master/d' /etc/hosts > temp
/bin/echo "`/sbin/ifconfig | grep 'inet addr:' | head -1 | awk '{print $2}'|awk -F":" '{print $2}' `  master " >> temp
cp temp /etc/hosts
sudo apt-get -y install screen
cd /root
rm -r sat-hadoop-api/ BackendWorker/
git clone https://github.com/SAT-Hadoop/sat-hadoop-api
git clone https://github.com/SAT-Hadoop/BackendWorker
cd sat-hadoop-api/
mvn clean
mvn install
cd ../BackendWorker/
mvn clean 
mvn install
screen -S itmd544
nohup mvn test > my.log 2>&1 &
echo $! > save_pid.txt
