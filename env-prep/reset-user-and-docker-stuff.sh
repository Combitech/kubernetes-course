#!/usr/bin/env bash

# If you want the "clear history" part at the end of this script to work:
# - run the script via "exec ./reset-user-and-docker-stuff.sh"
# - don't have any other shells open while doing it

# This scripts assumes Ubuntu-24.04

echo "***************************************************"
echo "Clearing (some) user and Docker stuff"
echo "***************************************************"

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

#set -x

echo "*** Clear Firefox state ***"
bash -c "find $HOME/snap/firefox -name *.sqlite -exec rm -f {} \;" 2>/dev/null

echo "*** Clear docker config and data ***"
rm -f $HOME/.docker/config
docker stop $(docker ps -a -q)
docker volume prune -f -a
docker network prune -f
docker container prune -f
docker system prune -f -a

echo "*** Clear kube-config ***"
rm -rf $HOME/.kube

echo "*** Clear helm state ***"
rm -rf $HOME/.config/helm/*

echo "*** Reset VS code ***"
bash $SCRIPT_DIR/reset-code.sh

echo "*** Re-clone the repo ***"
cd $HOME/repos
rm -rf kubernetes-course
git clone https://github.com/Combitech/kubernetes-course.git kubernetes-course

# This only works if this script has been started with "exec" (see comment at the top)
echo "*** Clear bash history and exit shell ***"
cat /dev/null > $HOME/.bash_history && history -c && history -w && sleep 5 && exit

