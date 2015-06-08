## Build Scripts

Build Scripts for Packer Eucalyptus images and SAT-Hadoop project - task scheduler system

### Contents of these build scripts
- the hardrive size can be edited in ubuntu-packer.json
- post_install.sh installs...
  * Installs rsyslog (8.9.0) configures it as a client that send its logs to a remote central rsyslog server
  * All package dependencies and pre-reqs (in preseed.cfg) `build-essential ssh curl rsync git unzip wget vim python-software-properties software-properties-common python-pip sysstat openjdk-7-jdk` 
  * added python-magic to base system used to build the image from yum to handle vagrant conversion (optional)

  *  some of the jars require the Oracle JDK 7 to be installed as opposed to the openjdk 7 - [Link to how to here](http://www.himpfen.com/install-java-ubuntu/)
  * awscli via python-pip
  * Install Ganglia and configure it as a client system
  * [Installs Hadoop Automation application](https://github.com/saipramod/HadoopAutomation.git) 
  * [Installs sat-hadoop-api](https://github.com/saipramod/sat-hadoop-api.git) 

### Usage Instructions
- Download [packer] (https://dl.bintray.com/mitchellh/packer/packer_0.7.5_linux_amd64.zip) 
- run packer validte ubuntu-packer.json   
- run packer build ubuntu-packer.json

the post_install.sh file is where all the customization takes place

note that this config will strip all login access - its only to be prepared for Eucalyptus

See the vagrant box folder for a version you can do local testing on

You can use the push-vagrant-to-walrus.sh to move your finished box to Walrus server (note this precludes you have s3cmd installed and are on the VPN or same local network as your walrus)



