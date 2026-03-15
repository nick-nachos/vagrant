#!/usr/bin/env bash

source /vagrant/bootstrap/provision-user-source.sh

cp /vagrant/devx/pdf-nopass.sh "$HOME/.devx"
source_into_zshrc "$HOME/.devx/pdf-nopass.sh"
