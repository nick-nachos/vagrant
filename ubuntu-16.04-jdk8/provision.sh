#!/usr/bin/env bash

PROVISION_DOWNLOAD_DIR="/home/vagrant/Downloads/provision"
UMAKE_APP_DIR="/opt/umake"

mkdir -p "$PROVISION_DOWNLOAD_DIR"

add-apt-repository -y ppa:webupd8team/sublime-text-3
add-apt-repository ppa:ubuntu-desktop/ubuntu-make

apt-get update

apt-get install -y lubuntu-desktop
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

apt-get install -y ubuntu-make

mkdir -p "$UMAKE_APP_DIR"
# umake works properly for local user ONLY
chown -R vagrant:vagrant "$UMAKE_APP_DIR"

# Google Chrome
if [ ! `apt-cache policy google-chrome-stable | grep google-chrome-stable` ]; then
	wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb -P "$PROVISION_DOWNLOAD_DIR"
	dpkg -i "$PROVISION_DOWNLOAD_DIR/google-chrome-stable_current_amd64.deb"
	apt-get install -f -y
else
	apt-get install -y google-chrome-stable
fi

echo "fs.inotify.max_user_watches = 524288" > /etc/sysctl.d/60-idea.conf
