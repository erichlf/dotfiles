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
         5  "Install my extras"
         6  "Install LaTeX"
         7  "Remove crapware"
         8  "Update system"
         9  "sudo rules")

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

############################# my base system ###################################
#bikeshed contains utilities such as purge-old-kernels
function base_sys(){
  cd $HOME

  snap_install 1password

  apt_install wget curl iftop cifs-utils nfs-common gnome-tweaks zsh fzf

  curl -sSL https://get.rvm.io | bash

  snap_install btop

  ln -s $DOTFILES_DIR/zsh2000/zsh2000.zsh-theme $DOTFILES_DIR/.oh-my-zsh/custom/themes
  ln -s $DOTFILES_DIR/zsh-autosuggestions $DOTFILES_DIR/.oh-my-zsh/custom/plugins/

  apt_install network-manager-openvpn network-manager-openvpn-gnome network-manager-vpnc
  sudo /etc/init.d/networking restart

  cd $DOTFILES_DIR

  return 0
}

############################# developer tools ##################################
# install development utilities
function dev_tools(){
  if [ ! -d "$HOME/workspace" ]; then
    mkdir "$HOME/workspace"
  fi

  apt_install build-essential cmake gcc g++ clang clang-format

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

  apt_install libtool-bin guake vim emacs28 \
              meld openssh-server global \
              git git-completion build-essential cmake powerline \
              fonts-powerline freeglut3-dev xclip

  # setup links for google-calendar plugin
  cd $DOTFILES_DIR/.emacs.d/private/
  ln -sf $DOTFILES_DIR/google-calendar
  # setup links for snippets
  cd $DOTFILES_DIR/.emacs.d/private/snippets
  for S in $DOTFILES_DIR/snippets/*
  do
    ln -sf $S
  done

  if [ ! -d $HOME/.local/share/applications ]; then
    mkdir -p $HOME/.local/share/applications/
  fi
  ln -sf $DOTFILES_DIR/emacsclient.desktop $HOME/.local/share/applications/emacsclient.desktop
  if [ ! -d $HOME/.config/systemd/user ]; then
    mkdir -p $HOME/.config/systemd/user
  fi
  ln -sf $DOTFILES_DIR/emacs.service $HOME/.config/systemd/user/emacs.service
  systemctl --user enable --now emacs
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

  # setup link for powerline
  cd $HOME/.config/
  ln -sf $DOTFILES_DIR/powerline

  # install git-subrepo
  [ ! -d "$HOME/.config/git-subrepo" ] && git clone https://github.com/ingydotnet/git-subrepo

  cd $DOTFILES_DIR

  pip3_install powerline-gitstatus

  sudo update-alternatives --config editor

  apt_install gnupg ca-certificates

  # set up coredumps
  #ulimit -S -c unlimited
  #sudo sed -i"" -E "s/#(\*p[:blank:]+soft[:blank:]+core[:blank:]+)0/\1unlimited" /etc/security/limits.conf
  #sudo mkdir /var/coredumps
  #sudo sysctl -w kernel.core_pattern=/var/coredumps/core-%e-%s-%u-%g-%p-%t

  apt_update
  apt_install docker.io python3-yaml python3-git git-lfs

  sudo usermod -a -G docker $USERNAME
  sudo systemctl daemon-reload
  sudo systemctl restart docker

  newgrp docker

  apt_install docker-compose

  # install nodejs and npm so that we can then install devcontainers
  # curl -sL https://deb.nodesource.com/setup_18.x | sudo bash
  # apt_install nodejs npm
  # sudo npm install -g @devcontainers/cli

  # install vs code and git-credential-manager for using devcontainer and development
  wget "https://github.com/git-ecosystem/git-credential-manager/releases/download/v2.3.2/gcm-linux_amd64.2.3.2.deb" -O /tmp/gcmcore.deb
  sudo dpkg -i /tmp/gcmcore.deb
  git-credential-manager configure

  wget -q https://packages.microsoft.com/keys/microsoft.asc -O- | sudo apt-key add -
  sudo add-apt-repository "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main"
  apt_install code

  [[ ! -e $HOME/.config/Code/User ]] && mkdir -p $HOME/.config/Code/User
  cd $HOME/.config/Code/User
  for file in $DOTFILES_DIR/VSCode/User/*; do ln -sf $file; done

  cd $DOTFILES_DIR

  echo "net.core.rmem_max=26214400" | sudo tee /etc/sysctl.d/10-udp-buffer-sizes.conf
  echo "net.core.rmem_default=26214400" | sudo tee -a /etc/sysctl.d/10-udp-buffer-sizes.conf

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

################################ extras ########################################
function extras(){
  cd /tmp

  apt_update
  apt_install wget chrome-gnome-shell

  wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
  sudo dpkg -i google-chrome-stable_current_amd64.deb

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
