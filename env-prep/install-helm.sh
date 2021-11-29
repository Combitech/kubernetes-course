#!/usr/bin/env bash

# This scripts assumes Ubuntu-22.04 (with systemd)

echo "***************************************************"
echo "Installing Helm"
echo "***************************************************"

set -uxo pipefail

# Install Helm [https://helm.sh/docs/intro/install/#from-script]
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
chmod +x get_helm.sh
sudo ./get_helm.sh
rm get_helm.sh






