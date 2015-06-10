#!/bin/sh
# Remove sudo password requirement.
echo 'vagrant' | sudo -S sed -i -E 's/^%sudo.+/%sudo ALL=(ALL) NOPASSWD: ALL/' /etc/sudoers
