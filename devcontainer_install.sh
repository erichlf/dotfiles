#!/bin/bash

DOTFILES=$HOME/dotfiles

cd $DOTFILES

git submodule init
git submodule update

cd $HOME

# setup git
ln -sf $DOTFILES/.gitconfig $HOME/.gitconfig
ln -sf $DOTFILES/.gitexcludes $HOME/.gitexcludes

# powerline fonts for zsh agnoster theme
git clone https://github.com/powerline/fonts.git
cd fonts
./install.sh
cd .. && rm -rf fonts

# oh-my-bash & plugins
cat $DOTFILES/.bashrc >> $HOME/.bashrc
ln -sf $DOTFILES/.aliases $HOME/.aliases
ln -sf $DOTFILES/.oh-my-bash $HOME/.oh-my-bash

