#!/bin/bash
set -e
set -x

#this script will rm -rf any existing artifacts to start fresh

while getopts ":t:" opt; do
  case $opt in
    t)
      #if [ "$#" -eq 1 ]; then
      if [ -a output-qemu ]
        then
          rm -rf output-qemu
      fi

       # validate the packer build script here

       ../../../../packer-tool/packer validate ubuntu-packer-eucalyptus.json

       # packer build ubuntu-packer-eucalyptus.json
       ../../../../packer-tool/packer build ubuntu-packer-eucalyptus.json

       #Does the local finishing touches
       ./sysprep-script.sh

       # has code to also delete prior images and update to the new one

       ./push-sysprepped-system-eucalyptus.sh $OPTARG
       echo "++++++++++++++++++++++++++++++++++++++++++++"
       echo "+ All Done                                 +"
       echo "++++++++++++++++++++++++++++++++++++++++++++"
       echo " "
       ;;
    \?)
       echo "Invalid option: -$OPTARG" >&2
       exit 1
       ;;
    :)
      echo "Option -$OPTARG requires and argument STABLE or TEST." >&2
      exit 1
      ;;
  esac
done
