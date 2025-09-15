#!/bin/bash

set -e
shopt -s expand_aliases

SYSTEM="DEVCONTAINER"
cd "$(dirname "$0")/.."
DOTFILES_DIR=$(pwd)

source "$DOTFILES_DIR/scripts/utils.sh"

print_details

apt_update
apt_install \
  fzf \
  golang-go \
  npm \
  pass \
  python3-venv \
  software-properties-common \
  stow \
  wget \
  unzip \
  zsh

# change to zsh as default shell
sudo chsh -s /usr/bin/zsh

# ensure that .config is owned by the current user
if [[ -d $HOME/.config && ! $(stat -c "%U" "$HOME/.config") == "$(whoami)" ]]; then
  sudo chown $(id -u):$(id -g) "$HOME/.config"
fi

INFO "Installing NEOVIM..."
apt_install libfuse2 fuse3
wget https://github.com/neovim/neovim-releases/releases/download/v0.11.4/nvim-linux-x86_64.appimage
sudo mv nvim.appimage /usr/bin/nvim
sudo chmod u+x /usr/bin/nvim
pip3 install debugpy
