#!/bin/bash
 
pkg install getconf termux-tools vim \
  rsync openssh termux-api which make \
  zsh fzf python-pip stow -y

pip install pygments

chsh -s zsh

DOTFILES_DIR=$HOME/dotfiles

cd $DOTFILES_DIR

git submodule init
git submodule update

mkdir -p $HOME/.config
mkdir -p $HOME/.termux

stow -v --adopt --dir $DOTFILES_DIR --target $HOME --restow my-home
stow -v --adopt --dir $DOTFILES_DIR/private/ --target $HOME/.ssh --restow .ssh
stow -v --adopt --dir $DOTFILES_DIR --target $HOME/.config/ --restow starship
# this relies on my-home being stowed already
stow -v --adopt --dir $DOTFILES_DIR --target $HOME/.oh-my-zsh/custom/plugins/ --restow zsh
stow -v --adopt --dir $DOTFILES_DIR --target $HOME/.termux/ --restow termux
# if the adopt made a local change then undo that
git checkout HEAD -- starship zsh my-home private
 
# setup starship
curl -sSL https://github.com/prateekpunetha/termux-setup/raw/main/fonts/font.ttf -o $HOME/.termux/font.ttf
termux-reload-settings

curl -sS https://starship.rs/install.sh -o starship.sh 
chmod +x starship.sh
./starship.sh -y --bin-dir /data/data/com.termux/files/usr/bin
rm -f starship.sh

yes | pkg remove nano

