#!/bin/bash

DOTFILES=$(pwd)

sudo busybox --install /opt/bin/

sudo opkg install \
  findutils \
  gawk \
  git \
  git-http \
  grep \
  htop \
  make \
  python3 \ 
  python3-pip \
  rename \
  tmux \
  tree \
  vim-full \
  zsh

git submodule init
git submodule update

cd $HOME

# spacevim setup
ln -sf $DOTFILES/my-home/SpaceVim $HOME/.vim
ln -sf $DOTFILES/my-home/.SpaceVim.d $HOME/

# setup git
ln -sf $DOTFILES/my-home/.gitconfig $HOME/
ln -sf $DOTFILES/my-home/.gitexcludes $HOME/

# oh-my-bash & plugins
ln -sf $DOTFILES/my-home/.profile $HOME/
ln -sf $DOTFILES/my-home/.zshrc $HOME/
ln -sf $DOTFILES/my-home/.aliases $HOME/
ln -sf $DOTFILES/my-home/.exports $HOME/
ln -s $DOTFILES/zsh/zsh-autosuggestions $DOTFILES/.oh-my-zsh/custom/plugins/
ln -s $DOTFILES/zsh/zsh-syntax-highlighting $DOTFILES/.oh-my-zsh/custom/plugins/
ln -sf $DOTFILES/my-home/.oh-my-zsh $HOME/
ln -sf $DOTFILES/my-home/.tmux.conf $HOME/
ln -s $DOTFILES/my-home/.tmux $HOME/

# setup fzf
mkdir -p $HOME/.local/bin
git clone --depth 1 https://github.com/junegunn/fzf.git $HOME/.fzf
./$HOME/.fzf/install --bin
cp $HOME/fzf/bin* $HOME/.local/bin/

# setup starship
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/DroidSansMono.zip
unzip DroidSansMono.zip -d $HOME/.fonts
fc-cache -fv
rm DroidSansMono.zip

curl -sS https://starship.rs/install.sh -o starship.sh 
chmod +x starship.sh
sudo ./starship.sh -y -b $HOME/.local/bin 
mkdir -p $HOME/.config
ln -sf $DOTFILES/starship/starship.toml $HOME/.config/
rm -f starship.sh

