#!/bin/sh

# AWS accommodation
sleep 15

apt-get update
apt-get upgrade -y

# Ansible 1.9.1 is broken; use pip to install 1.9.0.1.
# apt-get install -y software-properties-common
# apt-add-repository -y ppa:ansible/ansible
# apt-get update
# apt-get -y install ansible
apt-get install -y python-dev
curl -so /tmp/get-pip.py https://bootstrap.pypa.io/get-pip.py
python /tmp/get-pip.py
pip install ansible==1.9.0.1
