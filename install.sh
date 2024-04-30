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
  neovim \
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

# setup git
ln -sf $DOTFILES/my-home/.gitconfig $HOME/
ln -sf $DOTFILES/my-home/.gitexcludes $HOME/

# oh-my-bash & plugins
ln -sf $DOTFILES/my-home/.profile $HOME/
ln -sf $DOTFILES/my-home/.zshrc $HOME/
ln -sf $DOTFILES/my-home/.aliases $HOME/
ln -sf $DOTFILES/my-home/.exports $HOME/
ln -sf $DOTFILES/my-home/.oh-my-zsh $HOME/
ln -sf $DOTFILES/my-home/.tmux.conf $HOME/
ln -s $DOTFILES/my-home/.tmux $HOME/

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
curl -sS https://starship.rs/install.sh -o starship.sh 
chmod +x starship.sh
sudo ./starship.sh -y -b $HOME/.local/bin 
mkdir -p $HOME/.config
ln -sf $DOTFILES/config/starship.toml $HOME/.config/
rm -f starship.sh

# install lunar vim
curl -sSL https://raw.githubusercontent.com/LunarVim/LunarVim/release-1.3/neovim-0.9/utils/installer/install.sh | LV_BRANCH='release-1.3/neovim-0.9' bash -s -- -y 
ln -sf $DOTFILES/config/lvim $HOME/.config/

