#!/usr/bin/env zsh

source /vagrant/exports.sh

# Git setup
cp /vagrant/gitignore-global ~/.gitignore

git config --global user.name "$GIT_USER_NAME"
git config --global user.email "$GIT_USER_EMAIL"
git config --global core.excludesFile '~/.gitignore'

# Create workspace folder
mkdir -p ~/workspace/github

# Install oh-my-zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
echo -e '\nsource /vagrant/zsh-setup.sh\n' >> ~/.zshrc

# Deploy system installed ZSH pluging to oh-my-zsh
mkdir -p ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions
ln -s /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions/zsh-autosuggestions.plugin.zsh 

mkdir -p ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
ln -s /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.plugin.zsh

# Set $PATH
mkdir -p ~/go/bin

echo 'export PATH="$HOME/go/bin:$PATH"'
