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

cmd=(dialog --backtitle "system setup" --menu "Welcome to Erich's system
setup.\nWhat would you like to do?" 14 50 16)

options=(1  "Fresh system setup"
         2  "Create symbolic links"
         3  "Install development tools"
         4  "Install base system"
         5  "Install my extras"
         6  "Install TU Delft tools"
         7  "Latitude 7440 Hacks"
         8  "Install LaTeX"
         9  "Remove crapware"
        10  "Update system"
        11  "sudo rules")

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
  stow -v --adopt --dir $DOTFILES_DIR --target $HOME --restow my-home
  stow -v --adopt --dir $DOTFILES_DIR/private/ --target $HOME/.ssh --restow .ssh
  mkdir -p $HOME/.config
  stow -v --adopt --dir $DOTFILES_DIR --target $HOME/.config/ --restow starship
  # this relies on my-home being stowed already
  stow -v --adopt --dir $DOTFILES_DIR --target $HOME/.oh-my-zsh/custom/plugins/ --restow zsh
  # if the adopt made a local change then undo that
  git checkout HEAD -- starship zsh my-home private

  return 0
}

############################# my base system ###################################
#bikeshed contains utilities such as purge-old-kernels
function base_sys(){
  cd $HOME

  apt_install \
    cifs-utils \
    curl \
    fzf \
    gnome-tweaks \
    iftop \
    nfs-common \
    tmux \
    wget \
    zsh 

  chsh -s /usr/bin/zsh

  curl -sSL https://get.rvm.io | bash

  snap_install btop

  # setup starship
  wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/DroidSansMono.zip
  unzip DroidSansMono.zip -d $HOME/.fonts
  fc-cache -fv
  rm -f DroidSansMono.zip

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

  return 0
}

############################# developer tools ##################################
# install development utilities
function dev_tools(){
  if [ ! -d "$HOME/workspace" ]; then
    mkdir "$HOME/workspace"
  fi

  apt_install \
    build-essential \
    clang \ 
    clang-format \
    clang-tools \
    cmake \
    gcc \
    g++ \
    python3-dev \
    python3-setuptools \
    python3-scipy \ 
    python3-numpy \
    python3-matplotlib \
    python3-ipython \
    python3-pip

  # need dnspython and unrar are needed by calibre
  pip3_install \
    dnspython \
    pylint \
    unrar \
    wheel

  if no_ppa_exists linuxuprising
  then
    add_ppa linuxuprising/guake
  fi

  apt_install \
    freeglut3-dev \
    git-completion 
    global \
    libtool-bin \
    guake \
    meld \
    openssh-server \
    vim \
    xclip

  # restore guake config
  guake --restore-preferences guake.conf

  # install source code pro fonts
  mkdir -p /tmp/adobefont
  cd /tmp/adobefont
  wget -q --show-progress -O source-code-pro.zip https://github.com/adobe-fonts/source-code-pro/archive/2.030R-ro/1.050R-it.zip
  unzip -q source-code-pro.zip -d source-code-pro
  fontpath=/usr/local/share/fonts/
  sudo cp -v source-code-pro/*/OTF/*.otf $fontpath
  fc-cache -f
  rm -rf source-code-pro{,.zip}
  cd $DOTFILES_DIR

  cd $DOTFILES_DIR

  sudo update-alternatives --config editor

  apt_install \ 
    gnupg \
    ca-certificates

  apt_update
  apt_install \
    docker.io \
    docker-compose \
    git-lfs \
    python3-git \
    python3-yaml

  sudo usermod -a -G docker $USER
  sudo systemctl daemon-reload
  sudo systemctl restart docker

  newgrp docker

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

  wget -q https://packages.microsoft.com/keys/microsoft.asc -O- | sudo apt-key add -
  sudo add-apt-repository "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main"
  apt_install code

  echo "net.core.rmem_max=26214400" | sudo tee /etc/sysctl.d/10-udp-buffer-sizes.conf
  echo "net.core.rmem_default=26214400" | sudo tee -a /etc/sysctl.d/10-udp-buffer-sizes.conf
}

function tudelft(){
  wget -O- https://app.eduvpn.org/linux/v4/deb/app+linux@eduvpn.org.asc | gpg --dearmor | sudo tee /usr/share/keyrings/eduvpn-v4.gpg >/dev/null
  echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/eduvpn-v4.gpg] https://app.eduvpn.org/linux/v4/deb/ jammy main" | sudo tee /etc/apt/sources.list.d/eduvpn-v4.list
  apt_update
  apt_install eduvpn-client

  # setup sam xl mounts
  sudo cp -f $DOTFILES_DIR/private/auto.master /etc/
  sudo cp -f $DOTFILES_DIR/private/auto.tudeflt /etc/

  apt_install \
    davfs2 \
    autofs

  # it is assumed that credentials are placed in /etc/davfs2/secrets
  sudo systemctl restart autofs

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

################################ extras ########################################
function extras(){
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

######################## remove things I never use #############################
function crapware(){
  sudo apt remove -y transmission-gtk thunderbird \

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
       dev_tools
       extras
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
       dev_tools
       run_me
       ;;
    4)
       base_sys
       run_me
       ;;
    5)
       extras
       run_me
       ;;
    6)
       tudelft
       run_me
       ;;
    7)
       latitude_7440
       run_me
       ;;
    8)
       LaTeX
       run_me
       ;;
    9)
       crapware
       run_me
       ;;
    10)
       update_sys
       run_me
       ;;
    11)
       sudo_rules
       run_me
       ;;
  esac
done
