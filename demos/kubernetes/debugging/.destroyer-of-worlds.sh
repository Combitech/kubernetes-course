#!/usr/bin/env bash

# Continuously remove files

set -euo pipefail

while true; do
  rm -rf "${@}"
done
