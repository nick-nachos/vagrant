#!/usr/bin/env zsh

function vmcd() {
    if [ -z "$VAGRANT_ROOT" ]; then
        echo 'VAGRANT_ROOT is not set; run <install_devx.sh> to setup devx environment'
        return 1
    fi

    local optional_vm_dir="$1"
    if [ -n "$optional_vm_dir" ]; then
        if ! [ -d "$VAGRANT_ROOT/$optional_vm_dir" ] || ! [ -f "$VAGRANT_ROOT/$optional_vm_dir/Vagrantfile" ] ; then
            echo "$optional_vm_dir is not a valid vagrant VM directory under $VAGRANT_ROOT"
            return 1
        fi

        cd "$VAGRANT_ROOT/$optional_vm_dir"
    else
        cd "$VAGRANT_ROOT"
    fi
}

function _vmcd() {
    local -a vm_dirs
    if [[ -n "$VAGRANT_ROOT" && -d "$VAGRANT_ROOT" ]]; then
        vm_dirs=()
        for dir in "$VAGRANT_ROOT"/*; do
            if [[ -d "$dir" && -f "$dir/Vagrantfile" ]]; then
                vm_dirs+=("${dir##*/}")
            fi
        done
    fi
    compadd -- ${vm_dirs[@]}
}

compdef _vmcd vmcd

