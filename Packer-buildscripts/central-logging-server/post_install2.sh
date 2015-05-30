#!/bin/bash 
set -e
set -v

echo password | sudo -S add-apt-repository -y ppa:adiscon/v8-stable
echo password | sudo -S add-apt-repository -y ppa:chris-lea/node.js

echo password | sudo -S  apt-get update 
sudo apt-get install -y nodejs rsyslog
sudo npm install -g bower
sudo npm install -g gulp

# Install Vector application
git clone https://github.com/Netflix/vector.git /tmp/vector
cd /tmp/vector
bower install

git clone git://git.pcp.io/pcp /tmp/pcp
sudo apt-get -y build-dep pcp

#build and install
cd /tmp/pcp
./configure --prefix=/usr --sysconfdir=/etc --localstatedir=/var --with-webapi
make
sudo groupadd -r pcp
sudo useradd -c "Performance Co-Pilot" -g pcp -d /var/lib/pcp -M -r -s /usr/sbin/nologin pcp
sudo make install

sudo service pcp start

# Install aws-cli
sudo pip install awscli

# ending configuration and poweroff
echo password | sudo -S curl -o /etc/rc.local https://raw.githubusercontent.com/viglesiasce/cloud-images/master/utils/rc.local
echo password | sudo -S chmod +x /etc/rc.local

echo "passwd -l vagrant" > /tmp/shutdown
echo "rm /tmp/shutdown" >> /tmp/shutdown
echo "shutdown -P now" >> /tmp/shutdown
