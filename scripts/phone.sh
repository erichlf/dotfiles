#!/bin/bash
SYSTEM="NAS"
DOTFILES_DIR=$(pwd)

source "$DOTFILES_DIR/scripts/utils.sh"

print_details 
 
pkg install -y \
  fzf \
  getconf \
  openssh \
  python-pip \
  rsync \
  stow \
  termux-api \
  termux-tools \
  neovim \
  which make \
  zsh

pip install pygments

chsh -s zsh

git submodule init
git submodule update

sym_links

zsh_extras

starship_install

lunarvim_install

yes | pkg remove nano

