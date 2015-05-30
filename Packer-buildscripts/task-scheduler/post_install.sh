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

# Install Task Scheduler Application
wget --directory-prefix=/tmp download.java.net/glassfish/4.0/release/glassfish-4.0.zip
unzip /tmp/glassfish-4.0.zip -d /opt
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
git clone https://github.com/saipramod/HadoopAutomation.git /tmp/HadoopAutomation
git clone https://github.com/saipramod/sat-hadoop-api.git /tmp/sat-hadoop-api
cd /tmp/sat-hadoop-api/
mvn clean install
cd /tmp/HadoopAutomation/
mvn clean install
sudo /opt/glassfish4/bin/asadmin deploy --force=true target/*.war


# ending configuration and poweroff
echo password | sudo -S curl -o /etc/rc.local https://raw.githubusercontent.com/viglesiasce/cloud-images/master/utils/rc.local
echo password | sudo -S chmod +x /etc/rc.local

echo "passwd -l vagrant" > /tmp/shutdown
echo "rm /tmp/shutdown" >> /tmp/shutdown
echo "shutdown -P now" >> /tmp/shutdown