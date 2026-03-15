#!/usr/bin/env bash

source /vagrant/bootstrap/provision-root-source.sh

apt-get install -y \
    golang \
    rustup \
    default-jdk default-jdk-doc maven

# Envoy tutorial setup
apt-get install -y hey
curl https://func-e.io/install.sh | bash -s -- -b /usr/local/bin
