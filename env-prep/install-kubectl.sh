#!/usr/bin/env bash

# This scripts assumes Ubuntu-22.04 (with systemd)

echo "***************************************************"
echo "Installing kubectl"
echo "***************************************************"

set -uxo pipefail

# Install kubectl [https://helm.sh/docs/intro/install/#from-script]
sudo apt update
sudo apt install -y ca-certificates curl
sudo mkdir -p /etc/apt/keyrings
sudo curl -fsSLo /etc/apt/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg
echo "deb [signed-by=/etc/apt/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
sudo apt update
sudo apt install -y kubectl







