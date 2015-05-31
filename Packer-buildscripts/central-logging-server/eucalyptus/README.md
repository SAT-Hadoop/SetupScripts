## Build Scripts

Build Scripts for Packer Eucalyptus images and SAT-Hadoop project - central loggin server 

### Contents of these build scripts
- the hardrive size can be edited in ubuntu-packer.json
- post_install.sh installs...
  * Installs rsyslog (8.9.0) configures it as a centralized rsyslog server receiving logs from others and storing them in a mariadb database
  * All package dependencies and pre-reqs (in preseed.cfg) `build-essential ssh curl rsync git unzip wget vim python-software-properties software-properties-common ganglia-monitor rrdtool gmetad ganglia-webfrontend mariadb-server`
  * Install Ganglia and configures it as a centralized logging system

### Usage Instructions
- Download [packer] (https://dl.bintray.com/mitchellh/packer/packer_0.7.5_linux_amd64.zip) 
- run packer validte ubuntu-packer.json   
- run packer build ubuntu-packer.json

The post_install_eucalyptus.sh file is where all the customization takes place

note that this config will strip all login access - its only to be prepared for Eucalyptus

See the vagrant box folder for a version you can do local testing on

final command to prep the output folder [is at this repo](https://github.com/viglesiasce/cloud-images/)

It needs to be done on a system that has the eucalyptus-nc tools and libguestfs-tools-c -- which means Centos 6.6

`virt-sysprep -a output-qemu/*.raw`

This command then needs to be done on a system on the network with your eucalyptus credentials sources and euca2ools installed - if you are on campus then you can do from a Centos sysetm - if not you can copy the output-qemu directory over to your Ubuntu partition and use the VPN there.
`euca-install-image -i output-qemu/ubuntu-base.raw --virtualization-type hvm -b ubuntu-base -r x86_64 --name ubuntu-base`


