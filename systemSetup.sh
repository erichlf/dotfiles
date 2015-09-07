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
for FILE in ${DOTFILES[@]}; do ln -s -f $HOME/dotfiles/$FILE; done

#setup my networks
for CONNECTION in $HOME/dotfiles/private/system-connections/*; do
    sudo cp "$CONNECTION" /etc/NetworkManager/system-connections/
done

############################# developer tools ##################################
#fenics repo
ppa_added=`grep ^ /etc/apt/sources.list /etc/apt/sources.list.d/* | grep -v list.save | grep -v deb-src | grep deb | grep fenics | wc -l`
if [ $ppa_added == 0 ]; then
    sudo add-apt-repository ppa:fenics-packages/fenics
fi

#latest git
ppa_added=`grep ^ /etc/apt/sources.list /etc/apt/sources.list.d/* | grep -v list.save | grep -v deb-src | grep deb | grep git-core | wc -l`
if [ $ppa_added == 0 ]; then
    sudo add-apt-repository ppa:git-core/ppa
fi

sudo apt-get update
sudo apt-get install -y vim vim-gnome openssh-server editorconfig \
                        build-essential gfortran build-essential subversion \
                        cmake g++ python-scipy python-numpy python-matplotlib \
                        ipython ipython-notebook python-sympy cython gimp \
                        fenics screen texlive texlive-bibtex-extra \
                        texlive-science latex-beamer texlive-latex-extra \
                        texlive-math-extra git libgnome-keyring-dev ruby1.9.1 \
                        ruby1.9.1-dev wkhtmltopdf pybliographer

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
                        libglib2.0-dev cabal-install htop feh python-feedparser \
                        python-keyring xbacklight bikeshed autocutsel scrot

#bikeshed contains utilities such as purge-old-kernels

#install playerctl for media keys
if [ ! -d playerctl ]; then
    git clone git@github.com:acrisci/playerctl.git
fi
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
cups_status=`sudo service cups status | grep process | wc -l`
if [ $cups_status != 0 ]; then
    sudo service cups stop
fi
sudo cp $HOME/dotfiles/private/printers.conf /etc/cups/
sudo service cups start

################################ extras ########################################
#add nuvolaplayer repo and grab key
if [ ! -f /etc/apt/sources.list.d/nuvola-player.list ]; then
    echo 'deb https://tiliado.eu/nuvolaplayer/repository/deb/ trusty stable' \
        > sudo tee /etc/apt/sources.list.d/nuvola-player.list
    sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 \
                    --recv-keys 40554B8FA5FE6F6A
fi

#nuvolaplayer3 requires webkit
ppa_added=`grep ^ /etc/apt/sources.list /etc/apt/sources.list.d/* | grep -v list.save | grep -v deb-src | grep deb | grep webkit-team | wc -l`
if [ $ppa_added == 0 ]; then
    sudo add-apt-repository ppa:webkit-team/ppa
fi

#fix facebook for pidgin
if [ ! -f /etc/apt/source.list.d/jgeboski.list ]; then
    echo deb http://download.opensuse.org/repositories/home:/jgeboski/xUbuntu_14.04 ./ | \
        sudo tee /etc/apt/sources.list.d/jgeboski.list
    wget http://download.opensuse.org/repositories/home:/jgeboski/xUbuntu_15.04/Release.key
    sudo apt-key add Release.key
    rm Release.key
fi

if [ ! -f /etc/apt/sources.list.d/syncthing-release.list ]; then
    curl -s https://syncthing.net/release-key.txt | sudo apt-key add -
    echo "deb http://apt.syncthing.net/ syncthing release" \
        | sudo tee /etc/apt/sources.list.d/syncthing-release.list
fi

sudo apt-get update

sudo apt-get install -y transgui nuvolaplayer3 zathura zathura-djvu zathura-ps \
                        pidgin purple-facebook pidgin-extprefs \
                        flashplugin-installer syncthing

######################## fix the terminal font for 4k ##########################
sudo dpkg-reconfigure console-setup

######################## remove things I never use #############################
sudo apt-get remove -y transmission-gtk libreoffice thunderbird evince apport
gsettings set org.gnome.desktop.background show-desktop-icons false

########################## update and upgrade ##################################
sudo apt-get update
sudo apt-get -y dist-upgrade

sudo apt-get autoremove

############################## annoyances ######################################
echo "$USER ALL = NOPASSWD: /sbin/shutdown" | sudo tee -a /etc/sudoers
echo "$USER ALL = NOPASSWD: /sbin/reboot" | sudo tee -a /etc/sudoers
echo "$USER ALL = NOPASSWD: /usr/bin/tee brightness" | sudo tee -a /etc/sudoers
