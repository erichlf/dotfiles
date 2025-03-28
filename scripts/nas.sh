#!/bin/bash
SYSTEM="NAS"
DOTFILES_DIR=$(pwd)

set -e

cd $(dirname $0)/..
DOTFILES_DIR=$(pwd)

source "$DOTFILES_DIR/scripts/utils.sh"
source "$DOTFILES_DIR/scripts/base_install.sh"

print_details

pac_install \
  base-devel \
  dialog \
  git \
  stow

############################# grab dotfiles ####################################
# dotfiles already exist since I am running this script!
# git clone git@github.com:erichlf/dotfiles.git
git submodule update --init --recursive

sudo usermod -s $(which zsh) $(whoami)

pac_update

sym_links

INFO "Installing base system..."
base_install

pac_install \
  cockpit \
  cockpit-files \
  cockpit-storaged

yay_install \
  cockpit-file-sharing \
  cockpit-sensors \
  cockpit-zfs-manager

INFO "Finished setting up system."
