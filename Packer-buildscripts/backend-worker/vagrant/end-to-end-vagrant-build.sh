#!/bin/bash

#set -e
set -x

if [ -d ./vagrant-build-backend-worker ]; then
 
  rm -rfv ./vagrant-build-backend-worker/*

else

  mkdir ./vagrant-build-backend-worker

fi

if [ -d ./output-qemu ]; then

  rm -rfv ./output-qemu

fi

../../../../packer-tool/packer validate ubuntu-packer-vagrant.json

../../../../packer-tool/packer build ubuntu-packer-vagrant.json

./push-vagrant-artifact-to-walrus.sh

echo "All done."
