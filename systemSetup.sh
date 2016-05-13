#!/bin/bash
set -e

sudo apt-get install dialog git

# get the version of ubuntu
codename=`lsb_release -a 2>/dev/null | grep Codename | awk -F ' ' '{print $2}'`
release=`lsb_release -a 2>/dev/null | grep Release | awk -F ' ' '{print $2}'`

declare -a DOTFILES=( .bashrc .bash_exports .commacd.bash .editorconfig
                      .git-completion .gitconfig .gitexcludes .i3 .pentadactylrc
                      .pentadactyl .screenrc texmf .vim .vimrc .Xmodmap
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
         4  "Setup network connections"
         5  "Install development utilities"
         6  "Install LaTeX"
         7  "Install MOOSE"
         8  "Install FEniCS"
         9  "Install development framework"
         10 "Install python framework"
         11 "Install base system"
         12 "USI setup"
         13 "Install my extras"
         14 "Install nvidia drivers"
         15 "Remove crapware"
         16 "Update system"
         17 "sudo rules")

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

function sudo_rule(){
  echo "$USER ALL = NOPASSWD: $@" | sudo tee -a /etc/sudoers
}

#create my links
function sym_links(){
  cd $HOME
  for FILE in ${DOTFILES[@]}; do ln -s -f $HOME/dotfiles/$FILE; done
  cd $DOTFILES_DIR
}

function update_submodules(){
  cd $HOME/dotfiles
  git submodules update --init --recursive
  cd $DOTFILES_DIR
}

