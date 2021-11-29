#!/usr/bin/env bash

# This scripts assumes Ubuntu-24.04 (with systemd)

echo "***************************************************"
echo "Installing Helm"
echo "***************************************************"

set -uxo pipefail

if command -v helm &> /dev/null
then
    echo "helm already installed, skipping"
else
    # Install Helm [https://helm.sh/docs/intro/install/#from-script]
    curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
    chmod +x get_helm.sh
    sudo ./get_helm.sh
    rm get_helm.sh
fi

if helm plugin list | grep diff
then
    echo "helm-diff already installed, skipping"
else
    helm plugin install https://github.com/databus23/helm-diff
fi
