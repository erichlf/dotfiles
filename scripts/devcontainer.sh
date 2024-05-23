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
  python3-venv \
  zsh

# change to zsh as default shell
sudo chsh -s /usr/bin/zsh

cd $DOTFILES_DIR

# ensure that submodules are downloaded
git submodule init
git submodule update

# create links to dotfiles
sym_links

INFO "Installing NEOVIM..."
# get the newest neovim
add_ppa ppa-verse/neovim
apt_update
apt_install neovim

curl https://sh.rustup.rs -sSf | bash -s -- -y
source $HOME/.cargo/env

lunarvim_install

zsh_extras

starship_install

lazygit_install
