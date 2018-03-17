#!/bin/bash

su -l ivtcro
echo "$USER"
pwd

git clone -b monolith https://github.com/express42/reddit.git
cd reddit && bundle install
puma -d

if ps aux | grep puma | grep -v grep 
then
	echo "SUCCESS: Reddit application up and running"
else
	echo "ERROR: Reddit application failed to start"
fi
