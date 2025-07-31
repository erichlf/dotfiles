#!/bin/bash
SYSTEM="NAS"
cd $(dirname $0)/..
DOTFILES_DIR=$(pwd)

source "$DOTFILES_DIR/scripts/utils.sh"

print_details

INFO "Installing base system"
pkg install -y \
  fzf \
  git \
  getconf \
  gnupg \
  make \
  openssh \
  python-pip \
  rsync \
  stow \
  termux-api \
  termux-tools \
  neovim \
  which \
  zsh

pip install pygments

chsh -s zsh

git submodule init
git submodule update

sym_links

zsh_extras

install_starship

yes | pkg remove nano

INFO "Finished setting up system"
