#!/usr/bin/env bash

echo "***************************************************"
echo "Installing kubectl"
echo "***************************************************"

set -uxo pipefail

if command -v kubectl &> /dev/null
then
    echo "kubectl already installed, skipping"
    exit 0
fi

# https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/
#curl -s -L -o /tmp/kubectl "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
RELEASE=v1.32.4
curl -s -L -o /tmp/kubectl "https://dl.k8s.io/release/$RELEASE/bin/linux/amd64/kubectl"
chmod +x /tmp/kubectl
mkdir -p ~/.local/bin
mv /tmp/kubectl ~/.local/bin/kubectl
