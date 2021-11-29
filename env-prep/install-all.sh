#!/usr/bin/env bash

# This scripts assumes Ubuntu-22.04 (with systemd)

set -uo pipefail

# General update
sudo apt update
sudo apt -y dist-upgrade

bash ./install-jqyq.sh
bash ./install-docker.sh
bash ./install-podman.sh
bash ./install-helm.sh
bash ./install-kubectl.sh
bash ./install-k3d.sh
if [[ -z ${WSL_DISTRO_NAME-} ]]; then
  bash ./install-code.sh
else
  echo
  echo "WSL detected, skipping install of VS Code";
fi
