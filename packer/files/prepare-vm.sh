#!/bin/bash

cd /tmp/
git clone -b packer-base https://github.com/Otus-DevOps-2018-02/ivtcro_infra.git 
cd ivtcro_infra

bash ./config-scripts/install_ruby.sh
bash ./config-scripts/install_mongodb.sh

sudo -i -u ivtcro -S <<< "" bash /tmp/ivtcro_infra/packer/files/deploy.sh

cd ..
rm -fR ivtcro_infra