#setup my networks
function network_connections(){
  for CONNECTION in $HOME/dotfiles/private/system-connections/*; do
    sudo cp "$CONNECTION" /etc/NetworkManager/system-connections/
  done
}

############################# developer tools ##################################
# install development utilities
function dev_utils(){
  #latest git
  if no_ppa_exists git-core
  then
      add_ppa git-core/ppa
  fi

  #latest gnu-global
#  if no_ppa_exists dns-gnu
#  then
#      add_ppa dns/gnu
#  fi

  #latest cmake
#  if no_ppa_exists cmake-3.x
#  then
#      add_ppa george-edison55/cmake-3.x
#  fi

  get_update

  get_install vim vim-gtk openssh-server editorconfig global subversion git \
              screen libgnome-keyring-dev paraview openjdk-8-jdk xvfb \
              build-essential cmake

#  wget http://ftp.halifax.rwth-aachen.de/eclipse//technology/epp/downloads/release/mars/1/eclipse-cpp-mars-1-linux-gtk-x86_64.tar.gz

  #this is the installation of eclipse
#  sudo tar xzvf eclipse-cpp-mars-1-linux-gtk-x86_64.tar.gz -C /opt/

  #to install eclim we need to own this directory
#  sudo chown erich:erich -R /opt/eclipse

  #download and install eclim
#  wget http://sourceforge.net/projects/eclim/files/eclim/2.5.0/eclim_2.5.0.jar
#  java -Dvim.files=$HOME/.vim -Declipse.home=/opt/eclipse \
#       -jar eclim_2.5.0.jar install

  #setup credential helper for git
  keyring=/usr/share/doc/git/contrib/credential/gnome-keyring
  if [ ! -f $keyring/git-credential-gnome-keyring ]
  then
    cd $keyring
    sudo make
    cd $HOME
    git config --global credential.helper /usr/share/doc/git/contrib/credential/gnome-keyring/git-credential-gnome-keyring
    cd $DOTFILES_DIR
  fi

  cd $HOME
  if [ ! -d powerlineFonts ]
  then
    git clone https://github.com/powerline/fonts powerlineFonts
  fi
  cd powerlineFonts
  bash install.sh
  cd $HOME
  rm -rf powerlineFonts
  cd $DOTFILES_DIR

  #cd $HOME/dotfiles/.vim/bundle/YouCompleteMe
  #bash install.py --clang-completer
  #cd $DOTFILES_DIR
}

# install latex
function LaTeX(){
get_install texlive texlive-bibtex-extra texlive-science latex-beamer \
            texlive-latex-extra texlive-math-extra pybliographer
}

# install moose development environment
function MOOSE(){
  moose=moose-environment_ubuntu_14.04_1.1-39.x86_64.deb
  get_install build-essential gfortran tcl m4 freeglut3 doxygen libx11-dev \
              libblas-dev liblapack-dev
  cd $HOME/Downloads
  wget http://mooseframework.org/static/media/uploads/files/$moose -O $moose
  sudo dpkg -i $moose
  cd $DOTFILES_DIR
}

# install my own development environment
function dev_framework(){
  get_install cmake gcc g++ clang ctags # libparpack2-dev
}

# install python development
function python_framework(){
  get_install python-scipy python-numpy python-matplotlib ipython \
              ipython-notebook python-sympy cython
}

#fenics
function FEniCS(){
  cd $HOME
#  if no_ppa_exists fenics
#  then
#    add_ppa fenics-packages/fenics
#  fi

#  if no_ppa_exists libadjoingt
#  then
#    add_ppa libadjoint/ppa
#  fi
#  get_update
#  get_install fenics python-dolfin-adjoint
  get_install freeglut3-dev
  curl -s http://fenicsproject.org/fenics-install.sh | bash
  cd $DOTFILES_DIR
}

############################# my base system ###################################
#bikeshed contains utilities such as purge-old-kernels
function base_sys(){
  cd $HOME
  get_install i3 conky curl gtk-redshift ttf-ancient-fonts acpi gtk-doc-tools \
              gobject-introspection libglib2.0-dev cabal-install htop feh \
              python-feedparser python-keyring xbacklight bikeshed autocutsel \
              scrot autofs

  if [ ! -d /media/NFS ]; then
    sudo mkdir /media/NFS
  fi

  sudo cp $HOME/dotfiles/private/auto.nfs /etc/
  ln -s -f /media/NFS/Media-NAS

  echo '/media/NFS /etc/auto.nfs' \
    | sudo tee /etc/auto.master

  sudo service autofs start

  if [ ! -d playerctl ]; then
      git clone git@github.com:acrisci/playerctl.git
      cd playerctl
  else
      cd playerctl
      git fetch
      git pull origin
  fi
  bash autogen.sh
  make
  sudo make install
  sudo ldconfig

  # install cabal and yeganesh for dmenu
  cabal update
  cabal install yeganesh

#  gsettings set org.gnome.desktop.background show-desktop-icons false
  cd $DOTFILES_DIR
}

############################ usi requirements ##################################
#setup printers
function USI_setup(){
  get_install network-manager-vpnc smbclient foomatic-db

  sudo gpasswd -a ${USER} lpadmin
  cups_status=`sudo service cups status | grep process | wc -l`
  if [ $cups_status != 0 ]; then
      sudo service cups stop
  fi
  sudo cp $HOME/dotfiles/private/printers.conf /etc/cups/
  sudo service cups start
}

################################ extras ########################################
function extras(){
  #add nuvolaplayer repo and grab key
  if [ ! -f /etc/apt/sources.list.d/nuvola-player.list ]; then
      echo 'deb https://tiliado.eu/nuvolaplayer/repository/deb/ trusty stable' \
          | sudo tee /etc/apt/sources.list.d/nuvola-player.list
      sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 \
                      --recv-keys 40554B8FA5FE6F6A
  fi

  #nuvolaplayer3 requires webkit
#  if no_ppa_exists webkit-team
#  then
#      add_ppa webkit-team/ppa
#  fi

  #fix facebook for pidgin
#  if [ ! -f /etc/apt/sources.list.d/jgeboski.list ]; then
#      echo deb http://download.opensuse.org/repositories/home:/jgeboski/xUbuntu_$release bash  \
#          | sudo tee /etc/apt/sources.list.d/jgeboski.list
#      wget http://download.opensuse.org/repositories/home:/jgeboski/xUbuntu_$release/Release.key
#      sudo apt-key add Release.key
#      rm Release.key
#  fi

#  if [ ! -f /etc/apt/sources.list.d/syncthing-release.list ]; then
#      curl -s https://syncthing.net/release-key.txt | sudo apt-key add -
#      echo "deb http://apt.syncthing.net/ syncthing release" \
#          | sudo tee /etc/apt/sources.list.d/syncthing-release.list
#  fi

  #grive
  if no_ppa_exists nilarimogard/webupd8
  then
      add_ppa nilarimogard/webupd8
  fi

  get_update
  get_install transgui nuvolaplayer3 zathura zathura-djvu zathura-ps pidgin \
              pidgin-extprefs grive flashplugin-installer # syncthing purple-facebook
}

######################## fix the terminal font for 4k ##########################
# sudo dpkg-reconfigure console-setup

####################### Get NVIDIA Drivers and OpenCL ##########################
function nvidia_drivers(){
  if no_ppa_exists xorg-edgers
  then
    add_ppa xorg-edgers/ppa
  fi
  get_update
  get_install nvidia-331 nvidia-331-dev nvidia-opencl-dev \
              nvidia-modprobe
}

######################## remove things I never use #############################
function crapware(){
  sudo apt-get remove -y transmission-gtk libreoffice libreoffice-* thunderbird \
                        evince apport gnome-terminal gedit
}

########################## update and upgrade ##################################
function update_sys(){
  get_update
  sudo apt-get -y dist-upgrade
}

############################## annoyances ######################################
function sudo_rules(){
  sudo_rule /usr/sbin/pm-suspend
  sudo_rule /usr/sbin/pm-hibernate
  sudo_rule /sbin/shutdown
  sudo_rule /sbin/reboot
  sudo_rule /usr/bin/tee brightness
}

for choice in $choices
do
  case $choice in
    1)
       sym_links
       #network_connections
       dev_utils
       LaTeX
       MOOSE
       #FEniCS
       dev_framework
       python_framework
       base_sys
       USI_setup
       extras
       # nvidia_drivers
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
       network_connections
       bash $DOTFILES_DIR/systemSetup.sh
       ;;
    5)
       dev_utils
       bash $DOTFILES_DIR/systemSetup.sh
       ;;
    6)
       LaTeX
       bash $DOTFILES_DIR/systemSetup.sh
       ;;
    7)
       MOOSE
       bash $DOTFILES_DIR/systemSetup.sh
       ;;
    8)
       FEniCS
       bash $DOTFILES_DIR/systemSetup.sh
       ;;
    9)
       dev_framework
       bash $DOTFILES_DIR/systemSetup.sh
       ;;
    10)
       python_framework
       bash $DOTFILES_DIR/systemSetup.sh
       ;;
    11)
       base_sys
       bash $DOTFILES_DIR/systemSetup.sh
       ;;
    12)
       USI_setup
       bash $DOTFILES_DIR/systemSetup.sh
       ;;
    13)
       extras
       bash $DOTFILES_DIR/systemSetup.sh
       ;;
    14)
       nvidia_drivers
       bash $DOTFILES_DIR/systemSetup.sh
       ;;
    15)
       crapware
       bash $DOTFILES_DIR/systemSetup.sh
       ;;
    16)
       update_sys
       bash $DOTFILES_DIR/systemSetup.sh
       ;;
    17)
       sudo_rules
       bash $DOTFILES_DIR/systemSetup.sh
       ;;
  esac
done
