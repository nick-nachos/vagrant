#!/usr/bin/env bash

add-apt-repository -y ppa:webupd8team/sublime-text-3
apt-get update

apt-get install -y ubuntu-desktop
apt-get install -y synaptic
apt-get install -y apt-xapian-index

apt-get install -y build-essential
apt-get install -y dkms

apt-get install -y vim
apt-get install -y meld
apt-get install -y sublime-text-installer

apt-get install -y git
apt-get install -y subversion

apt-get install -y default-jdk
apt-get install -y default-jdk-doc
apt-get install -y maven
apt-get install -y scala

apt-get install -y netbeans

# Google Chrome
if [ ! -f "~/Downloads/google-chrome-stable_current_amd64.deb" ]; then
	wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb -P ~/Downloads
fi

dpkg -i ~/Downloads/google-chrome-stable_current_amd64.deb
apt-get install -f -y
