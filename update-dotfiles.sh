#!/bin/bash

# Update scripts
rsync -av --progress ~/.scripts ~/dotfiles/ --exclude polybar-redshift/

# Update all rices
cp ~/.zshrc ~/.bashrc ~/.vimrc ~/.profile ~/.Xresources ~/.xinitrc ~/.bash_aliases ~/dotfiles/

# Update config files
cp -r ~/.config/i3 ~/dotfiles/.config/
cp -r ~/.config/picom.conf ~/dotfiles/.config/
cp -r ~/.config/polybar ~/dotfiles/.config/
cp -r ~/.config/dunst ~/dotfiles/.config/
cp -r ~/.config/cava ~/dotfiles/.config/
cp -r ~/.config/conky ~/dotfiles/.config/
cp -r ~/.config/dunst ~/dotfiles/.config/
cp -r ~/.config/ncmpcpp/ ~/dotfiles/.config/
cp -r ~/.config/nvim/ ~/dotfiles/.config/
cp -r ~/.config/ranger/ ~/dotfiles/.config/
cp -r ~/.config/rofi/ ~/dotfiles/.config/
cp -r ~/.config/kitty/ ~/dotfiles/.config/
