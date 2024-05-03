#!/bin/bash
SYSTEM="NAS"
DOTFILES_DIR=$(pwd)

source utils.sh

print_details

function stow(){
  for f in $1/*; do
    ln -sf $f $2/$(echo $(basename $f) | sed -r 's/dot-/./')
  done

  return 0
}

# redefine symlinks to use the nas stow
function sym_links(){
  mkdir -p $HOME/.config
  stow $DOTFILES_DIR/my-home $HOME/
  stow $DOTFILES_DIR/private/.ssh $HOME/.ssh
  stow $DOTFILES_DIR/config $HOME/.config 
}

sudo busybox --install /opt/bin/

sudo opkg install \
  autoconf \
  findutils \
  gawk \
  gcc \
  git \
  git-http \
  go \
  grep \
  htop \
  make \
  neovim \
  python3 \
  python3-pip \
  rename \
  tmux \
  tree \
  vim-full \
  zsh

# the /tmp on my nas only has 64mb of space
mkdir -p /share/Public/tmp
sudo mount /share/Public/tmp /tmp

git submodule init
git submodule update

sym_links

zsh_extras

fzf_install

starship_install

lunarvim_install

sudo umount /share/Public/tmp && sudo rm -rf /share/Public/tmp
