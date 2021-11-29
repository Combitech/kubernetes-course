#!/usr/bin/env bash

# This scripts assumes Ubuntu-22.04 (with systemd)

echo "***************************************************"
echo "Installing Podman"
echo "***************************************************"

set -uxo pipefail

# Install podman [https://podman.io/getting-started/installation#ubuntu]
sudo apt -y update
sudo apt -y install podman




