#!/usr/bin/env bash

source /vagrant/bootstrap/exports.sh

# Git setup
cp /vagrant/bootstrap/gitignore-global ~/.gitignore

git config --global user.name "$GIT_USER_NAME"
git config --global user.email "$GIT_USER_EMAIL"
git config --global core.excludesFile '~/.gitignore'

# Create workspace folder
mkdir -p ~/workspace/github
