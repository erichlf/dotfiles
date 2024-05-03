#!/bin/bash
SYSTEM="MAC"
DOTFILES_DIR=$(pwd)

source "$DOTFILES_DIR/scripts/utils.sh"

print_details "$SYSTEM"

/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

brew install neovim fzf starship stow gpg

chsh -s /bin/zsh

git submodule init
git submodule update

sym_links

zsh_extras

lazygit_install

lunarvim_install
