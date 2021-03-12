#!/bin/bash
set -e

sudo apt install dialog git software-properties-common

# get the version of ubuntu
codename=`lsb_release -a 2>/dev/null | grep Codename | awk -F ' ' '{print $2}'`
release=`lsb_release -a 2>/dev/null | grep Release | awk -F ' ' '{print $2}'`

declare -a DOTFILES=( .bashrc .bash_exports 
                      .gitconfig .gitexcludes
                      .spacemacs .emacs.d
                      private/.bash_aliases
		      flexget )

DOTFILES_DIR=$HOME/dotfiles

############################# grab dotfiles ####################################
# dotfiles already exist since I am running this script!
# git clone git@github.com:erichlf/dotfiles.git
(cd $DOTFILES_DIR && git submodule update --init --recursive)

cmd=(dialog --backtitle "system setup" --menu "Welcome to Erich's system
setup.\nWhat would you like to do?" 14 50 16)

options=(1  "Fresh system setup"
         2  "Create symbolic links"
	 3  "Install developer tools"
         4  "Install base system"
	 5  "Update system"
	 6  "Add sudo rules")

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

############################# developer tools ##################################
# install development utilities
function dev_tools(){
  apt_install python3-pip

  #latest git
  if no_ppa_exists git-core
  then
      add_ppa git-core/ppa
  fi

  # add repo for latest emacs
  if no_ppa_exists kelleyk
  then
    add_ppa kelleyk/emacs
  fi

  apt_update

  apt_install emacs27 git git-completion powerline \
              fonts-powerline xclip

  # install source code pro fonts
  mkdir -p /tmp/adodefont
  cd /tmp/adodefont
  wget -q --show-progress -O source-code-pro.zip https://github.com/adobe-fonts/source-code-pro/archive/2.030R-ro/1.050R-it.zip
  unzip -q source-code-pro.zip -d source-code-pro
  fontpath=/usr/local/share/fonts/
  sudo cp -v source-code-pro/*/OTF/*.otf $fontpath
  fc-cache -f
  rm -rf source-code-pro{,.zip}
  cd $DOTFILES_DIR

  # setup link for powerline
  cd $HOME/.config/
  ln -sf $DOTFILES_DIR/powerline

  # install git-subrepo
  git clone https://github.com/ingydotnet/git-subrepo

  cd $DOTFILES_DIR

  pip3_install powerline-gitstatus

  sudo update-alternatives --config editor

  apt_install gnupg ca-certificates

  cd $DOTFILES_DIR

  return 0
}

############################# my base system ###################################
#bikeshed contains utilities such as purge-old-kernels
function base_sys(){
  cd $HOME

  # setup repo for 1password
  sudo apt-key --keyring /usr/share/keyrings/1password.gpg adv --keyserver keyserver.ubuntu.com \
       --recv-keys 3FEF9748469ADBE15DA7CA80AC2D62742012EA22
  echo 'deb [arch=amd64 signed-by=/usr/share/keyrings/1password.gpg] https://downloads.1password.com/linux/debian edge main' | sudo tee /etc/apt/sources.list.d/1password.list

  if no_ppa_exists alessandro-strada
  then
      add_ppa alessandro-strada/ppa
  fi

  if no_ppa_exists bashtop-monitor
  then
     add_ppa bashtop-monitor/bashtop
  fi

  apt_install wget curl bashtop iftop cifs-utils nfs-common autofs google-drive-ocamlfuse \
              pass

  sudo cp $DOTFILES_DIR/gdfuse /usr/bin/
  sudo cp $DOTFILES_DIR/auto.master /etc/
  sudo cp $DOTFILES_DIR/private/auto.nfs /etc/
  sudo cp $DOTFILES_DIR/private/auto.gdrive /etc/

  sudo_rule /usr/bin/google-drive-ocamlfuse

  sudo systemctl start autofs

  pip3_install flexget transmissionrpc

  cd /etc/lib/systemd/system/
  ln -sf $DOTFILES_DIR/flexget/flexget.service

  sudo systemctl enable flexget
  sudo systemctl start flexget

  cd $DOTFILES_DIR

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
       dev_tools
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
    6)
       sudo_rules
       run_me
       ;;
  esac
done
