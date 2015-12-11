#!/bin/bash
set -e

# get the version of ubuntu
codename=`lsb_release -a 2>/dev/null | grep Codename | awk -F ' ' '{print $2}'`
release=`lsb_release -a 2>/dev/null | grep Release | awk -F ' ' '{print $2}'`

declare -a DOTFILES=( .bashrc .bash_exports .commacd.bash .editorconfig
                      .git-completion .gitconfig .gitexcludes .i3 .pentadactylrc
                      .screenrc texmf .vim .vimrc .Xmodmap .Xresources
                      .xsessionrc private/.bash_aliases )

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
  sudo apt-get install -y $@

  return 0
}

function sudo_rule(){
  echo "$USER ALL = NOPASSWD: $@" | sudo tee -a /etc/sudoers
}

#create my links
if ask "Would you like to create symbolic links?" "Y"
then 
  cd $HOME
  for FILE in ${DOTFILES[@]}; do ln -s -f $HOME/dotfiles/$FILE; done
fi

#setup my networks
if ask "Would you like to setup you network connections?" "Y"
then 
  for CONNECTION in $HOME/dotfiles/private/system-connections/*; do
    sudo cp "$CONNECTION" /etc/NetworkManager/system-connections/
  done
fi

############################# developer tools ##################################
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

# install development utilities
get_install vim vim-gtk openssh-server editorconfig global subversion git \
            screen libgnome-keyring-dev paraview 

# install latex
get_install texlive texlive-bibtex-extra texlive-science latex-beamer \
            texlive-latex-extra texlive-math-extra pybliographer

# install moose development environment
if ask "Install MOOSE?" "Y"
then
  moose=moose-environment_ubuntu_14.04_1.1-36.x86_64.deb
  get_install build-essential gfortran tcl m4 freeglut3 doxygen libx11-dev
  cd $HOME/Downloads
  wget http://mooseframework.org/static/media/uploads/files/$moose -O $moose
  sudo dpkg -i $moose
  cd $HOME
fi

# install my own development environment
if ask "Install development framework?" "Y"
then
  get_install cmake gcc g++ clang libparpack2-dev
fi

# install python development
if ask "Install python framework?" "Y"
then
  get_install python-scipy python-numpy python-matplotlib ipython \
              ipython-notebook python-sympy cython
fi

#setup credential helper for git
keyring=/usr/share/doc/git/contrib/credential/gnome-keyring
if [ ! -f $keyring/git-credential-gnome-keyring ]
then
  cd $keyring
  sudo make
  cd $HOME
  git config --global credential.helper /usr/share/doc/git/contrib/credential/gnome-keyring/git-credential-gnome-keyring
fi

#fenics
if ask "Install FEniCS?" "N"
then
  if no_ppa_exists fenics
  then
    add_ppa fenics-packages/fenics
  fi

  if no_ppa_exists libadjoingt
  then
    add_ppa libadjoint/ppa
  fi
  get_update
  get_install fenics python-dolfin-adjoint
fi


############################# my base system ###################################
#bikeshed contains utilities such as purge-old-kernels
get_install i3 conky curl gtk-redshift ttf-ancient-fonts acpi gtk-doc-tools \
            gobject-introspection libglib2.0-dev cabal-install htop feh \
            python-feedparser python-keyring xbacklight bikeshed autocutsel scrot

#install playerctl for media keys
if ask "Build and install playerctl?" "Y"
then
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
fi

# install cabal and yeganesh for dmenu
if ask "Install yaganesh?" "Y"
then
  cabal update
  cabal install yeganesh
fi

############################ usi requirements ##################################
get_install network-manager-vpnc smbclient foomatic-db

#setup printers
if ask "Do you want to install USI-printers?" "Y"
then
  sudo gpasswd -a ${USER} lpadmin
  cups_status=`sudo service cups status | grep process | wc -l`
  if [ $cups_status != 0 ]; then
      sudo service cups stop
  fi
  sudo cp $HOME/dotfiles/private/printers.conf /etc/cups/
  sudo service cups start
fi

################################ extras ########################################
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

######################## fix the terminal font for 4k ##########################
# sudo dpkg-reconfigure console-setup

######################## remove things I never use #############################
sudo apt-get remove -y transmission-gtk libreoffice libreoffice-* thunderbird \
                       evince apport gnome-terminal gedit
gsettings set org.gnome.desktop.background show-desktop-icons false

########################## update and upgrade ##################################
get_update
sudo apt-get -y dist-upgrade

sudo apt-get autoremove

############################## annoyances ######################################

if ask "Add sudo rules?" "Y"
then 
  sudo_rule /sbin/pm-shutdown
  sudo_rule /sbin/pm-hibernate
  sudo_rule /sbin/shutdown
  sudo_rule /sbin/reboot
  sudo_rule /usr/bin/tee brightness
fi
