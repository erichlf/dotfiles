#!/bin/bash
SYSTEM="NAS"
DOTFILES_DIR=$(pwd)

set -e

cd $(dirname $0)/..
DOTFILES_DIR=$(pwd)

source "$DOTFILES_DIR/scripts/utils.sh"

print_details

git submodule init
git submodule update

if [[ $JUNEST_ENV -ne 1 ]]; then
  INFO "Installing busybox..."
  sudo busybox --install /opt/bin/

  INFO "Installing zsh..."
  sudo opkg install \
    zsh
fi

INFO "Installing JuNest..."
[[ ! -d $HOME/.local/share/junest ]] && git clone https://github.com/fsquillace/junest.git $HOME/.local/share/junest
[[ ! -d $HOME/.junest ]] && junest setup

[[ $JUNEST_ENV -ne 1 ]] && [[ -d .local/share/junest ]] && ./.local/share/junest/bin/junest -b "--bind /share /share"

pac_update

INFO "Installing stow..."
pac_install \
  stow

sym_links

INFO "Installing base system..."
pac_install \
  btop \
  curl \
  docker \
  fzf \
  gzip \
  iftop \
  openssh \
  python \
  python-pip \
  tar \
  tmux \
  wget \
  zsh

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
