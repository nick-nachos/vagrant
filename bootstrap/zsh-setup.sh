# Enable ZSH plugins

if [ ! -f ~/.vagrant_zsh_setup ]; then
    touch ~/.vagrant_zsh_setup

    to_enable=(git zsh-autosuggestions zsh-syntax-highlighting)

    for plugin in "${to_enable[@]}"
    do 
        omz plugin enable "$plugin"
    done
fi
