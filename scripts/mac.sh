#!/bin/bash
SYSTEM="MAC"
cd $(dirname $0)/..
DOTFILES_DIR=$(pwd)

source "$DOTFILES_DIR/scripts/utils.sh"

print_details "$SYSTEM"

sudo rm -rf /Library/Developer/CommandLineTools
sudo xcode-select --install

/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

brew doctor
brew cleanup

INFO "Installing base system..."
brew install \
  fzf \
  gpg \
  neovim \
  starship \
  stow

git submodule init
git submodule update

sym_links

zsh_extras

lazygit_install

lunarvim_install
