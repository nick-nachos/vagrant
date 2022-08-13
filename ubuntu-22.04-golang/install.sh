#!/usr/bin/env bash

EXPORT_FILE='./exports.sh'

export_var() {
    name="$1"
    value="$2"
    echo "export $name='$value'" >> "$EXPORT_FILE"
}

export_vars() {
    GIT_USER_NAME="$(git config --global --get user.name)"
    GIT_USER_EMAIL="$(git config --global --get user.email)"

    rm -rf "$EXPORT_FILE"

    export_var 'GIT_USER_NAME' "$GIT_USER_NAME"
    export_var 'GIT_USER_EMAIL' "$GIT_USER_EMAIL"
}

export_vars
vagrant up
