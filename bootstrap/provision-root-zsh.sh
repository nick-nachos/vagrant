#!/usr/bin/env bash

source /vagrant/bootstrap/provision-root-source.sh

apt-get install -y zsh zsh-autosuggestions zsh-syntax-highlighting

chsh -s $(which zsh) vagrant
