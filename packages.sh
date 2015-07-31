set -e

declare -a DOTFILES=(.bashrc .bash_exports .commacd.bash .editorconfig
                     .git-completion .gitconfig .gitexcludes .i3 .pentadactylrc
                     .screenrc texmf .vim .vimrc .Xmodmap .Xresources
                     .xsessionrc)

############################# grab dotfiles ####################################
# dotfiles already exist since I am running this script!
# git clone git@github.com:erichlf/dotfiles.git
cd $HOME/dotfiles
git submodule init
git submodule update

#create my links
cd $HOME
for dotfile in ${DOTFILES[@]}; do ln -s $HOME/dotfiles/$dotfile; done

############################# developer tools ##################################
sudo apt-get install -y vim vim-gnome openssh-server editorconfig \
                        build-essential gfortran build-essential subversion \
                        cmake g++ python-scipy python-numpy python-matplotlib \
                        ipython ipython-notebook python-sympy cython gimp screen

############################# my base system ###################################
sudo apt-get install -y i3 conky curl arandr gtk-redshift ttf-ancient-fonts \
                        acpi gtk-doc-tools gobject-introspection \
                        libglib2.0-devcabal-install htop feh

#install playerctl for media keys
git clone git@github.com:acrisci/playerctl.git
cd playerctl
./autogen.sh
make
sudo make install
sudo ldconfig

# install cabal and yeganesh for dmenu
cabal update
cabal install yeganesh

############################ usi requirements ##################################
sudo apt-get install -y network-manager-vpnc smbclient foomatic-db

################################ extras ########################################
#add nuvolaplayer repo and grab key
echo 'deb https://tiliado.eu/nuvolaplayer/repository/deb/ vivid stable' \
    > sudo tee /etc/apt/sources.list.d/tiliado-nuvolaplayer.list
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 \
                 --recv-keys 40554B8FA5FE6F6A

sudo apt-get update
sudo apt-get install -y transgui nuvolaplayer3 zathura pidgin pidgin-extprefs \
                        flashplugin-installer syncthing

######################## remove things I never use #############################
apt-get autoremove transmission-gtk libreoffice thunderbird

########################## update and upgrade ##################################
sudo apt-get update
sudo apt-get dist-upgrade
