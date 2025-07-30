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
  pass \
  python3-venv \
  pipx \
  software-properties-common \
  stow \
  wget \
  unzip \
  zsh

install_rust

install_nodejs

install_nvim

# change to zsh as default shell
sudo chsh -s /usr/bin/zsh

# ensure that .config is owned by the current user
if [[ -d $HOME/.config && ! $(stat -c "%U" "$HOME/.config") == "$(whoami)" ]]; then
  sudo chown "$(id -u)":"$(id -g)" "$HOME/.config"
fi

# create links to dotfiles
sym_links

pip3_install debugpy

zsh_extras
install_starship
install_lazygit

# hack to get the proper shell to open when using devcontainer connect and nvim
echo "export SHELL=zsh" >>"$HOME/.profile"
