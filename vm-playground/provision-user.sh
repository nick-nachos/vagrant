#!/usr/bin/env zsh

# golang setup
mkdir -p ~/go/bin
echo 'export PATH="$HOME/go/bin:$PATH"' >> ~/.zshrc

# rust setup
rustup default stable
