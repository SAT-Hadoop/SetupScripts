## Build Script 

Build Scripts for our central logging server into a vagrant box for testing from a KVM/qemu source
 
### Contents of these build scripts
- the hardrive size can be edited in ubuntu-packer-vagrant.json
- post_install_vagrant.sh installs...
  * Installs rsyslog (8.10.0) configures it as a centralized rsyslog server receiving logs from others and storing them in a mariadb database
  * All package dependencies and pre-reqs (in preseed.cfg) `build-essential ssh curl rsync git unzip wget vim python-software-properties software-properties-common ganglia-monitor rrdtool gmetad ganglia-webfrontend mariadb-server`
  * Install Ganglia and configures it as a centralized logging system

### Usage Instructions
- Download [packer] (https://dl.bintray.com/mitchellh/packer/packer_0.7.5_linux_amd64.zip) 
- run packer validte ubuntu-packer-vagrant.json   
- run packer build ubuntu-packer-vagrant.json

The post_install_vagrant.sh file is where all the customization takes place

Account login information is in the .json file
uname: vagrant
passwd: password

See the vagrant-box folder for a version you can do local testing on

Go to http://vagrantup.com for instructions to run Vagrant

Total build time estimate:
23 minutes on my Intel(R) Core(TM) i3 CPU M 380  @ 2.53GHz 8 GB of ram 5400 RPM HDD


