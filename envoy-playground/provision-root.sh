#!/usr/bin/env bash

apt-get update
apt-get install -y apt-transport-https

apt-get install -y \
  dkms build-essential libxt6 \
  bash-completion zsh zsh-autosuggestions zsh-syntax-highlighting \
  git vim docker.io golang hey

groupadd docker
usermod -aG docker $USER

curl https://func-e.io/install.sh | bash -s -- -b /usr/local/bin

chsh -s $(which zsh) vagrant
