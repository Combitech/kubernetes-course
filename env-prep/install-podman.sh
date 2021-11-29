#!/usr/bin/env bash

# This scripts assumes Ubuntu-24.04 (with systemd)

echo "***************************************************"
echo "Installing Podman"
echo "***************************************************"

set -uxo pipefail

if command -v podman &> /dev/null
then
    echo "podman already installed, skipping"
    exit 0
fi

# Install podman [https://podman.io/getting-started/installation#ubuntu]
sudo apt -y update
sudo apt -y install podman
