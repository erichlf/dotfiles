#!/bin/bash
SYSTEM="DEVCONTAINER"
DOTFILES_DIR=$HOME/dotfiles

source "$DOTFILES_DIR/scripts/utils.sh"

print_details

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
sudo add-apt-repository ppa:ppa-verse/neovim -y
sudo apt-get update
sudo apt-get install -y neovim

lunarvim_install

zsh_extras

starship_install

lazygit_install
