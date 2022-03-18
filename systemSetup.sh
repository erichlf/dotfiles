#!/bin/bash
set -e

sudo apt install dialog git

# get the version of ubuntu
codename=`lsb_release -a 2>/dev/null | grep Codename | awk -F ' ' '{print $2}'`
release=`lsb_release -a 2>/dev/null | grep Release | awk -F ' ' '{print $2}'`

declare -a DOTFILES=( .bashrc
                      .bash_exports
                      .editorconfig
                      .gitconfig
                      .gitexcludes
                      .spacemacs
                      .emacs.d
                      texmf
                      .Xmodmap
                      .Xresources .xsessionrc
                      private/.bash_aliases
                      private/.ssh/config )

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
         4  "Install LaTeX"
         5  "Install base system"
         6  "Install Seegrid tools"
         7  "Setup Internet Connections"
         8  "Install my extras"
         9  "Remove crapware"
         10 "Update system"
         11 "sudo rules")

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

  # need dnspython and unrar are needed by calibre
  pip3_install wheel dnspython unrar pylint

  if no_ppa_exists kelleyk
  then
    add_ppa kelleyk/emacs
  fi

  if no_ppa_exists linuxuprising
  then
    add_ppa linuxuprising/guake
  fi

  apt_install libtool-bin emacs27 guake\
              meld openssh-server editorconfig global \
              git git-completion screen build-essential cmake powerline \
              fonts-powerline freeglut3-dev libopencv-dev \
              libopencv-contrib-dev libopencv-photo-dev xclip

  # setup links for google-calendar plugin
  cd $DOTFILES_DIR/.emacs.d/private/
  ln -sf $DOTFILES_DIR/google-calendar
  # setup links for snippets
  cd $DOTFILES_DIR/.emacs.d/private/snippets
  for S in $DOTFILES_DIR/snippets/*
  do
    ln -sf $S
  done

  # setup emacs daemon
  mkdir -p $HOME/.local/share/applications/
  ln -sf $DOTFILES_DIR/emacsclient.desktop $HOME/.local/share/applications/emacsclient.desktop
  ln -sf /usr/share/emacs/*/etc/emacs.icon $HOME/.local/share/applications/emacs.icon
  mkdir -p $HOME/.config/systemd/user
  ln -sf $DOTFILES_DIR/emacs.service $HOME/.config/systemd/user/emacs.service
  systemctl --user enable --now emacs
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
  [ ! -d "$HOME/.config/git-subrepo" ] && git clone https://github.com/ingydotnet/git-subrepo

  cd $DOTFILES_DIR

  pip3_install powerline-gitstatus

  sudo update-alternatives --config editor

  apt_install gnupg ca-certificates

  cd $DOTFILES_DIR

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

############################# my base system ###################################
#bikeshed contains utilities such as purge-old-kernels
function base_sys(){
  cd $HOME

  snap_install 1password

  apt_install wget curl iftop cifs-utils nfs-common autofs gnome-tweak-tool \
              pass

  snap_install btop

  if [ ! -d /media/NFS ]; then
    sudo mkdir /media/NFS
  fi

  sudo cp $DOTFILES_DIR/auto.master /etc/
  sudo cp $DOTFILES_DIR/private/auto.nfs /etc/
  ln -s -f /media/NFS/Media-NAS

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

  cd /tmp
  wget https://zoom.us/client/latest/zoom_amd64.deb
  sudo apt install ./zoom_amd64.deb
  cd $DOTFILES_DIR

  echo "net.core.rmem_max=26214400" | sudo tee /etc/sysctl.d/10-udp-buffer-sizes.conf
  echo "net.core.rmem_default=26214400" | sudo tee -a /etc/sysctl.d/10-udp-buffer-sizes.conf

  snap_install slack-desktop

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
       LaTeX
       run_me
       ;;
    5)
       base_sys
       run_me
       ;;
    6)
       seegrid
       run_me
       ;;
    7)
       network_connections
       run_me
       ;;
    8)
       extras
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
