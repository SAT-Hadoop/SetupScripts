#!/bin/bash
# set e will halt the shell script if there is an error
set -e 
# set x will show verbose output
set -x

# how to check if an application exists previously in a shell script
# http://stackoverflow.com/questions/592620/check-if-a-program-exists-from-a-bash-script
# note I chose Maven as the test itme because it is not commonly installed also the Maven dependency is in the pressed file for the ubuntu install

if ! hash mvn 2>/dev/null; 
  then

  sudo apt-get update
  sudo apt-get -y vim
  sudo apt-get -y install ssh
  sudo apt-get -y install rsync
  sudo apt-get -y install python-software-properties
  sudo apt-get -y install curl
  sudo apt-get -y install git
  sudo apt-get -y install unzip maven
  #sudo apt-get -y install python-pip
  #pip install awscli
  #sudo apt-get -y install openjdk-7-jdk

fi 

wget --directory-prefix=/tmp --progress=dot download.java.net/glassfish/4.0/release/glassfish-4.0.zip
sudo unzip /tmp/glassfish-4.0.zip -d /opt
sudo chmod 777 -R /opt/*
cat /opt/glassfish4/glassfish/domains/domain1/config/domain.xml | sed 's/"8080"/"80"/' > temp
sudo cp temp /opt/glassfish4/glassfish/domains/domain1/config/domain.xml
sudo /opt/glassfish4/bin/asadmin start-domain

sudo /opt/glassfish4/bin/asadmin  create-protocol --securityenabled=false http-redirect

# changing the com.sun.grizzly.config to glassfish as per
# https://java.net/jira/browse/GLASSFISH-18440 
#sudo /opt/glassfish4/bin/asadmin  create-protocol-filter --protocol http-redirect --classname com.sun.grizzly.config.HttpRedirectFilter redirect-filter
sudo /opt/glassfish4/bin/asadmin  create-protocol-filter --protocol http-redirect --classname org.glassfish.grizzly.config.portunif.HttpRedirectFilter redirect-filter

sudo /opt/glassfish4/bin/asadmin  create-protocol --securityenabled=false pu-protocol

sudo /opt/glassfish4/bin/asadmin create-protocol-finder --protocol pu-protocol --targetprotocol http-listener-2 --classname org.glassfish.grizzly.config.portunif.HttpProtocolFinder http-finder

sudo /opt/glassfish4/bin/asadmin create-protocol-finder --protocol pu-protocol --targetprotocol http-redirect --classname org.glassfish.grizzly.config.portunif.HttpProtocolFinder http-redirect

sudo /opt/glassfish4/bin/asadmin  set configs.config.server-config.network-config.network-listeners.network-listener.http-listener-1.protocol=pu-protocol

if [ -a /tmp/sat-hadoop-api ]
  then
    echo "removing currently existing sat-hadoop-api directory\n"
    sudo rm -r /tmp/sat-hadoop-api
fi

if [ -a /tmp/HadoopAutomation ]
  then
    echo "Removing currently existing HadoopAutomation directory\n"
    sudo rm -r /tmp/HadoopAutomation
fi

git clone https://github.com/saipramod/HadoopAutomation.git ~/HadoopAutomation
git clone https://github.com/saipramod/sat-hadoop-api.git ~/sat-hadoop-api

mvn clean install -f ~/sat-hadoop-api/pom.xml
mvn clean install -f ~/HadoopAutomation/pom.xml

sudo /opt/glassfish4/bin/asadmin deploy --force=true ~/HadoopAutomation/target/*.war
