#!/usr/bin/env bash

apt-get update
apt-get install -y apt-transport-https

# sublime text editor
wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add -
echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list

apt-get update

apt-get install -y \
  vanilla-gnome-desktop arc-theme gnome-shell-extension-dashtodock \
  bash-completion synaptic apt-xapian-index ubuntu-make \
  epiphany-browser gimp sublime-text meld \
  build-essential dkms git subversion vim \
  default-jdk default-jdk-doc maven gradle docker.io

snap install --classic intellij-idea-community

# optimize filesystem inotify settings for idea
echo "fs.inotify.max_user_watches = 524288" > /etc/sysctl.d/60-idea.conf
