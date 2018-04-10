#!/bin/bash

sudo awk '/bindIp/ {print  "  bindIp: 0.0.0.0" ; next} {print $0}' < /etc/mongod.conf > /tmp/mongod.conf.new
sudo mv /etc/mongod.conf /etc/mongod.conf.backup
sudo mv /tmp/mongod.conf.new /etc/mongod.conf
sudo systemctl restart mongod
