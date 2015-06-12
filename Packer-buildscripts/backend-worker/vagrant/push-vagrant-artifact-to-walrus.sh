#!/bin/bash
#set -e
set -x

# Remove any pre-existing image
s3cmd -v --recursive del s3://vagrant-builds/vagrant-build-backend-worker

#calculate an md5hash of the vagrant box just for safety
md5sum vagrant-build-backend-worker/ubuntu-backend-worker-packer-vagrant-build-* > md5sum.txt

# This command removes the bucket
#s3cmd -v del s3://vagrant-builds/vagrant-build

# put the build folder for vagrant to Walrus 
s3cmd -v --recursive --progress put vagrant-build-backend-worker s3://vagrant-builds
# set the bucket to public for access for anyone
s3cmd setacl -v -P --recursive  s3://vagrant-builds/vagrant-build-backend-worker/
