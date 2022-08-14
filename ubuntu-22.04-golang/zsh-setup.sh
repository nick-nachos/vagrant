# Enable ZSH plugins

if [ ! -f ~/.vagrant_zsh_setup ]; then
    touch ~/.vagrant_zsh_setup

    _to_enable=(git zsh-autosuggestions zsh-syntax-highlighting)

    for plugin in "${_to_enable[@]}"
    do 
        omz plugin enable "$plugin"
    done
fi
