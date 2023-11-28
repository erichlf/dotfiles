#!/bin/bash

DOTFILES=$(pwd)

cd $HOME

cat $DOTFILES/.bashrc >> ~/.bashrc

ln -sf $DOTFILES/.gitconfig
ln -sf $DOTFILES/.gitexcludes

# powerline fonts for zsh agnoster theme
git clone https://github.com/powerline/fonts.git
cd fonts
./install.sh
cd .. && rm -rf fonts

# oh-my-zsh & plugins
ln -sf $DOTFILES/.oh-my-zsh
wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | zsh || true
zsh -c 'git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions'
zsh -c 'git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting'
ln -sf $DOTFILES/.zshrc
