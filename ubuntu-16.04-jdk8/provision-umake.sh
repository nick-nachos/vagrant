#!/usr/bin/env bash

UMAKE_APP_DIR="/opt/umake"
IDEA_DIR="$UMAKE_APP_DIR/ide/idea"

mkdir -p "$IDEA_DIR"
umake ide idea "$IDEA_DIR"