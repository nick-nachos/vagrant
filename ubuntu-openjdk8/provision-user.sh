#!/usr/bin/env bash

UMAKE_APP_DIR="/opt/umake"
IDEA_DIR="$UMAKE_APP_DIR/ide/idea"
NETBEANS_DIR="$UMAKE_APP_DIR/ide/netbeans"

mkdir -p "$IDEA_DIR"
umake ide idea "$IDEA_DIR"
mkdir -p "$NETBEANS_DIR"
umake ide netbeans "$NETBEANS_DIR"
