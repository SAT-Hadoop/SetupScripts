sudo apt-get update
sudo apt-get -y vim
#sudo apt-get -y install openjdk-7-jdk
sudo apt-get -y install ssh
sudo apt-get -y install rsync
sudo apt-get -y install python-software-properties
sudo apt-get -y install curl
sudo apt-get -y install git
sudo apt-get -y install unzip maven
#sudo apt-get -y install python-pip
#pip install awscli
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

