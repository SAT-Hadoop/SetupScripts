for i in `cat /root/hadoop-2.6.0/etc/hadoop/slaves`
do
scp /etc/ganglia/gmond.conf root@$i:/etc/ganglia/
ssh root@$i "
#sudo apt-get -y install ganglia-monitor
/etc/init.d/ganglia-monitor restart
#/etc/init.d/gmetad restart
sudo ufw disable
"
done
