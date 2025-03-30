#!/usr/bin/env bash

VM="$1"

if [ -z "$VM" ]; then
    echo 'usage is <./destroy.sh $vm_dir>'
    return 1
fi

if ! [ -d "$VM" ] || ! [ -f "$VM/Vagrantfile" ] ; then
    echo "$d is not a valid vagrant VM directory"
    return 1
fi

update_ssh_config() {
    SSH_DIR="$HOME/.ssh"
    VAGRANT_SSH_DIR="$SSH_DIR/vagrant"
    VAGRANT_SSH_FILE="$VAGRANT_SSH_DIR/$1"

    if [ -f "$VAGRANT_SSH_FILE" ]; then
        rm "$VAGRANT_SSH_FILE"
    fi
}

CURRENT_DIR="$(pwd)"
cd "$VM"
vagrant destroy

if [ "$?" != "0" ]; then
    cd "$CURRENT_DIR"
    return 1
fi

update_ssh_config "$VM"
INSTALL_STATUS=$?

cd "$CURRENT_DIR"

rm -rf "$VM/bootstrap"

return $INSTALL_STATUS
