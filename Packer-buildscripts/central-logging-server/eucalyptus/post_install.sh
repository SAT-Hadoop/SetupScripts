#!/bin/bash 
set -e
set -v

echo password | sudo -S add-apt-repository -y ppa:adiscon/v8-stable

echo password | sudo -S  apt-get update 
sudo apt-get install -y rsyslog 

# Install aws-cli
sudo pip install awscli

# Install Ganglia
sudo apt-get install -y ganglia-monitor rrdtool gmetad ganglia-webfrontend

sudo cp /etc/ganglia-webfrontend/apache.conf /etc/apache2/sites-enabled/ganglia.conf

sed -i 's/\"hadoop-cluster\" localhost 192.168.98.218' /etc/ganglia/gmetad.conf

sed -i 's/mcast_join = 239.2.11.71/i \ host = 192.168.98.218' /etc/ganglia/gmond.conf
sed -i 's/mcast_join = 239.2.11.71/#mcast_join = 239.2.11.71/g' /etc/ganglia/gmond.conf
sed -i 's/bind = 239.2.11.71/#bind = 239.2.11.71/g' /etc/ganglia/gmond.conf

sudo /etc/init.d/ganglia-monitor start
sudo /etc/init.d/gmetad start
sudo /etc/init.d/apache2 restart

# Install rsyslog


# ending configuration and poweroff
echo password | sudo -S curl -o /etc/rc.local https://raw.githubusercontent.com/viglesiasce/cloud-images/master/utils/rc.local
echo password | sudo -S chmod +x /etc/rc.local

echo "passwd -l vagrant" > /tmp/shutdown
echo "rm /tmp/shutdown" >> /tmp/shutdown
echo "shutdown -P now" >> /tmp/shutdown
