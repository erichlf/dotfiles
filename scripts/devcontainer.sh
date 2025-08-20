#!/bin/bash

set -e
shopt -s expand_aliases

SYSTEM="DEVCONTAINER"
cd "$(dirname "$0")/.."
DOTFILES_DIR=$(pwd)

source "$DOTFILES_DIR/scripts/utils.sh"

print_details

apt_update
apt_install \
  fuse \
  pass \
  python3-venv \
  pipx \
  software-properties-common \
  stow \
  wget \
  unzip \
  zsh

install_chaotic

pacstall_install \
  fzf-bin \
  neovim-app \
  nodejs-deb

install_rust

# change to zsh as default shell
sudo chsh -s /usr/bin/zsh

# ensure that .config is owned by the current user
if [[ -d $HOME/.config && ! $(stat -c "%U" "$HOME/.config") == "$(whoami)" ]]; then
  sudo chown "$(id -u)":"$(id -g)" "$HOME/.config"
fi

# create links to dotfiles
sym_links

zsh_extras
install_starship
install_lazygit

# use clang 14 for compiler
sudo ln -sf /usr/bin/clang-14 /usr/bin/clang || true
sudo ln -sf /usr/bin/clang++-14 /usr/bin/clang++ || true

# hack to get the proper shell to open when using devcontainer connect and nvim
echo "export SHELL=zsh" >>"$HOME/.profile"
