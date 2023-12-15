#!/bin/bash

DOTFILES=$HOME/dotfiles

cd $DOTFILES

git submodule init
git submodule update

cd $HOME

sudo busybox --install /opt/bin/

# spacevim setup
ln -sf $DOTFILES/SpaceVim $HOME/.vim
ln -sf $DOTFILES/.SpaceVim.d $HOME/

# setup git
ln -sf $DOTFILES/.gitconfig $HOME/
ln -sf $DOTFILES/.gitexcludes $HOME/

# oh-my-bash & plugins
ln -sf $DOTFILES/.bashrc $HOME/
ln -sf $DOTFILES/.aliases $HOME/
ln -sf $DOTFILES/.exports $HOME/
ln -sf $DOTFILES/.oh-my-bash $HOME/

# setup starship
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/DroidSansMono.zip
unzip DroidSansMono.zip -d $HOME/.fonts
fc-cache -fv
rm DroidSansMono.zip

curl -sS https://starship.rs/install.sh -o starship.sh 
chmod +x starship.sh
sudo ./starship.sh -y --bin-dir $HOME/.local/bin
starship preset pastel-powerline > $HOME/.config/starship.toml
rm -f starship.sh
 
