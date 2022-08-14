#!/usr/bin/env bash

source /vagrant/exports.sh

cp /vagrant/gitignore-global ~/.gitignore

git config --global user.name "$GIT_USER_NAME"
git config --global user.email "$GIT_USER_EMAIL"
git config --global core.excludesFile '~/.gitignore'

sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
echo -e '\nexec zsh -l\n' >> ~/.bashrc
echo 'source /vagrant/zsh-setup.sh' >> ~/.zshrc

# Deploy system installed ZSH pluging to oh-my-zsh
mkdir -p ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions
ln -s /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions/zsh-autosuggestions.plugin.zsh 

mkdir -p ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
ln -s /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.plugin.zsh
