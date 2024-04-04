#!/bin/bash

DOTFILES=$(pwd)

/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

brew install vim fzf starship gpg

chsh -s /bin/zsh

git submodule init
git submodule update

cd $HOME

# setup gpg keys agen
mkdir -p $HOME/.gnupg
ln -sf $DOTFILES/gpg.conf $HOME/.gnupg/
ln -sf $DOTFILES/gpg-agent.conf $HOME/.gnupg

# spacevim setup
ln -sf $DOTFILES/SpaceVim $HOME/.vim
ln -sf $DOTFILES/.SpaceVim.d $HOME/

# setup git
ln -sf $DOTFILES/.gitconfig $HOME/
ln -sf $DOTFILES/.gitexcludes $HOME/

# oh-my-zsh & plugins
ln -sf $DOTFILES/.profile $HOME/
ln -sf $DOTFILES/.zshrc $HOME/
ln -sf $DOTFILES/.aliases $HOME/
ln -sf $DOTFILES/.exports $HOME/
ln -s $DOTFILES/zsh-autosuggestions $DOTFILES/.oh-my-zsh/custom/plugins/
ln -s $DOTFILES/zsh-syntax-highlighting $DOTFILES/.oh-my-zsh/custom/plugins/
ln -sf $DOTFILES/.oh-my-zsh $HOME/

# hyper config
ln -sf $DOTFILES/.hyper.js $HOME/ 

# install fonts
curl -fsSL https://raw.githubusercontent.com/getnf/getnf/main/install.sh | bash
$HOME/.local/bin/getnf -i 17,18,26,55,56

# setup starship
mkdir -p $HOME/.config
ln -sf $DOTFILES/starship.toml $HOME/.config/
