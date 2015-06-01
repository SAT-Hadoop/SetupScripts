#!/bin/bash
set -e
set -x

TYPE=task-scheduler-production
# This is the command to deregister previous version
# best bet is to search for description set below (set this to production or testing to match the system you are replacing

EMI=`euca-describe-images --filter description=$TYPE | awk {'print $2'}`
euca-deregister $EMI --debug 
 

# this script will only work if you have your eucarc credentials sourced and you have VPN or on campus network access
euca-install-image -i output-qemu/ubuntu-trusty-task-scheudler-base.raw --virtualization-type hvm -b ubuntu-trusty-task-scheudler-base -r x86_64 --name task-scheduler-production --description $TYPE --progress --debug
