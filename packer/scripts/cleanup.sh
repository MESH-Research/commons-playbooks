#!/bin/sh

# Remove local Ansible
# apt-get -y purge ansible
# apt-add-repository --remove -y ppa:ansible/ansible
pip uninstall -y ansible

# Cleanup apt cache and unused packages
apt-get autoremove -y --purge
apt-get clean -y
apt-get autoclean -y

# Cleanup log files
find /var/log -type f | while read f; do echo -ne '' > $f; done;

# Zero free space to aid VM compression
dd if=/dev/zero of=/EMPTY bs=1M
rm -f /EMPTY

# Add `sync` so Packer doesn't quit too early
sync
