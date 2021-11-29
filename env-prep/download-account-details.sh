#!/usr/bin/env bash

read -p "Enter password: " pw

set -x

dest_dir="$HOME/Desktop"
creds="$USER:$pw"
my_name=$(cat /etc/hostname)

file="$my_name.tgz"
curl -s -u "$creds" "https://share.combikubecourse.com/files/$file" | tar xvz -C "$dest_dir"

mkdir -p ~/.kube
cp "$dest_dir/$my_name/kube-config" ~/.kube/config
