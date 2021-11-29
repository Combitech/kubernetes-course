#!/usr/bin/env bash

# This scripts assumes Ubuntu-22.04 (with systemd)

echo "***************************************************"
echo "Installing jq and yq"
echo "***************************************************"

set -uxo pipefail

# Install yq [https://github.com/mikefarah/yq#wget]
sudo wget https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64 -O /usr/local/bin/yq
sudo chmod +x /usr/local/bin/yq

# Install jq
sudo apt -y update
sudo apt -y install jq




