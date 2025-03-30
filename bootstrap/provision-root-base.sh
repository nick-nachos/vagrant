#!/usr/bin/env bash

source /vagrant/bootstrap/provision-root-source.sh

apt-get update
apt-get install -y apt-transport-https

apt-get install -y dkms build-essential bash-completion git vim
