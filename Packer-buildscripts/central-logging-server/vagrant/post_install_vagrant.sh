#!/bin/bash 
set -e
set -v

echo password | sudo -S add-apt-repository -y ppa:adiscon/v8-stable
echo password | sudo -S  apt-get update 

# Install Ganglia
export DEBIAN_FRONTEND=noninteractive
sud oapt-get install -y ganglia-monitor rrdtool gmetad ganglia-webfrontend

sudo cp /etc/ganglia-webfrontend/apache.conf /etc/apache2/sites-enabled/ganglia.conf

sudo sed -i 's/\"hadoop-cluster\" localhost 192.168.98.218' /etc/ganglia/gmetad.conf
sudo sed -i '/mcast_join = 239.2.11.71/i \ host = 192.168.98.218' /etc/ganglia/gmond.conf
sudo sed -i 's/name = "unspecified"/#name = "hadoop-cluster"/g' /etc/ganglia/gmond.conf
sudo sed -i 's/mcast_join = 239.2.11.71/ #mcast_join = 239.2.11.71/g' /etc/ganglia/gmond.conf
sudo sed -i 's/bind = 239.2.11.71/#bind = 239.2.11.71/g' /etc/ganglia/gmond.conf

sudo sed -i 's/port = 8649/#port = 8649/g' /etc/ganglia/gmond.conf

sudo sed -i 's/bind = 239.2.11.71/#bind = 239.2.11.71/g' /etc/ganglia/gmond.conf

sudo service ganglia-monitor restart
sudo service gmetad restart
sudo service apache2 restart

# Configure and Install rsyslog
sudo echo mariadb-server-5.5 mariadb-server/root_password password string letmein |sudo  debconf-set-selections
sudo echo mariadb-server-5.5 mariadb-server/root_password_again password string letmein | sudo debconf-set-selection
sudo apt-get install -y rsyslog mariadb-server

sudo sed -i 's/#$ModLoad imudp/$ModLoad imudp/g' /etc/rsyslog.conf
sudo sed -i 's/#$UDPServerRun 514/$UDPServerRun 514/g' /etc/rsyslog.conf
sudo sed -i '$ a $template FILENAME,"/var/log/%fromhost-ip%/syslog.log"' /etc/rsyslog.conf
sudo sed -i '$ a *.* ?FILENAME' /etc/rsyslog.conf

sudo service rsyslog restart

# ending configuration and poweroff
#echo password | sudo -S curl -o /etc/rc.local https://raw.githubusercontent.com/viglesiasce/cloud-images/master/utils/rc.local
#echo password | sudo -S chmod +x /etc/rc.local

#echo "passwd -l vagrant" > /tmp/shutdown
echo "rm /tmp/shutdown" >> /tmp/shutdown
echo "shutdown -P now" >> /tmp/shutdown
