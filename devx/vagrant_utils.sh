#!/usr/bin/env zsh

function vmcd() {
    if [ -z "$VAGRANT_ROOT" ]; then
        echo 'VAGRANT_ROOT is not set; run <install_devx.sh> to setup devx environment'
        return 1
    fi

    local optional_vm_dir="$1"
    if [ "$optional_vm_dir" = '-h' ] || [ "$optional_vm_dir" = '--help' ]; then
        echo 'Usage: vmcd [vm-directory]'
        echo 'Change to the Vagrant root or a specific VM directory.'
        return 0
    fi

    if [ $# -gt 1 ]; then
        echo 'Usage: vmcd [vm-directory]'
        return 1
    fi

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

function vmup() {
    local vm_dir=''
    local post_up_action=''

    while [ $# -gt 0 ]; do
        case "$1" in
            -h|--help)
                echo 'Usage: vmup <vm-directory> [--ssh|--htop]'
                echo 'Start the VM if needed, then optionally ssh in or run htop.'
                return 0
                ;;
            --ssh)
                if [ -n "$post_up_action" ]; then
                    echo 'Usage: vmup <vm-directory> [--ssh|--htop]'
                    return 1
                fi
                post_up_action='ssh'
                ;;
            --htop)
                if [ -n "$post_up_action" ]; then
                    echo 'Usage: vmup <vm-directory> [--ssh|--htop]'
                    return 1
                fi
                post_up_action='htop'
                ;;
            --*)
                echo "Unknown option: $1"
                echo 'Usage: vmup <vm-directory> [--ssh|--htop]'
                return 1
                ;;
            *)
                if [ -n "$vm_dir" ]; then
                    echo 'Usage: vmup <vm-directory> [--ssh|--htop]'
                    return 1
                fi
                vm_dir="$1"
                ;;
        esac
        shift
    done

    if [ -z "$vm_dir" ]; then
        echo 'Usage: vmup <vm-directory> [--ssh|--htop]'
        return 1
    fi

    vmcd "$vm_dir" || return 1

    local status_output
    status_output="$(vagrant status 2>/dev/null)" || return 1

    if [[ ! "$status_output" =~ 'running \(' ]]; then
        vagrant up || return 1
    else
        echo "VM '$vm_dir' is already up and running, skipping 'vagrant up'"
    fi

    case "$post_up_action" in
        ssh)
            vagrant ssh
            ;;
        htop)
            vagrant ssh -c htop
            ;;
    esac
}

function _vmcd() {
    local -a vm_dirs options
    options=(-h --help)
    if [[ -n "$VAGRANT_ROOT" && -d "$VAGRANT_ROOT" ]]; then
        vm_dirs=()
        for dir in "$VAGRANT_ROOT"/*; do
            if [[ -d "$dir" && -f "$dir/Vagrantfile" ]]; then
                vm_dirs+=("${dir##*/}")
            fi
        done
    fi
    compadd -- ${options[@]} ${vm_dirs[@]}
}

function _vmup() {
    local -a vm_dirs options

    options=(-h --help --ssh --htop)

    if [[ -n "$VAGRANT_ROOT" && -d "$VAGRANT_ROOT" ]]; then
        vm_dirs=()
        for dir in "$VAGRANT_ROOT"/*; do
            if [[ -d "$dir" && -f "$dir/Vagrantfile" ]]; then
                vm_dirs+=("${dir##*/}")
            fi
        done
    fi

    compadd -- ${options[@]} ${vm_dirs[@]}
}

compdef _vmcd vmcd
compdef _vmup vmup

