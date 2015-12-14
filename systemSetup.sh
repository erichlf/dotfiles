#!/bin/bash
set -e

# get the version of ubuntu
codename=`lsb_release -a 2>/dev/null | grep Codename | awk -F ' ' '{print $2}'`
release=`lsb_release -a 2>/dev/null | grep Release | awk -F ' ' '{print $2}'`

declare -a DOTFILES=( .bashrc .bash_exports .commacd.bash .editorconfig
                      .git-completion .gitconfig .gitexcludes .i3 .pentadactylrc
                      .screenrc texmf .vim .vimrc .Xmodmap .Xresources
                      .xsessionrc private/.bash_aliases )

PWD=`pwd`

cmd=(dialog --backtitle "system setup" --menu "Welcome to Erich's system
setup.\nWhat would you like to do?" 14 50 16)

options=(1  "Fresh system setup"
         2  "Create symbolic links"
         3  "Setup network connections"
         4  "Install development utilities"
         5  "Install LaTeX"
         6  "Install MOOSE"
         7  "Install FEniCS"
         8  "Install development framework"
         9  "Install python framework"
         10 "Install base system"
         11 "USI setup"
         12 "Install my extras"
         13 "Install nvidia drivers"
         14 "Remove crapware"
         15 "Update system"
         16 "sudo rules")

choices=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)

############################# grab dotfiles ####################################
# dotfiles already exist since I am running this script!
# git clone git@github.com:erichlf/dotfiles.git
(cd $HOME/dotfiles && git submodule init && git submodule update)

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
  sudo apt-get install -y --force-yes $@

  return 0
}

function sudo_rule(){
  echo "$USER ALL = NOPASSWD: $@" | sudo tee -a /etc/sudoers
}

#create my links
function sym_links(){
  cd $HOME
  for FILE in ${DOTFILES[@]}; do ln -s -f $HOME/dotfiles/$FILE; done
  cd $PWD
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
  if no_ppa_exists dns-gnu
  then
      add_ppa dns/gnu
  fi

  #latest cmake
  if no_ppa_exists cmake-3.x
  then
      add_ppa george-edison55/cmake-3.x
  fi

  get_update

  get_install vim vim-gtk openssh-server editorconfig global subversion git \
              screen libgnome-keyring-dev paraview 

  #setup credential helper for git
  keyring=/usr/share/doc/git/contrib/credential/gnome-keyring
  if [ ! -f $keyring/git-credential-gnome-keyring ]
  then
    cd $keyring
    sudo make
    cd $HOME
    git config --global credential.helper /usr/share/doc/git/contrib/credential/gnome-keyring/git-credential-gnome-keyring
    cd $PWD
  fi
}

# install latex
function LaTeX(){
get_install texlive texlive-bibtex-extra texlive-science latex-beamer \
            texlive-latex-extra texlive-math-extra pybliographer
}

# install moose development environment
function MOOSE(){
  moose=moose-environment_ubuntu_14.04_1.1-36.x86_64.deb
  get_install build-essential gfortran tcl m4 freeglut3 doxygen libx11-dev \
              libblas-dev liblapack-dev
  cd $HOME/Downloads
  wget http://mooseframework.org/static/media/uploads/files/$moose -O $moose
  sudo dpkg -i $moose
  cd $PWD
}

# install my own development environment
function dev_framework(){
  get_install cmake gcc g++ clang libparpack2-dev
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
  curl -s http://fenicsproject.org/fenics-install.sh | bash
  cd $PWD
}

############################# my base system ###################################
#bikeshed contains utilities such as purge-old-kernels
function base_sys(){
  cd $HOME
  get_install i3 conky curl gtk-redshift ttf-ancient-fonts acpi gtk-doc-tools \
              gobject-introspection libglib2.0-dev cabal-install htop feh \
              python-feedparser python-keyring xbacklight bikeshed autocutsel \
              scrot

  if [ ! -d playerctl ]; then
      git clone git@github.com:acrisci/playerctl.git
      cd playerctl
  else
      cd playerctl
      git fetch
      git pull origin
  fi
  ./autogen.sh
  make
  sudo make install
  sudo ldconfig

  # install cabal and yeganesh for dmenu
  cabal update
  cabal install yeganesh

#  gsettings set org.gnome.desktop.background show-desktop-icons false
  cd $PWD
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
  if no_ppa_exists webkit-team
  then
      add_ppa webkit-team/ppa
  fi

  #fix facebook for pidgin
  if [ ! -f /etc/apt/sources.list.d/jgeboski.list ]; then
      echo deb http://download.opensuse.org/repositories/home:/jgeboski/xUbuntu_$release ./ \
          | sudo tee /etc/apt/sources.list.d/jgeboski.list
      wget http://download.opensuse.org/repositories/home:/jgeboski/xUbuntu_$release/Release.key
      sudo apt-key add Release.key
      rm Release.key
  fi

  if [ ! -f /etc/apt/sources.list.d/syncthing-release.list ]; then
      curl -s https://syncthing.net/release-key.txt | sudo apt-key add -
      echo "deb http://apt.syncthing.net/ syncthing release" \
          | sudo tee /etc/apt/sources.list.d/syncthing-release.list
  fi

  get_update
  get_install transgui nuvolaplayer3 zathura zathura-djvu zathura-ps pidgin \
              purple-facebook pidgin-extprefs flashplugin-installer syncthing
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
  sudo_rule /sbin/pm-shutdown
  sudo_rule /sbin/pm-hibernate
  sudo_rule /sbin/shutdown
  sudo_rule /sbin/reboot
  sudo_rule /usr/bin/tee brightness
}

for choice in $choices
do
  case $choice in
    1) 
       sym_links
       network_connections
       dev_utils
       LaTeX
       MOOSE
       FEniCS
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
       ./systemSetup.sh
       ;;
    3)
       sym_links
       ./systemSetup.sh
       ;;
    3)
       network_connections
       ./systemSetup.sh
       ;;
    4)
       dev_utils
       ./systemSetup.sh
       ;;
    5)
       LaTeX
       ./systemSetup.sh
       ;;
    6)
       MOOSE
       ./systemSetup.sh
       ;;
    7)
       FEniCS
       ./systemSetup.sh
       ;;
    8)
       dev_framework
       ./systemSetup.sh
       ;;
    9)
       python_framework
       ./systemSetup.sh
       ;;
    10)
       base_sys
       ./systemSetup.sh
       ;;
    11)
       USI_setup
       ./systemSetup.sh
       ;;
    12)
       extras
       ./systemSetup.sh
       ;;
    13)
       nvidia_drivers
       ./systemSetup.sh
       ;;
    14)
       crapware
       ./systemSetup.sh
       ;;
    15)
       update_sys
       ./systemSetup.sh
       ;;
    16)
       sudo_rules
       ./systemSetup.sh
       ;;
  esac
done
