#!/usr/bin/env bash

# This scripts assumes Ubuntu-24.04 (with systemd)

echo "***************************************************"
echo "Installing k3d"
echo "***************************************************"

set -uxo pipefail

if command -v k3d &> /dev/null
then
    echo "k3d already installed, skipping"
    exit 0
fi

# Install k3d [https://k3d.io/v5.4.9/#installation]
RELEASE=v5.8.3
curl -s -o install_k3d.sh https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh
chmod +x install_k3d.sh
sudo TAG=$RELEASE ./install_k3d.sh
rm install_k3d.sh
