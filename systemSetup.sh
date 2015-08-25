set -e

declare -a DOTFILES=( .bashrc .bash_exports .commacd.bash .editorconfig
                      .git-completion .gitconfig .gitexcludes .i3 .pentadactylrc
                      .screenrc texmf .vim .vimrc .Xmodmap .Xresources
                      .xsessionrc private/.bash_aliases )

############################# grab dotfiles ####################################
# dotfiles already exist since I am running this script!
# git clone git@github.com:erichlf/dotfiles.git
cd $HOME/dotfiles
git submodule init
git submodule update

#create my links
cd $HOME
for FILE in ${DOTFILES[@]}; do ln -s $HOME/dotfiles/$FILE; done

#setup my networks
CONNECTIONS=$(sudo ls $HOME/dotfiles/private/system-connections/)
for CONNECTION in "$CONNECTIONS"; do
    sudo cp "$HOME/dotfiles/private/system-connections/$CONNECTION" \
            /etc/NetworkManager/system-connections/
done

############################# developer tools ##################################
#fenics repo
sudo add-apt-repository ppa:fenics-packages/fenics

#latest git
sudo add-apt-repository ppa:git-core/ppa
sudo apt-get update

sudo apt-get update
sudo apt-get install -y vim vim-gnome openssh-server editorconfig \
                        build-essential gfortran build-essential subversion \
                        cmake g++ python-scipy python-numpy python-matplotlib \
                        ipython ipython-notebook python-sympy cython gimp \
                        fenics screen texlive texlive-science latex-beamer \
                        texlive-latex-extra texlive-math-extra git
                        libgnome-keyring-dev ruby1.9.1 ruby1.9.1-dev wkhtmltopdf

#setup credential helper for git
cd /usr/share/doc/git/contrib/credential/gnome-keyring
sudo make
cd $HOME
git config --global credential.helper /usr/share/doc/git/contrib/credential/gnome-keyring/git-credential-gnome-keyring

#setup markdown preview
sudo gem install rdoc
sudo gem install rails
sudo gem install mdprev

############################# my base system ###################################
sudo apt-get install -y i3 conky curl arandr gtk-redshift ttf-ancient-fonts \
                        acpi gtk-doc-tools gobject-introspection \
                        libglib2.0-dev cabal-install htop feh python-keyring \
                        xbacklight bikeshed

#bikeshed contains utilities such as purge-old-kernels

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

#setup printers
sudo gpasswd -a ${USER} lpadmin
sudo service cups stop
sudo cp private/printers.conf /etc/cups/
sudo service cups start

################################ extras ########################################
#add nuvolaplayer repo and grab key
echo 'deb https://tiliado.eu/nuvolaplayer/repository/deb/ vivid stable' \
    > sudo tee /etc/apt/sources.list.d/tiliado-nuvolaplayer.list
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 \
                 --recv-keys 40554B8FA5FE6F6A
#nuvolaplayer3 requires webkit
sudo add-apt-repository ppa:webkit-team/ppa

#fix facebook for pidgin
echo deb http://download.opensuse.org/repositories/home:/jgeboski/xUbuntu_15.04 ./ | \
    sudo tee /etc/apt/sources.list.d/jgeboski.list
wget http://download.opensuse.org/repositories/home:/jgeboski/xUbuntu_15.04/Release.key
sudo apt-key add Release.key
rm Release.key
sudo apt-get update

sudo apt-get install -y transgui nuvolaplayer3 zathura pidgin purple-facebook \
                        pidgin-extprefs flashplugin-installer syncthing

######################## remove things I never use #############################
sudo apt-get remove -y transmission-gtk libreoffice thunderbird evince apport

########################## update and upgrade ##################################
sudo apt-get update
sudo apt-get dist-upgrade

sudo apt-get autoremove

############################## annoyances ######################################
echo '$USER ALL = NOPASSWD: /sbin/shutdown' | tee -a /etc/sudoers
echo '$USER ALL = NOPASSWD: /sbin/reboot' | tee -a /etc/sudoers
