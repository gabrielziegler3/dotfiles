#!/bin/bash

# Update scripts
rsync -av --progress ~/.scripts ~/dotfiles/ --exclude polybar-redshift/

# Update all rices
cp ~/.zshrc ~/.bashrc ~/.vimrc ~/.profile ~/.Xresources ~/.xinitrc ~/.bash_aliases ~/dotfiles/

# Update config files
cp -vr ~/.config/i3 ~/dotfiles/.config/
cp -vr ~/.config/picom.conf ~/dotfiles/.config/
cp -vr ~/.config/polybar ~/dotfiles/.config/
cp -vr ~/.config/dunst ~/dotfiles/.config/
cp -vr ~/.config/conky ~/dotfiles/.config/
cp -vr ~/.config/dunst ~/dotfiles/.config/
cp -vr ~/.config/nvim/ ~/dotfiles/.config/
cp -vr ~/.config/ranger/ ~/dotfiles/.config/
cp -vr ~/.config/rofi/ ~/dotfiles/.config/
cp -vr ~/.config/kitty/ ~/dotfiles/.config/
cp -vr .config/neofetch/ ~/.config/

# Deprecated
# cp -vr ~/.config/ncmpcpp/ ~/dotfiles/.config/
# cp -vr ~/.config/cava ~/dotfiles/.config/
