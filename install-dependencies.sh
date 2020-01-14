sudo pacman -Syu

sudo pacman --needed -S git \
	       zsh \
	       yay \
	       jq \
	       xclip \
	       compton \
	       feh \
	       zotero \
	       transmission-gtk \
	       neofetch \
	       catimg \
	       python-pip \
	       redshift \
	       mesa lib32-mesa xf86-video-amdgpu vulkan-radeon lib32-vulkan-radeon  \
	       xorg-xev \
	       playerctl \
	       opera-ffmpeg-codecs \
	       amdvlk \
	       unrar  \
	       libreoffice-fresh \
	       atool \
	       zip \
	       cmake \
	       xclip \
	       nodejs \
	       npm

yay --needed -S termite docker docker-compose polybar xst rxvt-unicode neovim google-chrome rofi telegram-desktop ttf-font-awesome pavucontrol pamixer tzupdate boost slack-desktop code zotero xorg-xwininfo python-neovim-git ttf-inconsolata opera nemo xst vulkan-amdgpu-pro dunst-git

# Make docker usable without sudo
sudo usermod -aG docker $USER
newgrp docker

# Install Polybar scripts

git clone https://github.com/polybar/polybar-scripts $HOME/polybar-scripts

# Install ZSH dependencies

sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

## Make ZSH my default shell

chsh -s $(which zsh)

## Fix Ycm plugin

python /home/gabrielziegler/.vim/plugged/YouCompleteMe/install.py

## Install Syntax Highlightin for ZSH

git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $HOME/.oh-my-zsh/plugins/zsh-syntax-highlighting

# Install NeoVIM dependencies
curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

