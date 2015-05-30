#!/bin/bash

set -e

apt-get install -y python-software-properties

add-apt-repository -y ppa:adiscon/v8-stable
add-apt-repository -y ppa:chris-lea/node.js

apt-get update -y
apt-get install -y nodejs rsyslog
npm install -g bower
npm install -g gulp

# Install Vector application
git clone https://github.com/Netflix/vector.git
cd vector/
bower install

curl 'https://bintray.com/user/downloadSubjectPublicKey?username=netflixoss' | sudo apt-key add -
echo "deb https://dl.bintray.com/netflixoss/ubuntu trusty main" | sudo tee -a /etc/apt/sources.list
sudo apt-get update -y
apt-get install -y pcp
service pcp start

# Install aws-cli
pip install awscli

#app install
cd /tmp
wget download.java.net/glassfish/4.0/release/glassfish-4.0.zip
sudo unzip glassfish-4.0.zip -d /opt
sudo chmod 777 -R /opt/*
cat /opt/glassfish4/glassfish/domains/domain1/config/domain.xml | sed 's/"8080"/"80"/' > temp
sudo cp temp /opt/glassfish4/glassfish/domains/domain1/config/domain.xml
sudo /opt/glassfish4/bin/asadmin start-domain

sudo /opt/glassfish4/bin/asadmin  create-protocol --securityenabled=false http-redirect
sudo /opt/glassfish4/bin/asadmin  create-protocol-filter --protocol http-redirect --classname com.sun.grizzly.config.HttpRedirectFilter redirect-filter

sudo /opt/glassfish4/bin/asadmin  create-protocol --securityenabled=false pu-protocol

sudo /opt/glassfish4/bin/asadmin create-protocol-finder --protocol pu-protocol --targetprotocol http-listener-2 --classname org.glassfish.grizzly.config.portunif.HttpProtocolFinder http-finder

sudo /opt/glassfish4/bin/asadmin create-protocol-finder --protocol pu-protocol --targetprotocol http-redirect --classname org.glassfish.grizzly.config.portunif.HttpProtocolFinder http-redirect

sudo /opt/glassfish4/bin/asadmin  set configs.config.server-config.network-config.network-listeners.network-listener.http-listener-1.protocol=pu-protocol

sudo rm -r sat-hadoop-api
sudo rm -r HadoopAutomation
git clone https://github.com/saipramod/HadoopAutomation.git
git clone https://github.com/saipramod/sat-hadoop-api.git
cd sat-hadoop-api/
mvn clean install
cd ..
cd HadoopAutomation/
mvn clean install
sudo /opt/glassfish4/bin/asadmin deploy --force=true target/*.war

# ending configuration and poweroff
echo password | sudo -S curl -o /etc/rc.local https://raw.githubusercontent.com/viglesiasce/cloud-images/master/utils/rc.local
echo password | sudo -S chmod +x /etc/rc.local

echo "passwd -l vagrant" > /tmp/shutdown
echo "rm /tmp/shutdown" >> /tmp/shutdown
echo "shutdown -P now" >> /tmp/shutdown
