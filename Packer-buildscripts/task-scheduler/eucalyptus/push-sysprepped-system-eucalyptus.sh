#!/bin/bash
set -e
set -x

# command to deregister previous version needs to go here -- but my power is out so I can't get to the internet right now...

# this script will only work if you have your eucarc credentials sourced and you have VPN or on campus network access
euca-install-image -i output-qemu/ubuntu-trusty-task-scheudler-base.raw --virtualization-type hvm -b ubuntu-trusty-task-scheudler-base -r x86_64 --name task-scheduler 
