#!/usr/bin/env bash

source /vagrant/exports.sh

cp /vagrant/gitignore-global ~/.gitignore

git config --global user.name "$GIT_USER_NAME"
git config --global user.email "$GIT_USER_EMAIL"
git config --global core.excludesFile '~/.gitignore'

sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
echo -e '\nexec zsh -l\n' >> ~/.bashrc
