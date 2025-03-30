#!/usr/bin/env bash

source /vagrant/bootstrap/provision-root-source.sh

apt-get docker.io golang hey

usermod -aG docker $USER

curl https://func-e.io/install.sh | bash -s -- -b /usr/local/bin
