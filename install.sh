#!/bin/bash

DOTFILES_DIR=$(pwd)

function stow(){

  for f in $1/*; do
    ln -sf $f $2/$(echo $(basename $f) | sed -r 's/dot-/./')
  done

  return 0
}

sudo busybox --install /opt/bin/

sudo opkg install \
  autoconf \
  findutils \
  gawk \
  gcc \
  git \
  git-http \
  go \
  grep \
  htop \
  make \
  neovim \
  python3 \
  python3-pip \
  rename \
  tmux \
  tree \
  vim-full \
  zsh

# the /tmp on my nas only has 64mb of space
mkdir -p /share/Public/tmp
sudo mount /share/Public/tmp /tmp

git submodule init
git submodule update

mkdir -p $HOME/.config
stow $DOTFILES_DIR/my-home $HOME/
stow $DOTFILES_DIR/private/.ssh $HOME/.ssh
stow $DOTFILES_DIR/config $HOME/.config 

# install zgenom
[ ! -d $HOME/.zgenom ] && git clone https://github.com/jandamm/zgenom.git ${HOME}/.zgenom

# install zoxide
curl -sS https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash

# setup fzf
mkdir -p $HOME/.local/bin
git clone --depth 1 https://github.com/junegunn/fzf.git $HOME/.fzf
./$HOME/.fzf/install --bin
cp $HOME/fzf/bin* $HOME/.local/bin/

# install fonts
curl -fsSL https://raw.githubusercontent.com/getnf/getnf/main/install.sh | bash
$HOME/.local/bin/getnf -i DejaVuSansMono,DroidSansMono,Hack,Recursive,RobotoMono

# setup starship
curl -sS https://starship.rs/install.sh -o /tmp/starship.sh 
chmod +x /tmp/starship.sh
sudo /tmp/starship.sh -y -b $HOME/.local/bin 
mkdir -p $HOME/.config

# install lunarvim
curl -sSL https://raw.githubusercontent.com/LunarVim/LunarVim/release-1.3/neovim-0.9/utils/installer/install.sh | LV_BRANCH='release-1.3/neovim-0.9' bash -s -- -y

sudo umount /share/Public/tmp && sudo rm -rf /share/Public/tmp
