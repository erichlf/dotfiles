#!/bin/bash

set -e
shopt -s expand_aliases

SYSTEM="DEVCONTAINER"
cd $(dirname $0)/..
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

# ensure that submodules are downloaded
git submodule init
git submodule update

# ensure that .config is owned by the current user
if [[ -d $HOME/.config && ! $(stat -c "%U" $HOME/.config) == "$(whoami)" ]]; then
  sudo chown $(id -u):$(id -g) $HOME/.config
fi

# create links to dotfiles
sym_links

INFO "Installing NEOVIM..."
# get the newest neovim
add_ppa neovim-ppa/unstable
apt_update
sudo apt-get upgrade -y neovim

curl https://sh.rustup.rs -sSf | bash -s -- -y
source $HOME/.cargo/env

zsh_extras

starship_install

lazygit_install

# hack to get the proper shell to open when using devcontainer connect and nvim
echo "export SHELL=zsh" >> $HOME/.profile

lunarvim_install
