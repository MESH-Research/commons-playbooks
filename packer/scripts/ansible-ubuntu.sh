#!/bin/sh

# AWS accommodation
sleep 15

apt-get update
apt-get upgrade -y

# Ansible >=1.9.2
apt-get install -y software-properties-common
apt-add-repository -y ppa:ansible/ansible
apt-get update
apt-get -y install ansible
