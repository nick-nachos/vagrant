#!/usr/bin/env bash

source /vagrant/bootstrap/provision-root-source.sh

apt-get install -y docker.io docker-compose-v2

usermod -aG docker $USER
