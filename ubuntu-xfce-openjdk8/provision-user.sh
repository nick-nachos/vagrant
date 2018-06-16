#!/usr/bin/env bash

DESKTOP_FILES_DIR="/usr/share/applications"
LOCAL_DESKTOP_FILES_DIR="/home/vagrant/.local/share/applications"

# umake applications
UMAKE_APP_DIR="/opt/umake"
IDEA_DIR="$UMAKE_APP_DIR/ide/idea"
NETBEANS_DIR="$UMAKE_APP_DIR/ide/netbeans"

mkdir -p "$IDEA_DIR"
umake ide idea "$IDEA_DIR"
mkdir -p "$NETBEANS_DIR"
umake ide netbeans "$NETBEANS_DIR"

# Templates
# touch "/home/vagrant/Templates/Text File.txt"

# Startup applications
AUTOSTART_DIR="/home/vagrant/.config/autostart"
mkdir -p "$AUTOSTART_DIR"
cp "$DESKTOP_FILES_DIR/plank.desktop" "$AUTOSTART_DIR"
