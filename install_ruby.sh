#!/bin/bash

sudo apt update
sudo apt install -y ruby-full ruby-bundler build-essential

if ruby -v | grep "ruby 2.3.1"
then
	echo "SUCCESS: Ruby Installed"
else
	echo "ERROR: Ruby was not installed or version is wrong"
fi

if bundler -v | grep "Bundler version 1.11"
then
	echo "SUCCESS: Ruby Installed"
else
	echo "ERROR: Ruby was not installed or version is wrong"	
fi
