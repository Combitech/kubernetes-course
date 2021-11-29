#!/usr/bin/env bash

# This scripts assumes Ubuntu-24.04 (with systemd)

echo "***************************************************"
echo "Installing Docker"
echo "***************************************************"

set -uxo pipefail

if command -v docker &> /dev/null
then
    echo "docker already installed, skipping"
    exit 0
fi

# Install Docker [https://docs.docker.com/engine/install/ubuntu/]
sudo apt purge docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc

sudo apt update
sudo apt install -y ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings

sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt update

sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
sudo groupadd docker
sudo usermod -aG docker $USER
