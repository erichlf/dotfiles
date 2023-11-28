#!/bin/bash

DOTFILES=$HOME/dotfiles

cd $DOTFILES

git submodule init
git submodule update

cd $HOME

cat $DOTFILES/.bashrc >> $HOME/.bashrc

ln -sf $DOTFILES/.gitconfig $HOME/.gitconfig
ln -sf $DOTFILES/.gitexcludes $HOME/.gitexcludes
ln -sf $DOTFILES/private/.bash_aliases $HOME/.gitexcludes

# powerline fonts for zsh agnoster theme
git clone https://github.com/powerline/fonts.git
cd fonts
./install.sh
cd .. && rm -rf fonts

# rvm-prompt install 
curl -sSL https://get.rvm.io | bash

# fzf install
git clone --depth 1 https://github.com/junegunn/fzf.git $HOME/.fzf
yes | $HOME/.fzf/install

# oh-my-zsh & plugins
rm -f $HOME/.zshrc
rm -rf $HOME/.oh-my-zsh  # remove if it already exists
ln -sf $DOTFILES/.oh-my-zsh $HOME/.oh-my-zsh
ln -s $DOTFILES/zsh2000/zsh2000.zsh-theme $DOTFILES/.oh-my-zsh/custom/themes
ln -s $DOTFILES/zsh-autosuggestions $DOTFILES/.oh-my-zsh/custom/plugins/
ln -s $DOTFILES/zsh-syntax-highlighting $DOTFILES/.oh-my-zsh/custom/plugins/
ln -sf $DOTFILES/.zshrc $HOME/.zshrc
