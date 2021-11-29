#!/usr/bin/env bash

# This scripts assumes Ubuntu-24.04 (with systemd)

echo "***************************************************"
echo "Installing helper tools"
echo "***************************************************"

set -uxo pipefail

sudo apt -y update

if command -v yq &> /dev/null
then
    echo "yq already installed, skipping"
else
  # Install yq [https://github.com/mikefarah/yq#wget]
  mkdir -p ${HOME}/.local/bin
  wget https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64 -O ${HOME}/.local/bin/yq
  chmod +x ${HOME}/.local/bin/yq
fi

if command -v tree &> /dev/null
then
  echo "tree already installed, skipping"
else
  sudo apt install -y tree
fi

if command -v batcat &> /dev/null
then
  echo "batcat already installed, skipping"
else
  sudo apt install -y bat
  # Add an alias as well (don't care if that fails)
  if grep "alias bat" ~/.bash*
  then
    echo "Alias for bat already exists" 
  else
    echo "Add alias for 'bat'..."
    echo "alias bat=batcat" >> ~/.bash_aliases || true
  fi
fi

if command -v jq &> /dev/null
then
  echo "jq already installed, skipping"
else
  sudo apt -y install jq
fi

