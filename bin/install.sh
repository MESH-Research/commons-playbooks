#!/bin/sh
git submodule update --init --recursive
ansible-galaxy install -r requirements.yml
