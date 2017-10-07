#!/usr/bin/env bash

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

# desktop environment
apt-get install -y xubuntu-desktop lightdm moka-icon-theme arc-theme arc-icons
apt-get install -y synaptic apt-xapian-index
# build dependencies
apt-get install -y build-essential dkms
# basic tools
apt-get install -y vim sublime-text-installer meld chromium-browser 
# version control systems
apt-get install -y git subversion
# jdk family
apt-get install -y default-jdk default-jdk-doc maven scala sbt
# umake (works properly for local user ONLY)
apt-get install -y ubuntu-make
UMAKE_APP_DIR="/opt/umake"
mkdir -p "$UMAKE_APP_DIR"
chown -R vagrant:vagrant "$UMAKE_APP_DIR"
# optimize filesystem inotify settings for idea
echo "fs.inotify.max_user_watches = 524288" > /etc/sysctl.d/60-idea.conf
