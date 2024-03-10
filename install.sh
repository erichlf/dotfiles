#!/bin/bash
 
sudo apt install -y \
  fzf \
  gawk \
  neovim \
  python3-pip \
  rsync \
  stow \
  tmux \
  unzip \
  wget \
  zsh

sudo usermod --shell /usr/bin/zsh $USER

DOTFILES_DIR=$HOME/dotfiles

cd $DOTFILES_DIR

git submodule init
git submodule update

mkdir -p $HOME/.config

stow -v --adopt --dir $DOTFILES_DIR --target $HOME --restow my-home
stow -v --adopt --dir $DOTFILES_DIR --target /etc/default/ --restow etc/default 
stow -v --adopt --dir $DOTFILES_DIR/private/ --target $HOME/.ssh --restow .ssh
stow -v --adopt --dir $DOTFILES_DIR --target $HOME/.config/ --restow starship
# this relies on my-home being stowed already
stow -v --adopt --dir $DOTFILES_DIR --target $HOME/.oh-my-zsh/custom/plugins/ --restow zsh
# if the adopt made a local change then undo that
git checkout HEAD -- starship zsh my-home private
 
# setup starship
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/DroidSansMono.zip
unzip DroidSansMono.zip -d $HOME/.fonts
fc-cache -fv
rm -f DroidSansMono.zip

curl -sS https://starship.rs/install.sh -o starship.sh 
chmod +x starship.sh
./starship.sh -y 
rm -f starship.sh

