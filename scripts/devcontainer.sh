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

# create links to dotfiles
sym_links

INFO "Installing NEOVIM..."
apt_install libfuse2 fuse3
wget https://github.com/neovim/neovim-releases/releases/download/v0.10.1/nvim.appimage
sudo mv nvim.appimage /usr/bin/nvim
sudo chmod u+x /usr/bin/nvim

zsh_extras

starship_install

lazygit_install

# hack to get the proper shell to open when using devcontainer connect and nvim
echo "export SHELL=zsh" >>"$HOME/.profile"
