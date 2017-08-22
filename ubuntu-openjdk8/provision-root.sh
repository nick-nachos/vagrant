#!/usr/bin/env bash

UMAKE_APP_DIR="/opt/umake"

# sublime text editor
add-apt-repository -y ppa:webupd8team/sublime-text-3
# ubuntu-make
add-apt-repository ppa:ubuntu-desktop/ubuntu-make
# scala build tool (sbt)
echo "deb https://dl.bintray.com/sbt/debian /" | tee -a /etc/apt/sources.list.d/sbt.list
apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 2EE0EA64E40A89B84B2DF73499E82A75642AC823
# xfce themes/icons
add-apt-repository ppa:moka/stable
add-apt-repository ppa:noobslab/themes
add-apt-repository ppa:noobslab/icons

apt-get update

apt-get install -y xubuntu-desktop
apt-get install -y lightdm

apt-get install -y moka-icon-theme
apt-get install -y arc-theme
apt-get install -y arc-icons

apt-get install -y synaptic
apt-get install -y apt-xapian-index

apt-get install -y build-essential
apt-get install -y dkms

apt-get install -y vim
apt-get install -y meld
apt-get install -y sublime-text-installer

apt-get install -y chromium-browser

apt-get install -y git
apt-get install -y subversion

apt-get install -y default-jdk
apt-get install -y default-jdk-doc
apt-get install -y maven
apt-get install -y scala
apt-get install -y sbt

apt-get install -y ubuntu-make

mkdir -p "$UMAKE_APP_DIR"
# umake works properly for local user ONLY
chown -R vagrant:vagrant "$UMAKE_APP_DIR"

# optimize filesystem inotify settings for idea
echo "fs.inotify.max_user_watches = 524288" > /etc/sysctl.d/60-idea.conf
