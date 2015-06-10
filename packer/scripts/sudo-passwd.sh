#!/bin/sh
# Remove sudo password.
sed -i -E 's/^%sudo.+/%sudo ALL=(ALL) NOPASSWD: ALL/' /etc/sudoers
