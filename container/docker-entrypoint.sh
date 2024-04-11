#!/bin/bash
new_line="10.10.20.20   1c-dev.corp.itworks.group"
hosts_file="/etc/hosts"

echo "$new_line" | tee -a "$hosts_file"

export DISPLAY=:99
Xvfb -ac :99 &
sleep 1
# exec gnome-session &
echo $CI_PROJECT_DIR
git config --global --add safe.directory "$CI_PROJECT_DIR"
cd "$CI_PROJECT_DIR" && bash tools/gitsync.sh
bash