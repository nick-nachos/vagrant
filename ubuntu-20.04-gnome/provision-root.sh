#!/usr/bin/env bash

apt-get update
apt-get install -y apt-transport-https

apt-get install -y \
  vanilla-gnome-desktop numix-* gnome-shell-extension-dash-to-panel \
  bash-completion synaptic apt-xapian-index \
  gimp meld \
  build-essential dkms git subversion vim \
  default-jdk default-jdk-doc maven gradle docker.io

snap install brave
snap install --classic intellij-idea-community
snap install --classic sublime-text
snap install --classic sublime-merge

# optimize filesystem inotify settings for idea
echo "fs.inotify.max_user_watches = 524288" > /etc/sysctl.d/60-idea.conf
