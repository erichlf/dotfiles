#!/bin/bash
set -e

sudo apt install dialog git

# get the version of ubuntu
codename=`lsb_release -a 2>/dev/null | grep Codename | awk -F ' ' '{print $2}'`
release=`lsb_release -a 2>/dev/null | grep Release | awk -F ' ' '{print $2}'`

declare -a DOTFILES=( .bashrc
                      .bash_exports
                      .fzf
                      .gitconfig
                      .gitexcludes
                      .oh-my-zsh
                      .profile
                      private/.bash_aliases
                      private/.ssh/config
                      .vimrc
                      .zshrc )

DOTFILES_DIR=$HOME/dotfiles

############################# grab dotfiles ####################################
# dotfiles already exist since I am running this script!
# git clone git@github.com:erichlf/dotfiles.git
(cd $DOTFILES_DIR && git submodule update --init --recursive)

cmd=(dialog --backtitle "system setup" --menu "Welcome to Erich's system
setup.\nWhat would you like to do?" 14 50 16)

options=(1  "Fresh system setup"
         2  "Create symbolic links")

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

function install_tools(){

  sudo opkg install boost-filesystem boost-regex boost-system \
       ca-bundle ca-certificates entware-release findutils git \
       grep htop iperf iperf3 libbz2 libc libcap libcurl libdb47 \
       libexpat libffi libflac libfmt libgcc libgdbm libiconv-full \
       libintl-full liblzma liblzo libmagic libncurses libncursesw \
       libogg libopenssl libpcre libpcre2 libpthread librt \
       libsqlite3 libssp libstdcpp libtirpc libuuid libvorbis \
       libxml2 locales make mkvtoolnix perl perlbase-base \
       perlbase-class perlbase-config perlbase-cwd \
       perlbase-dynaloader perlbase-errno perlbase-essential \
       perlbase-fcntl perlbase-i18n perlbase-integer \
       perlbase-list perlbase-locale perlbase-mime perlbase-opcode \
       perlbase-ostype perlbase-params perlbase-posix \
       perlbase-re perlbase-scalar perlbase-socket perlbase-tie \
       perlbase-time perlbase-unicore perlbase-utf8 perlbase-xsloader \
       python-pip-conf python3 python3-asyncio python3-base \
       python3-cgi python3-cgitb python3-codecs python3-ctypes \
       python3-dbm python3-decimal python3-distutils python3-email \
       python3-gdbm python3-light python3-logging python3-lzma \
       python3-multiprocessing python3-ncurses python3-openssl \
       python3-pip python3-pkg-resources python3-pydoc \
       python3-setuptools python3-sqlite3 python3-unittest \
       python3-urllib python3-xml rename terminfo tree vim-full zlib \
       zoneinfo-asia zoneinfo-europe zsh
}

for choice in $choices
do
  case $choice in
    1)
       sym_links
       install_tools
       run_me
       ;;
    2)
       sym_links
       run_me
       ;;
  esac
done
