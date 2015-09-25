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
    sudo add-apt-repository ppa:fenics-packages/fenics -y
fi

ppa_added=`grep ^ /etc/apt/sources.list /etc/apt/sources.list.d/* | grep -v list.save | grep -v deb-src | grep deb | grep libadjoint | wc -l`
if [ $ppa_added == 0 ]; then
    sudo apt-add-repository ppa:libadjoint/ppa -y
fi

#latest git
ppa_added=`grep ^ /etc/apt/sources.list /etc/apt/sources.list.d/* | grep -v list.save | grep -v deb-src | grep deb | grep git-core | wc -l`
if [ $ppa_added == 0 ]; then
    sudo add-apt-repository ppa:git-core/ppa -y
fi

#latest gnu-global
ppa_added=`grep ^ /etc/apt/sources.list /etc/apt/sources.list.d/* | grep -v list.save | grep -v deb-src | grep deb | grep dns-gnu | wc -l`
if [ $ppa_added == 0 ]; then
    sudo add-apt-repository ppa:dns/gnu -y
fi

ppa_added=`grep ^ /etc/apt/sources.list /etc/apt/sources.list.d/* | grep -v list.save | grep -v deb-src | grep deb | grep george-edison | wc -l`
if [ $ppa_added == 0 ]; then
    sudo add-apt-repository ppa:george-edison55/cmake-3.x
fi

sudo apt-get update
sudo apt-get install -y vim vim-gtk openssh-server editorconfig build-essential \
                        gfortran subversion cmake gcc g++ clang freeglut3 \
                        python-scipy python-numpy python-matplotlib \
                        ipython ipython-notebook python-sympy cython \
                        fenics python-dolfin-adjoint screen texlive \
                        texlive-bibtex-extra texlive-science latex-beamer \
                        texlive-latex-extra texlive-math-extra global \
                        libgnome-keyring-dev pybliographer paraview \
                        libparpack2-dev

#setup credential helper for git
cd /usr/share/doc/git/contrib/credential/gnome-keyring
sudo make
cd $HOME
git config --global credential.helper /usr/share/doc/git/contrib/credential/gnome-keyring/git-credential-gnome-keyring

############################# my base system ###################################
sudo apt-get install -y i3 conky curl gtk-redshift ttf-ancient-fonts \
                        acpi gtk-doc-tools gobject-introspection libglib2.0-dev \
                        cabal-install htop feh python-feedparser \
                        python-keyring xbacklight bikeshed autocutsel scrot

#bikeshed contains utilities such as purge-old-kernels

#install playerctl for media keys
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
        | sudo tee /etc/apt/sources.list.d/nuvola-player.list
    sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 \
                    --recv-keys 40554B8FA5FE6F6A
fi

#nuvolaplayer3 requires webkit
ppa_added=`grep ^ /etc/apt/sources.list /etc/apt/sources.list.d/* | grep -v list.save | grep -v deb-src | grep deb | grep webkit-team | wc -l`
if [ $ppa_added == 0 ]; then
    sudo add-apt-repository ppa:webkit-team/ppa -y
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
sudo apt-get remove -y transmission-gtk libreoffice libreoffice-* thunderbird \
                       evince apport gnome-terminal gedit
gsettings set org.gnome.desktop.background show-desktop-icons false

########################## update and upgrade ##################################
sudo apt-get update
sudo apt-get -y dist-upgrade

sudo apt-get autoremove

############################## annoyances ######################################
echo "$USER ALL = NOPASSWD: /sbin/shutdown" | sudo tee -a /etc/sudoers
echo "$USER ALL = NOPASSWD: /sbin/reboot" | sudo tee -a /etc/sudoers
echo "$USER ALL = NOPASSWD: /usr/bin/tee brightness" | sudo tee -a /etc/sudoers
