#!/usr/bin/env bash

apt-get update
apt-get install -y apt-transport-https

apt-get install -y \
  dkms build-essential libxt6 \
  bash-completion zsh zsh-autosuggestions zsh-syntax-highlighting \
  git subversion vim docker.io golang

groupadd docker
usermod -aG docker $USER

chsh -s $(which zsh) vagrant
