#!/bin/bash
set -e

sudo apt install dialog git vim

# get the version of ubuntu
codename=`lsb_release -a 2>/dev/null | grep Codename | awk -F ' ' '{print $2}'`
release=`lsb_release -a 2>/dev/null | grep Release | awk -F ' ' '{print $2}'`

declare -a DOTFILES=( .bashrc .bash_exports .editorconfig
                      .gitconfig .gitexcludes
                      texmf .vim .vimrc .Xmodmap
                      .Xresources .xsessionrc private/.bash_aliases )

DOTFILES_DIR=$HOME/dotfiles

############################# grab dotfiles ####################################
# dotfiles already exist since I am running this script!
# git clone git@github.com:erichlf/dotfiles.git
(cd $DOTFILES_DIR && git submodule init && git submodule update)

cmd=(dialog --backtitle "system setup" --menu "Welcome to Erich's system
setup.\nWhat would you like to do?" 14 50 16)

options=(1  "Fresh system setup"
         2  "Create symbolic links"
         3  "Update dotfile submodules"
         4  "Install development utilities"
         5  "Install LaTeX"
         6  "Install development framework"
         7  "Install python3 framework"
         8  "Install base system"
         9 "Install Seegrid tools"
         10 "Setup Internet Connections"
         11 "Install my extras"
         12 "Remove crapware"
         13 "Update system"
         14 "sudo rules")

choices=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)

function run_me() {
  bash $DOTFILES_DIR/systemSetup.sh
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
  sudo apt update 1>/dev/null
}

function apt_install(){
  sudo apt install -y $@

  return 0
}

function pip3_install(){
  sudo -H pip3 install $@

  return 0
}

function sudo_rule(){
  echo "$USER ALL = NOPASSWD: $@" | sudo tee -a /etc/sudoers

  return 0
}

#create my links
function sym_links(){
  cd $HOME
  for FILE in ${DOTFILES[@]}; do ln -sf $DOTFILES_DIR/$FILE $HOME/; done
  cd $DOTFILES_DIR

  return 0
}

function update_submodules(){
  cd $DOTFILES_DIR
  git submodule update --init --recursive
  cd $DOTFILES_DIR

  return 0
}

# install python3 development
function python3_framework(){
  apt_install python3-setuptools python3-scipy python3-numpy python3-matplotlib python3-ipython python3-pip
  # need dnspython and unrar are needed by calibre
  pip3_install wheel dnspython unrar pylint

  return 0
}

############################# developer tools ##################################
# install development utilities
function dev_utils(){
  #latest git
  if no_ppa_exists git-core
  then
      add_ppa git-core/ppa
  fi

  curl -s https://packagecloud.io/install/repositories/slacktechnologies/slack/script.deb.sh | sudo bash

  apt_update

  apt_install slack-desktop meld openssh-server editorconfig global git \
              git-completion screen build-essential cmake powerline \
              fonts-powerline freeglut3-dev libopencv-dev \
              libopencv-contrib-dev libopencv-photo-dev

  python3_framework

  cd $HOME/.config/
  ln -sf $DOTFILES_DIR/powerline
  cd $DOTFILES_DIR

  pip3_install powerline-gitstatus

  sudo update-alternatives --config editor

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

# install my own development environment
function dev_framework(){
  apt_install cmake gcc g++ clang ctags cscope

  return 0
}

############################# my base system ###################################
#bikeshed contains utilities such as purge-old-kernels
function base_sys(){
  cd $HOME
  if no_ppa_exists alessandro-strada
  then
      add_ppa alessandro-strada/ppa
  fi
  apt_install wget curl htop cifs-utils nfs-common autofs google-drive-ocamlfuse gnome-tweak-tool

  if [ ! -d /media/NFS ]; then
    sudo mkdir /media/NFS
  fi
  if [ ! -d /media/Google ]; then
    sudo mkdir /media/Google
  fi

  sudo cp $DOTFILES_DIR/gdfuse /usr/bin/
  sudo cp $DOTFILES_DIR/auto.master /etc/
  sudo cp $DOTFILES_DIR/private/auto.nfs /etc/
  sudo cp $DOTFILES_DIR/private/auto.gdrive /etc/
  ln -s -f /media/NFS/Media-NAS
  ln -s -f /media/Google

  sudo_rule /usr/bin/google-drive-ocamlfuse

  sudo systemctl start autofs

  cd $DOTFILES_DIR

  return 0
}

######################### internet connections #################################
function network_connections() {
  apt_install network-manager-openvpn network-manager-openvpn-gnome network-manager-vpnc
  sudo /etc/init.d/networking restart

  for CONNECTION in $DOTFILES_DIR/private/system-connections/*; do
      sudo cp "$CONNECTION" /etc/NetworkManager/system-connections/
      sudo chown root:root "/etc/NetworkManager/system-connections/$(basename $CONNECTION)"
  done
}

################################ seegrid #######################################
function seegrid(){
  apt_update
  apt_install docker.io python3-yaml python3-git git-lfs rabbitmq-server

  sudo usermod -a -G docker $USERNAME
  sudo systemctl daemon-reload
  sudo systemctl restart docker

  newgrp docker

  sudo curl -L "https://github.com/docker/compose/releases/download/1.24.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
  sudo chmod +x /usr/local/bin/docker-compose


  return 0
}

################################ extras ########################################
function extras(){
  if [ ! -f /etc/apt/sources.list.d/google.list ]; then
    wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
    sudo sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list'
  fi

  apt_update
  apt_install chromium-browser chrome-gnome-shell

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
  sudo apt-get -y dist-upgrade

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
       dev_framework
       python3_framework
       dev_utils
       network_connections
       extras
       seegrid
       crapware
       update_sys
       sudo apt autoremove
       sudo_rules
       run_me
       ;;
    2)
       sym_links
       run_me
       ;;
    3)
       update_submodules
       run_me
       ;;
    4)
       dev_utils
       run_me
       ;;
    5)
       LaTeX
       run_me
       ;;
    6)
       dev_framework
       run_me
       ;;
    7)
       python3_framework
       run_me
       ;;
    8)
       base_sys
       run_me
       ;;
    9)
       seegrid
       run_me
       ;;
    10)
       network_connections
       run_me
       ;;
    11)
       extras
       run_me
       ;;
    12)
       crapware
       run_me
       ;;
    13)
       update_sys
       run_me
       ;;
    14)
       sudo_rules
       run_me
       ;;
  esac
done
