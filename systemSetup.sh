#!/bin/bash
set -e

sudo apt-get install dialog git

# get the version of ubuntu
codename=`lsb_release -a 2>/dev/null | grep Codename | awk -F ' ' '{print $2}'`
release=`lsb_release -a 2>/dev/null | grep Release | awk -F ' ' '{print $2}'`

declare -a DOTFILES=( .bashrc .bash_exports .commacd.bash .editorconfig
                      .gitconfig .gitexcludes texmf .vim .vimrc .Xmodmap
                      .Xresources .xsessionrc private/.bash_aliases )

DOTFILES_DIR=$HOME/dotfiles

############################# grab dotfiles ####################################
# dotfiles already exist since I am running this script!
# git clone git@github.com:erichlf/dotfiles.git
(cd $HOME/dotfiles && git submodule init && git submodule update)

cmd=(dialog --backtitle "system setup" --menu "Welcome to Erich's system
setup.\nWhat would you like to do?" 14 50 16)

options=(1  "Fresh system setup"
         2  "Create symbolic links"
         3  "Update dotfile submodules"
         4  "Install development utilities"
         5  "Install LaTeX"
         6  "Install development framework"
         7  "Install python framework"
         8  "Install base system"
         9  "Install CRL development framework"
         10 "Install my extras"
         11 "Remove crapware"
         12 "Update system"
         13 "sudo rules")

choices=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)

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

function get_update(){
  sudo apt-get update 1>/dev/null
}

function get_install(){
  sudo apt-get install -y $@

  return 0
}

function pip_install(){
  sudo -H pip install $@

  return 0
}

function sudo_rule(){
  echo "$USER ALL = NOPASSWD: $@" | sudo tee -a /etc/sudoers

  return 0
}

#create my links
function sym_links(){
  cd $HOME
  for FILE in ${DOTFILES[@]}; do ln -sf $HOME/dotfiles/$FILE $HOME/$(basename $FILE); done
  cd $DOTFILES_DIR

  return 0
}

function update_submodules(){
  cd $HOME/dotfiles
  git submodule update --init --recursive
  cd $DOTFILES_DIR

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

  get_update

  get_install vim openssh-server editorconfig global git \
              git-completion screen build-essential cmake powerline \
              fonts-powerline freeglut3-dev libopencv-dev \
              libopencv-contrib-dev libopencv-photo-dev

  cd $HOME/.config/
  ln -sf $DOTFILES_DIR/powerline
  cd $DOTFILES_DIR

  pip_install powerline-gitstatus

  return 0
}

# install latex
function LaTeX(){
  cd /tmp
  wget https://github.com/scottkosty/install-tl-ubuntu/raw/master/install-tl-ubuntu
  sudo ./install-tl-ubuntu

  tlmgr install arara

  cd $DOTFILES_DIR

  return 0
}

# install my own development environment
function dev_framework(){
  get_install cmake gcc g++ clang ctags # libparpack2-dev

  return 0
}

# install python development
function python_framework(){
  get_install python-setuptools python-scipy python-numpy python-matplotlib ipython python-pip
  # need dnspython and unrar are needed by calibre
  pip_install wheel dnspython unrar

  return 0
}

############################# my base system ###################################
#bikeshed contains utilities such as purge-old-kernels
function base_sys(){
  cd $HOME
  get_install wget curl htop cifs-utils nfs-common autofs

  if [ ! -d /media/NFS ]; then
    sudo mkdir /media/NFS
  fi

  sudo cp $HOME/dotfiles/private/auto.nfs /etc/
  ln -s -f /media/NFS/Media-NAS

  echo '/media/NFS /etc/auto.nfs' \
    | sudo tee /etc/auto.master

  sudo service autofs start

  cd $DOTFILES_DIR

  return 0
}

############################ crl framework #####################################
function crl_framework() {
  # install ROS
  sudo sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'
  sudo apt-key adv --keyserver 'hkp://keyserver.ubuntu.com:80' --recv-key C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654

  get_update
  get_install ros-melodic-desktop-full python-rosinstall python-rosdep \
              mercurial openvpn
}

################################ extras ########################################
function extras(){
  get_update
  get_install chromium-browser snapd
  sudo snap install gitter-desktop bcompare

  return 0
}

######################## remove things I never use #############################
function crapware(){
  sudo apt-get remove -y transmission-gtk thunderbird \

  return 0
}

########################## update and upgrade ##################################
function update_sys(){
  get_update
  sudo apt-get -y dist-upgrade

  return 0
}

############################## annoyances ######################################
function sudo_rules(){
  sudo_rule /sbin/shutdown
  sudo_rule /sbin/reboot
  sudo_rule /usr/bin/tee brightness

  return 0
}

for choice in $choices
do
  case $choice in
    1)
       sym_links
       base_sys
       dev_framework
       python_framework
       dev_utils
       LaTeX
       crl_framework
       extras
       crapware
       update_sys
       sudo apt-get autoremove
       sudo_rules
       bash $DOTFILES_DIR/systemSetup.sh
       ;;
    2)
       sym_links
       bash $DOTFILES_DIR/systemSetup.sh
       ;;
    3)
       update_submodules
       bash $DOTFILES_DIR/systemSetup.sh
       ;;
    4)
       dev_utils
       bash $DOTFILES_DIR/systemSetup.sh
       ;;
    5)
       LaTeX
       bash $DOTFILES_DIR/systemSetup.sh
       ;;
    6)
       dev_framework
       bash $DOTFILES_DIR/systemSetup.sh
       ;;
    7)
       python_framework
       bash $DOTFILES_DIR/systemSetup.sh
       ;;
    8)
       base_sys
       bash $DOTFILES_DIR/systemSetup.sh
       ;;
    9)
       crl_framework
       bash $DOTFILE_FIR/systemSetup.sh
       ;;
    10)
       extras
       bash $DOTFILES_DIR/systemSetup.sh
       ;;
    11)
       crapware
       bash $DOTFILES_DIR/systemSetup.sh
       ;;
    12)
       update_sys
       bash $DOTFILES_DIR/systemSetup.sh
       ;;
    13)
       sudo_rules
       bash $DOTFILES_DIR/systemSetup.sh
       ;;
  esac
done
