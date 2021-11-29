#!/usr/bin/env bash

# This scripts assumes Ubuntu-22.04 (with systemd)

echo "***************************************************"
echo "Installing k3d"
echo "***************************************************"

set -uxo pipefail

# Install k3d [https://k3d.io/v5.4.9/#installation]
curl -s -o install_k3d.sh https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh
chmod +x install_k3d.sh
sudo ./install_k3d.sh
rm install_k3d.sh





