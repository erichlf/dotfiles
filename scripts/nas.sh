#!/bin/bash
SYSTEM="NAS"
DOTFILES_DIR=$(pwd)

set -e

alias sudo=sudoj
source "$DOTFILES_DIR/scripts/utils.sh"

print_details

git submodule init
git submodule update

INFO "Installing busybox..."
sudo busybox --install /opt/bin/

INFO "Installing JuNest..."
[[ ! -d $HOME/.local/share/junest ]] && git clone https://github.com/fsquillace/junest.git $HOME/.local/share/junest 
[[ ! -d $HOME/.junest ]] && junest setup
pac_update

INFO "Installing stow..."
pac_install \
  stow

sym_links

INFO "Installing zsh..."
sudo opkg install \
  zsh

INFO "Installing base system..."
pac_install \
  btop \
  fzf \
  iftop \
  python \
  python-pip \
  tmux

zsh_extras

starship_install

INFO "Installing neovim..."
pac_install \
  chafa \
  git-lfs \
  go \
  neovim \
  nodejs \
  npm \
  python-gitpython \
  python-pynvim \
  python-ply \
  python-virtualenv \
  python-yaml \
  rust

lunarvim_install

INFO "Finished setting up system..."
