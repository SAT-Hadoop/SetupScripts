#!/bin/bash
set -e
set -x

#assumes you are executing this script where the output-qemu directory is 
virt-sysprep -a output-qemu/*.raw
