#!/usr/bin/env bash

apt-get update
apt-get install -y apt-transport-https

apt-get install -y \
  dkms bash-completion zsh zsh-syntax-highlighting build-essential libxt6 \
  git subversion vim docker.io golang
