#!/bin/bash 
set -e
set -v

echo password | sudo -S add-apt-repository -y ppa:adiscon/v8-stable
echo password | sudo -S add-apt-repository -y ppa:webupd8team/java 

echo password | sudo -S  apt-get update 
sudo apt-get install -y rsyslog  

# Oracle JDK needed for some of the glassfish packages - It has a license you need to accpet - here is how to auto do that
# http://askubuntu.com/questions/190582/installing-java-automatically-with-silent-option
sudo echo oracle-java7-installer shared/accepted-oracle-license-v1-1 select true | sudo debconf-set-selections
#http://www.himpfen.com/install-java-ubuntu/
sudo apt-get install -y oracle-java7-installer  

# Install aws-cli
sudo pip install awscli

# Install Ganglia as a client to the central server
sudo apt-get install -y ganglia-monitor 

# the host value is the private IP of the central ganlia server IP
sudo sed -i '/mcast_join = 239.2.11.71/i \ host = 192.168.98.218' /etc/ganglia/gmond.conf
sudo sed -i 's/name = "unspecified"/#name = "hadoop-cluster"/g' /etc/ganglia/gmond.conf
sudo sed -i 's/mcast_join = 239.2.11.71/ #mcast_join = 239.2.11.71/g' /etc/ganglia/gmond.conf
sudo sed -i 's/bind = 239.2.11.71/#bind = 239.2.11.71/g' /etc/ganglia/gmond.conf

sudo sed -i 's/port = 8649/#port = 8649/g' /etc/ganglia/gmond.conf

sudo sed -i 's/bind = 239.2.11.71/#bind = 239.2.11.71/g' /etc/ganglia/gmond.conf

sudo service ganglia-monitor restart

# Install rsyslog
# Again assuming that the IP here is the private cloud IP of the Central Rsyslog server
sudo sed -i "$ a *.* @192.168.98.218:514" /etc/rsyslog.conf 

# Install Task Scheduler Application by running setup-scripts sh from Github repo
wget --directory-prefix=/tmp https://raw.githubusercontent.com/SAT-Hadoop/SetupScripts/master/scheduler-setup.sh
chmod u+x /tmp/scheduler-setup.sh
/tmp/scheduler-setup.sh


# ending configuration and poweroff
echo password | sudo -S curl -o /etc/rc.local https://raw.githubusercontent.com/viglesiasce/cloud-images/master/utils/rc.local
echo password | sudo -S chmod +x /etc/rc.local

echo "passwd -l vagrant" > /tmp/shutdown
echo "rm /tmp/shutdown" >> /tmp/shutdown
echo "shutdown -P now" >> /tmp/shutdown
