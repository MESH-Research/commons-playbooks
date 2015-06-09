#!/bin/sh
git submodule update --init --recursive
cd ansible
ansible-galaxy install -r requirements.yml
