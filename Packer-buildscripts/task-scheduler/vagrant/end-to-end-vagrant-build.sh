#!/bin/bash

set -e
set -x

rm -rfv ./vagrant-build

../../../../packer-tool/packer validate ubuntu-packer-vagrant.json

../../../../packer-tool/packer build ubuntu-packer-vagrant.json

./push-vagrant-artifact-to-walrus.sh

echo "All done."
