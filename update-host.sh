#!/bin/bash

read -r -p "Are you sure? [y/N] " response
response=${response,,}    # tolower
if [[ "$response" =~ ^(yes|y)$ ]]
then
    # Update host scripts with scripts located in this repo
    echo "Updating ~/.scripts"
    rsync -av --progress ./.scripts/ ~/.scripts --exclude polybar-redshift/
    
    # Update all rices
    echo "Updating rice files in ~/"
    cp -v .zshrc .bashrc .vimrc .profile .Xresources .xinitrc .bash_aliases .tmux.conf .p10k.zsh .gitconfig ~/
    
    # Update config files
    echo "Updating config files in ~/.config/"
    cp -vr .config/i3 ~/.config/
    cp -vr .config/polybar ~/.config/
    cp -vr .config/dunst ~/.config/
    cp -vr .config/conky ~/.config/
    cp -vr .config/dunst ~/.config/
    cp -vr .config/nvim/ ~/.config/
    cp -vr .config/ranger/ ~/.config/
    cp -vr .config/rofi/ ~/.config/
    cp -vr .config/picom/ ~/.config/
    cp -vr .config/kitty/ ~/.config/
    cp -vr .config/neofetch/ ~/.config/
    cp -vr .config/easyeffects/ ~/.config/
    cp -vr .config/hypr/ ~/.config/
    cp -vr .config/waybar/ ~/.config/

    # ram-monitor script
    mkdir -p ~/.local/bin/ && cp -v .local/bin/ram-monitor.sh ~/.local/bin/ && chmod +x ~/.local/bin/ram-monitor.sh

    # Deprecated
    # cp -vr .config/ncmpcpp/ ~/.config/
    # cp -vr .config/cava ~/.config/
else
    echo "Nothing changed. Exiting."
fi
