#!/usr/bin/env bash

apt-get update
apt-get install -y apt-transport-https

# sublime text editor
wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add -
echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list
# ubuntu-make
add-apt-repository ppa:ubuntu-desktop/ubuntu-make
# scala build tool (sbt)
echo "deb https://dl.bintray.com/sbt/debian /" | tee -a /etc/apt/sources.list.d/sbt.list
apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 2EE0EA64E40A89B84B2DF73499E82A75642AC823
# themes/icons
add-apt-repository -y ppa:noobslab/themes
add-apt-repository -y ppa:noobslab/icons
add-apt-repository -y ppa:snwh/pulp

apt-get update

apt-get install -y \
  xubuntu-desktop lightdm arc-theme paper-icon-theme paper-cursor-theme plank \
  synaptic apt-xapian-index \
  build-essential dkms git subversion vim sublime-text meld \
  chromium-browser gimp \
  default-jdk default-jdk-doc maven scala sbt \
  ubuntu-make

# umake (works properly for local user ONLY)
UMAKE_APP_DIR="/opt/umake"
mkdir -p "$UMAKE_APP_DIR"
chown -R vagrant:vagrant "$UMAKE_APP_DIR"
# optimize filesystem inotify settings for idea
echo "fs.inotify.max_user_watches = 524288" > /etc/sysctl.d/60-idea.conf
