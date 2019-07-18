#!/bin/bash
set -e

sudo apt install dialog git vim

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
(cd $DOTFILES_DIR && git submodule init && git submodule update)

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
         9  "Setup Internet Connections"
         10 "Install CRL development framework"
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
  for FILE in ${DOTFILES[@]}; do ln -sf $DOTFILES_DIR/$FILE $HOME/$(basename $FILE); done
  cd $DOTFILES_DIR

  return 0
}

function update_submodules(){
  cd $DOTFILES_DIR
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

  apt_update

  apt_install meld openssh-server editorconfig global git \
              git-completion screen build-essential cmake powerline \
              fonts-powerline freeglut3-dev libopencv-dev \
              libopencv-contrib-dev libopencv-photo-dev

  wget https://downloads.slack-edge.com/linux_releases/slack-desktop-3.3.8-amd64.deb
  apt_install ./slack-desktop-*.deb
  rm slack-desktop-*.deb

  cd $HOME/.config/
  ln -sf $DOTFILES_DIR/powerline
  cd $DOTFILES_DIR

  pip_install powerline-gitstatus

  sudo update-alternatives --config editor

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
  apt_install cmake gcc g++ clang ctags # libparpack2-dev

  return 0
}

# install python development
function python_framework(){
  apt_install python-setuptools python-scipy python-numpy python-matplotlib ipython python-pip
  # need dnspython and unrar are needed by calibre
  pip_install wheel dnspython unrar

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
  apt_install wget curl htop cifs-utils nfs-common autofs google-drive-ocamlfuse

  if [ ! -d /media/NFS ]; then
    sudo mkdir /media/NFS
  fi
  if [ ! -d /media/CRL ]; then
    sudo mkdir /media/CRL
  fi
  if [ ! -d /media/Google ]; then
    sudo mkdir /media/Google
  fi

  sudo cp $DOTFILES_DIR/gdfuse /usr/bin/
  sudo cp $DOTFILES_DIR/private/auto.nfs /etc/
  sudo cp $DOTFILES_DIR/private/auto.crl /etc/
  sudo cp $DOTFILES_DIR/private/auto.gdrive /etc/
  ln -s -f /media/NFS/Media-NAS
  ln -s -f /media/CRL
  ln -s -f /media/Google

  echo '/media/NFS /etc/auto.nfs' \
    | sudo tee /etc/auto.master

  sudo_rule /usr/bin/google-drive-ocamlfuse

  sudo systemctl start autofs

  cd $DOTFILES_DIR

  return 0
}

######################### internet connections #################################
function network_connections() {
    for CONNECTION in $DOTFILES_DIR/private/system-connections/*; do
        sudo cp "$CONNECTION" /etc/NetworkManager/system-connections/
        sudo chown root:root "/etc/NetworkManager/system-connections/$(basename $CONNECTION)"
    done
}


############################ crl framework #####################################
function crl_framework() {
  # install ROS
  sudo sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'
  sudo apt-key adv --keyserver 'hkp://keyserver.ubuntu.com:80' --recv-key C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654

  apt_update
  apt_install ros-melodic-desktop-full python-rosinstall python-rosdep \
              mercurial openvpn libturbojpeg-dev libgstreamer1.0-dev \
              libgstreamer-plugins-base1.0-dev
}

################################ extras ########################################
function extras(){
  apt_update
  apt_install chromium-browser snapd
  sudo snap install vlc

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
  sudo apt -y dist-upgrade

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
       python_framework
       dev_utils
       LaTeX
       crl_framework
       network_connections
       extras
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
       python_framework
       run_me
       ;;
    8)
       base_sys
       run_me
       ;;
    9)
       network_connections
       run_me
       ;;
    10)
       crl_framework
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
