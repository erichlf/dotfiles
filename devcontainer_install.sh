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

# setup starship
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/DroidSansMono.zip
unzip DroidSansMono.zip -d ~/.fonts
fc-cache -fv

curl -sS https://starship.rs/install.sh -o starship.sh 
chmod +x starship.sh
sudo ./starship.sh -y
starship preset pastel-powerline > $HOME/.config/starship.toml
rm -f starship.sh
