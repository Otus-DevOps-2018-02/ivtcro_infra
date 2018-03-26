#!/bin/bash

cd /tmp/
git clone -b cloud-testapp https://github.com/Otus-DevOps-2018-02/ivtcro_infra.git 
cd ivtcro_infra

bash install_ruby.sh
bash install_mongodb.sh
sudo -i -u ivtcro -S <<< "" bash /tmp/ivtcro_infra/deploy.sh

cd ..
rm -fR ivtcro_infra

