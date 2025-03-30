#!/usr/bin/env bash

source /vagrant/bootstrap/provision-root-source.sh

apt-get install -y docker.io

usermod -aG docker $USER
