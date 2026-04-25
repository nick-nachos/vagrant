#!/usr/bin/env zsh

set -eo pipefail

SCRIPT_DIR="${0:A:h}"
USER_DEVX_DIR="$HOME/.devx/vagrant"
mkdir -p "$USER_DEVX_DIR"
echo "export VAGRANT_ROOT='$SCRIPT_DIR'" > "$USER_DEVX_DIR/vagrant_root.sh"
cp -f "$SCRIPT_DIR/devx"/*.sh "$USER_DEVX_DIR"

ZSHRC="$HOME/.zshrc"
if [ ! -e "$ZSHRC" ] || ! grep -Fq "for script in $USER_DEVX_DIR/*.sh; do" "$ZSHRC"; then
    cat >> "$ZSHRC" <<EOF
if [ -d "$USER_DEVX_DIR" ]; then
    for script in $USER_DEVX_DIR/*.sh; do
        source "\$script"
    done
fi
EOF
fi
