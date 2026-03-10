#!/bin/bash

# Update scripts
rsync -av --progress ~/.scripts ~/SideProjects/dotfiles/ --exclude polybar-redshift/

# Update all rices
cp ~/.zshrc ~/.bashrc ~/.vimrc ~/.profile ~/.Xresources ~/.xinitrc ~/.bash_aliases ~/SideProjects/dotfiles/
cp ~/.tmux.conf ~/SideProjects/dotfiles/
cp ~/.p10k.zsh ~/SideProjects/dotfiles/
cp ~/.gitconfig ~/SideProjects/dotfiles/

# Update config files
cp -vr ~/.config/i3 ~/SideProjects/dotfiles/.config/
cp -vr ~/.config/picom/ ~/SideProjects/dotfiles/.config/
cp -vr ~/.config/polybar ~/SideProjects/dotfiles/.config/
cp -vr ~/.config/dunst ~/SideProjects/dotfiles/.config/
cp -vr ~/.config/conky ~/SideProjects/dotfiles/.config/
cp -vr ~/.config/nvim/ ~/SideProjects/dotfiles/.config/
cp -vr ~/.config/ranger/ ~/SideProjects/dotfiles/.config/
cp -vr ~/.config/rofi/ ~/SideProjects/dotfiles/.config/
cp -vr ~/.config/kitty/ ~/SideProjects/dotfiles/.config/
cp -vr ~/.config/neofetch/ ~/SideProjects/dotfiles/.config/
cp -vr ~/.config/easyeffects/output/ ~/SideProjects/dotfiles/.config/easyeffects/output/
cp -vr ~/.tmux ~/SideProjects/dotfiles/.tmux/

# ram-monitor script
mkdir -p ~/SideProjects/dotfiles/.local/bin/ && cp -v ~/.local/bin/ram-monitor.sh ~/SideProjects/dotfiles/.local/bin/

# Deprecated
# cp -vr ~/.config/ncmpcpp/ ~/dotfiles/.config/
# cp -vr ~/.config/cava ~/dotfiles/.config/
