#!/bin/bash
set -e

sudo apt install dialog git

# get the version of ubuntu
codename=`lsb_release -a 2>/dev/null | grep Codename | awk -F ' ' '{print $2}'`
release=`lsb_release -a 2>/dev/null | grep Release | awk -F ' ' '{print $2}'`

declare -a DOTFILES=( .bashrc
                      .bash_exports
                      .editorconfig
                      .emacs.d
		      .flexget
                      .gitconfig
                      .gitexcludes
                      .oh-my-zsh
                      .spacemacs
                      texmf
                      .Xmodmap
                      .Xresources .xsessionrc
                      private/.bash_aliases
                      private/.ssh/config
                      .zshrc )

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
	 5  "Update system")

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
  for FILE in ${DOTFILES[@]}; do
    echo $FILE
    DIR=$(basename $(dirname $FILE));
    echo $DIR
    if [[ "$DIR" != "$DOTFILES" && "$DIR" != "private" ]]; then
      DEST="$HOME/$DIR"
      if [ ! -d "$HOME/$DIR" ]; then
        mkdir "$HOME/$DIR";
      fi
    else
      DEST=$HOME
    fi

    ln -sf "$DOTFILES_DIR/$FILE" "$DEST/";
  done
  exit

  return 0
}

############################# developer tools ##################################
# install development utilities
function dev_tools(){
  apt_install build-essential cmake gcc g++ clang clang-format ctags cscope \

  apt_install python3-dev python3-setuptools python3-scipy python3-numpy \
              python3-matplotlib python3-ipython python3-pip

  apt_install libtool-bin emacs27 guake\
              meld openssh-server editorconfig global \
              git git-completion screen build-essential cmake powerline \
              fonts-powerline freeglut3-dev libopencv-dev \
              libopencv-contrib-dev libopencv-photo-dev xclip

  # setup link for powerline
  cd $HOME/.config/
  ln -sf $DOTFILES_DIR/powerline

  pip3_install powerline-gitstatus

  apt_install gnupg ca-certificates

  # set up coredumps
  ulimit -S -c unlimited
  sudo sed -i"" -E "s/#(\*p[:blank:]+soft[:blank:]+core[:blank:]+)0/\1unlimited" /etc/security/limits.conf
  sudo mkdir /var/coredumps
  sudo sysctl -w kernel.core_pattern=/var/coredumps/core-%e-%s-%u-%g-%p-%t

  cd $DOTFILES_DIR

  return 0
}

############################# my base system ###################################
#bikeshed contains utilities such as purge-old-kernels
function base_sys(){
  cd $HOME

  # install unifi controller
  echo 'deb https://www.ui.com/downloads/unifi/debian stable ubiquiti' | sudo tee /etc/apt/sources.list.d/100-ubnt-unifi.list
  sudo wget -O /etc/apt/trusted.gpg.d/unifi-repo.gpg https://dl.ui.com/unifi/unifi-repo.gpg

  apt_install unifi

  # install pihole
  wget -O basic-install.sh https://install.pi-hole.net
  sudo bash basic-install.sh

  apt_install wget curl iftop cifs-utils nfs-common autofs \
              pass zsh

  if [ ! -d /media/NFS ]; then
    sudo mkdir /media/NFS
  fi

  sudo cp $DOTFILES_DIR/auto.master /etc/
  sudo cp $DOTFILES_DIR/private/auto.nfs /etc/
  ln -s -f /media/NFS/Media-NAS

  sudo systemctl start autofs

  ln -s $DOTFILES_DIR/zsh2000/zsh2000.zsh-theme $DOTFILES_DIR/.oh-my-zsh/custom/themes
  ln -s $DOTFILES_DIR/zsh-autosuggestions $DOTFILES_DIR/.oh-my-zsh/custom/plugins/

  cd $DOTFILES_DIR

  pip3 install flexget libtorrent transmission-rpc

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
       update_sys
       sudo apt -y autoremove
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
       update_sys
       run_me
       ;;
  esac
done
