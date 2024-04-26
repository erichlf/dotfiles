#!/bin/bash
set -e

THIS=$0

sudo apt install -y dialog git stow

# get the version of ubuntu
codename=`lsb_release -a 2>/dev/null | grep Codename | awk -F ' ' '{print $2}'`
release=`lsb_release -a 2>/dev/null | grep Release | awk -F ' ' '{print $2}'`

DOTFILES_DIR=$HOME/dotfiles

############################# grab dotfiles ####################################
# dotfiles already exist since I am running this script!
# git clone git@github.com:erichlf/dotfiles.git
(cd $DOTFILES_DIR && git submodule update --init --recursive)

cmd=( \
  dialog \
  --clear \
  --cancel-label "Exit" \
  --backtitle "system setup" \
  --menu "Welcome to Erich's system setup.\nWhat would you like to do?" \
  14 50 16 \
)

options=(1  "Fresh system setup"
         2  "Create symbolic links"
         2  "Install base system"
         4  "Install TU Delft tools"
         5  "Latitude 7440 Hacks"
         6  "Install LaTeX"
         7  "Remove crapware"
         8  "Update system"
         9  "sudo rules")

choices=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)

function run_me() {
  bash $THIS
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

function no_ppa_exists(){
  ppa_added=`grep ^ /etc/apt/sources.list /etc/apt/sources.list.d/* | grep -v list.save | grep -v deb-src | grep deb | grep $1 | wc -l`
  [ $ppa_added == 0 ];
}

function add_ppa(){
  sudo add-apt-repository ppa:$1 -y

  return 0
}

function apt_update(){
  sudo apt-get update 1>/dev/null
}

function apt_install(){
  sudo apt-get install -y $@

  return 0
}

function pip3_install(){
  sudo -H pip3 install $@

  return 0
}

function snap_install(){
  sudo snap install $@

  return 0
}

function sudo_rule(){
  echo "$USER ALL = NOPASSWD: $@" | sudo tee -a /etc/sudoers

  return 0
}

#create my links
function sym_links(){
  mkdir -p $HOME/.config
  stow -v --dotfiles --adopt --dir $DOTFILES_DIR --target $HOME --restow my-home
  stow -v --adopt --dir $DOTFILES_DIR/private/ --target $HOME/.ssh --restow .ssh
  stow -v --adopt --dir $DOTFILES_DIR --target $HOME/.config/ --restow config
  # if the adopt made a local change then undo that

  return 0
}

############################# my base system ###################################
#bikeshed contains utilities such as purge-old-kernels
function base_sys(){
  cd $HOME

  apt_install \
    btop \
    cifs-utils \
    curl \
    fzf \
    gnome-tweaks \
    iftop \
    nfs-common \
    tmux \
    wget \
    zsh 

  curl -sS https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash

  chsh -s /usr/bin/zsh

  # tool to figure out why my last command didn't work
  snap_install thefuck --beta --classic

  curl -sSL https://get.rvm.io | bash

  # install fonts
  curl -fsSL https://raw.githubusercontent.com/getnf/getnf/main/install.sh | bash
  $HOME/.local/bin/getnf -i DejaVuSansMono,DroidSansMono,Hack,Recursive,RobotoMono

  # setup starship
  curl -sS https://starship.rs/install.sh -o starship.sh 
  chmod +x starship.sh
  mkdir -p $HOME/.local/bin
  ./starship.sh --bin-dir $HOME/.local/bin/ -y
  rm -f starship.sh

  apt_install \
    network-manager-openvpn \
    network-manager-openvpn-gnome \
    network-manager-vpnc
  # sudo /etc/init.d/networking restart

  cd $DOTFILES_DIR

  if [ ! -d "$HOME/workspace" ]; then
    mkdir "$HOME/workspace"
  fi

  apt_install \
    build-essential \
    clang \ 
    clang-format \
    clang-tools \
    cmake \
    g++ \
    gcc \
    python3-dev \
    python3-ipython \
    python3-matplotlib \
    python3-numpy \
    python3-pip
    python3-scipy \ 
    python3-setuptools \

  # need dnspython and unrar are needed by calibre
  pip3_install \
    autoflake \
    black \
    flake8 \
    isort \
    pep257 \
    pylint \
    wheel \
    yapf

  if no_ppa_exists linuxuprising
  then
    add_ppa linuxuprising/guake
  fi

  if no_ppa_exists ppa-verse
  then
    add_ppa ppa-verse/neovim
  fi

  apt_install \
    freeglut3-dev \
    git-completion 
    global \
    guake \
    libtool-bin \
    meld \
    neovim \
    openssh-server \
    xclip

  # install zgen
  [ ! -d $HOME/.zgen ] && git clone https://github.com/tarjoilija/zgen.git ${HOME}/.zgen

  # install lunarvim
  curl -sSL https://raw.githubusercontent.com/LunarVim/LunarVim/release-1.3/neovim-0.9/utils/installer/install.sh | LV_BRANCH='release-1.3/neovim-0.9' bash -s -- -y 

  # install lazygit
  LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | \grep -Po '"tag_name": "v\K[^"]*')
  cd /tmp
  curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
  tar xf lazygit.tar.gz lazygit
  install lazygit $HOME/.local/bin
  cd -

  # restore guake config
  guake --restore-preferences guake.conf

  sudo update-alternatives --config editor

  apt_install \ 
    gnupg \
    ca-certificates

  apt_update
  apt_install \
    docker-compose \
    docker.io \
    git-lfs \
    golang-go \ # used by gitlab nvim plugin
    nodejs \
    python3-git \
    python3-venv \
    python3-yaml

  snap_install --edge chafa # needed by telescope-media-files 
  sudo usermod -a -G docker $USER
  sudo systemctl daemon-reload
  sudo systemctl restart docker

  newgrp docker
  
  # devcontainer cli
  npm install -g @devcontainers/cli
  # treesitter for vim
  npm install -g neovim tree-sitter

  # install vscode
  apt_install \
    apt-transport-https \
    software-properties-common 
  wget -q https://packages.microsoft.com/keys/microsoft.asc -O- | sudo apt-key add -
  sudo add-apt-repository "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main"
  apt_install code

  # install vs code and git-credential-manager for using devcontainer and development
  wget "https://github.com/git-ecosystem/git-credential-manager/releases/download/v2.3.2/gcm-linux_amd64.2.3.2.deb" -O /tmp/gcmcore.deb
  sudo dpkg -i /tmp/gcmcore.deb
  git-credential-manager configure

  echo "net.core.rmem_max=26214400" | sudo tee /etc/sysctl.d/10-udp-buffer-sizes.conf
  echo "net.core.rmem_default=26214400" | sudo tee -a /etc/sysctl.d/10-udp-buffer-sizes.conf

  cd /tmp

  apt_update
  apt_install chrome-gnome-shell

  wget -c https://downloads.vivaldi.com/stable/vivaldi-stable_6.6.3271.45-1_amd64.deb
  sudo dpkg -i vivaldi-stable*.deb

  curl -sS https://downloads.1password.com/linux/keys/1password.asc | sudo gpg --dearmor --output /usr/share/keyrings/1password-archive-keyring.gpg
  echo 'deb [arch=amd64 signed-by=/usr/share/keyrings/1password-archive-keyring.gpg] https://downloads.1password.com/linux/debian/amd64 stable main' | sudo tee /etc/apt/sources.list.d/1password.list
  sudo mkdir -p /etc/debsig/policies/AC2D62742012EA22/
  curl -sS https://downloads.1password.com/linux/debian/debsig/1password.pol | sudo tee /etc/debsig/policies/AC2D62742012EA22/1password.pol
  sudo mkdir -p /usr/share/debsig/keyrings/AC2D62742012EA22
  curl -sS https://downloads.1password.com/linux/keys/1password.asc | sudo gpg --dearmor --output /usr/share/debsig/keyrings/AC2D62742012EA22/debsig.gpg

  apt_update
  apt_install 1password

  # add 1password support to vivaldi
  sudo mkdir -p /etc/1password
  echo "vivaldi-bin" | sudo tee /etc/1password/custom_allowed_browsers 
  sudo chown root:root /etc/1password/custom_allowed_browsers
  sudo chmod 755 /etc/1password/custom_allowed_browsers

  # install signal desktop
  wget -O- https://updates.signal.org/desktop/apt/keys.asc | gpg --dearmor > signal-desktop-keyring.gpg
  cat signal-desktop-keyring.gpg | sudo tee /usr/share/keyrings/signal-desktop-keyring.gpg > /dev/null
  echo 'deb [arch=amd64 signed-by=/usr/share/keyrings/signal-desktop-keyring.gpg] https://updates.signal.org/desktop/apt xenial main' |\
    sudo tee /etc/apt/sources.list.d/signal-xenial.list
  apt_update 
  apt_install signal-desktop

  cd $DOTFILES_DIR
  return 0
}

