#!/bin/bash

set -x
set -e

#  Create volume to mount 

VAR=`euca-create-volume -z RICE01 -s 5`
VOLUMEID=`echo $VAR | awk {' print $2 '}`
echo $VOLUMEID


euca-run-instances -g default -k jrh-workdesktop -t m1.medium -n 1 -b /dev/vdb=$VOLUMEID emi-e78312b2 --debug 
