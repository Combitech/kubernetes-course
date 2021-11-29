#!/usr/bin/env bash

echo "***************************************************"
echo "Installing oras"
echo "***************************************************"

set -uxo pipefail

if command -v oras &> /dev/null
then
    echo "oras already installed, skipping"
    exit 0
fi

# Install oras [https://oras.land/docs/installation/#linux]
VERSION="1.2.3"
curl -L -o /tmp/oras.tar.gz "https://github.com/oras-project/oras/releases/download/v${VERSION}/oras_${VERSION}_linux_amd64.tar.gz"
mkdir -p /tmp/oras-install/
tar -zxf /tmp/oras.tar.gz -C /tmp/oras-install/
chmod +x /tmp/oras-install/oras
mkdir -p ${HOME}/.local/bin
mv /tmp/oras-install/oras ${HOME}/.local/bin
rm -rf /tmp/oras*
