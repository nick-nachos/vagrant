#!/usr/bin/env bash

export_var() {
    name="$1"
    value="$2"
    echo "export $name='$value'" >> "$EXPORT_FILE"
}

export_vars() {
    GIT_USER_NAME="$(git config --global --get user.name)"
    GIT_USER_EMAIL="$(git config --global --get user.email)"

    if [ -z "$GIT_USER_NAME" ] || [ -z "$GIT_USER_EMAIL" ]; then
        echo 'git [user.name] and [user.email] must be setup prior to this installation; run:'
        echo '<git config --global user.name "Your Name"> and'
        echo '<git config --global user.email "youremail@yourdomain.com"> to setup'
        return 1
    fi

    rm -rf "$EXPORT_FILE"

    export_var 'GIT_USER_NAME' "$GIT_USER_NAME"
    export_var 'GIT_USER_EMAIL' "$GIT_USER_EMAIL"
}

update_ssh_config() {
    SSH_DIR="$HOME/.ssh"
    SSH_CONFIG_FILE="$SSH_DIR/config"
    VAGRANT_SSH_DIR="$SSH_DIR/vagrant"
    VAGRANT_SSH_FILE="$VAGRANT_SSH_DIR/$1"

    if ! [ -d "$SSH_DIR" ]; then
        echo '~/.ssh dir has not been initialised'
        return 1
    fi

    if ! [ -d "$VAGRANT_SSH_DIR" ]; then
        mkdir -p "$VAGRANT_SSH_DIR"
        chmod 700 "$VAGRANT_SSH_DIR"
    fi

    if ! [ -f "$SSH_CONFIG_FILE" ]; then
        touch "$SSH_CONFIG_FILE"
        chmod 600 "$SSH_CONFIG_FILE"
    fi

    if [ -z "$(cat "$SSH_CONFIG_FILE" | grep "$VAGRANT_SSH_DIR")" ]; then
        echo "Include $VAGRANT_SSH_DIR/*" >> "$SSH_CONFIG_FILE"
    fi

    echo "Host vagrant.$1" > "$VAGRANT_SSH_FILE"
    echo "$(vagrant ssh-config | tail -n +2)" >> "$VAGRANT_SSH_FILE"
    chmod 600 "$VAGRANT_SSH_FILE"
}

if [ -z "$1" ]; then
    echo 'usage is <./install.sh $vm_dir>'
    return 1
fi

if ! [ -d "$1" ] || ! [ -f "$1/Vagrantfile" ] ; then
    echo "$d is not a valid vagrant VM directory"
    return 1
fi

EXPORT_FILE="$1/exports.sh"
CURRENT_DIR="$(pwd)"
export_vars

if [ "$?" != "0" ]; then
    return 1
fi

cd "$1"
vagrant up

if [ "$?" != "0" ]; then
    cd "$CURRENT_DIR"
    return 1
fi

update_ssh_config "$1"
INSTALL_STATUS=$?
cd "$CURRENT_DIR"
rm "$EXPORT_FILE"

return $INSTALL_STATUS
