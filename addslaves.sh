/bin/echo '
127.0.0.1       localhost
127.0.1.1       ubuntu

# The following lines are desirable for IPv6 capable hosts
::1     ip6-localhost ip6-loopback
fe00::0 ip6-localnet
ff00::0 ip6-mcastprefix
ff02::1 ip6-allnodes
ff02::2 ip6-allrouters
' > /etc/hosts
/bin/echo "`/sbin/ifconfig | grep 'inet addr:' | head -1 | awk '{print $2}'|awk -F":" '{print $2}' `  master " >> /etc/hosts
/bin/echo "`/sbin/ifconfig | grep 'inet addr:' | head -1 | awk '{print $2}'|awk -F":" '{print $2}' `  `hostname` " >> /etc/hosts


for i in `cat /root/hadoop-2.6.0/etc/hadoop/slaves`
do
echo "I am currently working on " $i
/root/BackendWorker/syncmaster $i `/sbin/ifconfig | grep 'inet addr:' | head -1 | awk '{print $2}'|awk -F":" '{print $2}'`
ssh root@$i "
IPADDR=`/sbin/ifconfig | grep 'inet addr:' | head -1 | awk '{print $2}'|awk -F":" '{print $2}'`
IPADDRMOD=`echo $IPADDR | sed 's/\./-/g'`
echo 'euca-i'$IPADDRMOD'.eucalyptus.internal' > /etc/hostname
/usr/sbin/service hostname stop
/usr/sbin/service hostname start
"
/usr/bin/scp /root/hadoop-2.6.0/etc/hadoop/hadoop-env.sh root@$i:/root/hadoop-2.6.0/etc/hadoop/
/usr/bin/scp /root/hadoop-2.6.0/etc/hadoop/yarn-env.sh root@$i:/root/hadoop-2.6.0/etc/hadoop/
/usr/bin/scp /root/hadoop-2.6.0/etc/hadoop/mapred-site.xml root@$i:/root/hadoop-2.6.0/etc/hadoop/
/usr/bin/scp /root/hadoop-2.6.0/etc/hadoop/yarn-site.xml root@$i:/root/hadoop-2.6.0/etc/hadoop/
/usr/bin/scp /root/hadoop-2.6.0/etc/hadoop/hdfs-site.xml root@$i:/root/hadoop-2.6.0/etc/hadoop/
done

for i in `cat /root/hadoop-2.6.0/etc/hadoop/slaves`
do
/usr/bin/scp /etc/hosts root@$i:/etc/hosts
done
