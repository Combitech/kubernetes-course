#!/usr/bin/env bash

delay="${ITERATION_DELAY:-10}" # default=10s if ITERATION_DELAY not set

echo
echo "Running on host $(hostname) with iteration delay ${delay}"
echo "Running as user $(whoami), uid: $(id -u), gid: $(id -g)"
echo

while true
do
  echo "---"
  date
  find  /content -type f
  sleep ${delay}
done