function tudelft(){
  snap_install teams-for-linux

  wget -O- https://app.eduvpn.org/linux/v4/deb/app+linux@eduvpn.org.asc | gpg --dearmor | sudo tee /usr/share/keyrings/eduvpn-v4.gpg >/dev/null
  echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/eduvpn-v4.gpg] https://app.eduvpn.org/linux/v4/deb/ jammy main" | sudo tee /etc/apt/sources.list.d/eduvpn-v4.list
  apt_update
  apt_install eduvpn-client

  return 0
}

# install latex
function LaTeX(){
  cd /tmp
  wget https://github.com/scottkosty/install-tl-ubuntu/raw/master/install-tl-ubuntu
  sudo chmod +x install-tl-ubuntu
  sudo ./install-tl-ubuntu

  PATH=/usr/local/texlive/20*/bin/x86_64-linux:$PATH
  tlmgr install arara

  cd $DOTFILES_DIR

  return 0
}

########################## Computer Specific ####################################
function latitude_7440(){
  # install driver for fingerprint scanner, enable it, and enroll left and right
  # index fingers
  wget "http://dell.archive.canonical.com/updates/pool/public/libf/libfprint-2-tod1-broadcom/libfprint-2-tod1-broadcom_5.12.018-0ubuntu1~22.04.01_amd64.deb" -O /tmp/broadcom-fingerprint.deb
  sudo install libfprint-2-tod1 fprintd libpam-frintd
  sudo dpkg -i /tmp/broadcom-fingerprint.deb
  sudo fprintd-enroll -f left-index-finger
  sudo fprintd-enroll -f right-index-finger
  sudo pam-auth-update --enable fprintd

  # fix keyboard function keys
  sudo apt reinstall -y libgdk-pixbuf2.0-0
  echo 0 | sudo tee /sys/module/hid_apple/parameters/fnmode
  echo "options hid_apple fnmode=0" | sudo tee -a /etc/modprobe.d/hid_apple.conf
  sudo update-initramfs -u
}

######################## remove things I never use #############################
function crapware(){
  sudo apt remove -y \
    thunderbird \ 
    transmission-gtk \

  return 0
}

########################## update and upgrade ##################################
function update_sys(){
  apt_update
  sudo apt-get -y upgrade

  return 0
}

############################## annoyances ######################################
function sudo_rules(){
  sudo_rule /sbin/shutdown
  sudo_rule /sbin/reboot

  return 0
}

for choice in $choices
do
  case $choice in
    1)
       sym_links
       base_sys
       crapware
       update_sys
       sudo apt -y autoremove
       sudo_rules
       run_me
       ;;
    2)
       sym_links
       run_me
       ;;
    3)
       base_sys
       run_me
       ;;
    4)
       tudelft
       run_me
       ;;
    5)
       latitude_7440
       run_me
       ;;
    6)
       LaTeX
       run_me
       ;;
    7)
       crapware
       run_me
       ;;
    8)
       update_sys
       run_me
       ;;
    9)
       sudo_rules
       run_me
       ;;
  esac
done
