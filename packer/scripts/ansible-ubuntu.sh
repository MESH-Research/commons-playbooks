#!/bin/sh

# AWS accommodation
sleep 15

sudo apt-get update
sudo apt-get upgrade -y

# Ansible 1.9.1 is broken; use pip to install 1.9.0.1.
# sudo apt-get install -y software-properties-common
# sudo apt-add-repository -y ppa:ansible/ansible
# sudo apt-get update
# sudo apt-get -y install ansible
sudo apt-get install -y python-dev
curl -so /tmp/get-pip.py https://bootstrap.pypa.io/get-pip.py
sudo python /tmp/get-pip.py
sudo -H pip install ansible==1.9.0.1
