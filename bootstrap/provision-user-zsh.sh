#!/usr/bin/env zsh

# Install oh-my-zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
echo -e '\nsource /vagrant/bootstrap/zsh-setup.sh\n' >> ~/.zshrc

# Deploy system installed ZSH plugins to oh-my-zsh
mkdir -p ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions
ln -s /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions/zsh-autosuggestions.plugin.zsh 

mkdir -p ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
ln -s /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.plugin.zsh
