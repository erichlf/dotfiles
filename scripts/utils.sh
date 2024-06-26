shopt -s expand_aliases

OS=$(uname -o)
KERNEL=$(uname -s)
KERNEL_RELEASE=$(uname -r)
KERNEL_VERSION=$(uname -v)
NODE=$(uname -n)

BWHITE='\033[1;37m'
GREEN='\033[0;32m'
ORANGE='\033[0;33'
RED='\033[0;31m'
RESET='\033[0m'

function LOG(){
  echo -e "$@ ${RESET}"
}

function INFO(){
  LOG ${GREEN}$@
}

function WARN(){
  LOG ${ORANGE}$@
}

function ERROR(){
  LOG ${RED}$@
}

# print the current system details
# this expects DOTFILES_DIR and SYSTEM to be defined
function print_details(){
  LOG ${BWHITE} \
"
SYSTEM:         $SYSTEM
OS:             $OS
KERNEL:         $KERNEL
KERNEL_RELEASE: $KERNEL_RELEASE
KERNEL_VERSION: $KERNEL_VERSION
NODE:           $NODE
USER:           $(whoami)
HOME:           $HOME
DOTFILES_DIR:   $DOTFILES_DIR
"
}

# function to create my links
# This expects the variable $DOTFILES_DIR to exist
function sym_links(){
  INFO "Creating symlinks..."
  mkdir -p $HOME/.config
  stow -v --dotfiles --adopt --dir $DOTFILES_DIR --target $HOME --restow my-home
  stow -v --adopt --dir $DOTFILES_DIR/private/ --target $HOME/.ssh --restow .ssh
  stow -v --adopt --dir $DOTFILES_DIR --target $HOME/.config/ --restow config
  # if the adopt made a local change then undo that
  git checkout HEAD -- config my-home private

  return 0
}

function ask(){
  read -p "$1 [$2] " answer
  answer="${answer:-$2}"
  case "$answer" in
    y|Y ) return 0;;
    n|N ) return 1;;
    * ) ask "$1" "$2";;
  esac
}

############################### Ubuntu specifics #########################################
function no_ppa_exists(){
  ppa_added=`grep ^ /etc/apt/sources.list /etc/apt/sources.list.d/* | grep -v list.save | grep -v deb-src | grep deb | grep $1 | wc -l`
  [ $ppa_added == 0 ];
}

function add_ppa(){
  sudo add-apt-repository ppa:$1 -y
  apt_update

  return 0
}

function apt_update(){
  sudo apt-get update 1>/dev/null
}

function apt_install(){
  sudo apt-get install -y $@

  return 0
}

function pac_update(){
  sudo pacman -Syu --noconfirm

  return 0
}

function pac_install(){
  sudo pacman -S --needed --noconfirm $@

  return 0
}

function yay_install(){
  yay -S --needed --noconfirm $@ --mflags "--nocheck"

  return 0
}

function yay_update(){
  yay -Syu --noconfirm

  return 0
}

function pip3_install(){
  sudo -H pip3 install $@

  return 0
}

function sudo_rule(){
  INFO "$USER ALL = NOPASSWD: $@" | sudo tee -a /etc/sudoers

  return 0
}

############################ manual install items ########################################

# setup fzf
function fzf_install(){
  mkdir -p $HOME/.local/bin
  rm -rf $HOME/.fzf
  git clone --depth 1 https://github.com/junegunn/fzf.git $HOME/.fzf
  cd $HOME/.fzf
  ./install --bin
  cp bin/* $HOME/.local/bin/
  cd -
}

# install lazygit
function lazygit_install(){
  LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | \grep -Po '"tag_name": "v\K[^"]*')
  cd /tmp
  curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
  tar xf lazygit.tar.gz lazygit
  install lazygit $HOME/.local/bin
  cd -
}

# install lunarvim
function lunarvim_install(){
  INFO "Installing LunarVIM..."
  NPM_CONFIG_PREFIX=$HOME/npm-global

  # ensure there are no failures due to installing python packages
  python3 -m pip config set global.break-system-packages true

  (curl -sSL https://raw.githubusercontent.com/LunarVim/LunarVim/release-1.4/neovim-0.9/utils/installer/install.sh | LV_BRANCH='release-1.4/neovim-0.9' bash -s -- -y) | true
}

# setup starship
function starship_install(){
  INFO "Installing starship..."
  curl -sS https://starship.rs/install.sh -o starship.sh
  chmod +x starship.sh
  ./starship.sh -y --bin-dir $HOME/.local/bin
  rm -f starship.sh
}

# install the various zsh components
function zsh_extras(){
  INFO "Setting up zsh extras..."
  # install zgenom
  [ ! -d $HOME/.zgenom ] && git clone https://github.com/jandamm/zgenom.git ${HOME}/.zgenom

  # install zoxide
  curl -sS https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash

  # install fonts
  mkdir -p $HOME/.local/bin
  curl -fsSL https://raw.githubusercontent.com/getnf/getnf/main/install.sh | bash
  $HOME/.local/bin/getnf -i DejaVuSansMono,DroidSansMono,Hack,Recursive,RobotoMono | true  # don't fail on fonts
}
