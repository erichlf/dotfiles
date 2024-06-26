#!/bin/bash
set -e

SYSTEM="MAIN"
cd $(dirname $0)/..
DOTFILES_DIR=$(pwd)

source "$DOTFILES_DIR/scripts/utils.sh"

print_details

THIS=$0

pac_install base-devel dialog git stow

# get the version of ubuntu
codename=`lsb_release -a 2>/dev/null | grep Codename | awk -F ' ' '{print $2}'`
release=`lsb_release -a 2>/dev/null | grep Release | awk -F ' ' '{print $2}'`

############################# grab dotfiles ####################################
# dotfiles already exist since I am running this script!
# git clone git@github.com:erichlf/dotfiles.git
git submodule update --init --recursive

cmd=( \
  dialog \
  --clear \
  --cancel-label "Exit" \
  --backtitle "system setup" \
  --menu "Welcome to Erich's system setup.\nWhat would you like to do?" \
  14 50 16 \
)

options=(1 "Fresh system setup"
         2 "Create symbolic links"
         3 "Install base system"
         4 "Install TU Delft tools"
         5 "Latitude 7440 Hacks"
         6 "Update system"
         7 "sudo rules")

if [ $CI ]; then 
  choices=1
else
  choices=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)
fi

function run_me() {
  [ $CI ] && exit
  bash $THIS
}

############################# my base system ###################################
#bikeshed contains utilities such as purge-old-kernels
function base_sys(){
  echo "Setting up yay..."

  [ ! -d /tmp/yay ] && git clone https://aur.archlinux.org/yay.git /tmp/yay
  cd /tmp/yay
  makepkg -si --noconfirm

  echo "Setting up shell..."

  pac_install \
    btop \
    curl \
    fzf \
    gnome-shell-extension-appindicator \
    gnome-tweaks \
    guake \
    iftop \
    pass \
    python \
    python-pip \
    tmux \
    wget

  guake --restore-preferences $DOTFILES_DIR/guake.conf
  gnome-extensions enable appindicatorsupport@rgcjonas.gmail.com
  gnome-extensions enable pamac-updates@manjaro.org

  zsh_extras

  starship_install

  lazygit_install

  echo "Setting up networking..."
  pac_install \
    networkmanager-openvpn \
    networkmanager-vpnc \
    openssh

  echo "Installing developer tools..."
  if [ ! -d "$HOME/workspace" ]; then
    mkdir "$HOME/workspace"
  fi

  pac_install \
    cmake \
    gcc \
    ipython \
    llvm \
    meld \
    obsidian \
    python-matplotlib \
    python-numpy \
    python-scipy \
    python-setuptools 

  yay_install \
    git-completion

  echo "Installing python linters..."
  pac_install \
    python-black \
    flake8 \
    python-isort \
    python-pylint \
    python-wheel \
    yapf

  echo "Installing NEOVIM..."
  pac_install \
    chafa \
    git-lfs \
    go \
    neovim \
    nodejs \
    npm \
    python-gitpython \
    python-pynvim \
    python-ply \
    python-virtualenv \
    python-yaml \
    rust \
    xclip

  mkdir -p $HOME/.npm-global
  npm config set prefix $HOME/.npm-global
  npm install -g neovim tree-sitter
  curl -sSL https://get.rvm.io | bash -s -- --auto-dotfiles

  lunarvim_install

  echo "Setting up docker..."

  pac_install \
    ca-certificates \
    containerd \
    docker \
    docker-compose \
    gnupg

  sudo usermod -a -G docker $USER
  if [ ! $CI ]; then 
    sudo systemctl daemon-reload
    sudo systemctl enable docker
    sudo systemctl start docker
  fi

  echo "Installing vscode..."
  npm install -g @devcontainers/cli

  yay_install \
    git-credential-manager

  pac_install \
    vscode

  git-credential-manager configure

  echo "net.core.rmem_max=26214400" | sudo tee /etc/sysctl.d/10-udp-buffer-sizes.conf
  echo "net.core.rmem_default=26214400" | sudo tee -a /etc/sysctl.d/10-udp-buffer-sizes.conf

  echo "Installing extras..."
  yay_install \
    1password \
    1password-cli \
    signal-desktop

  pac_install \
    vivaldi \
    vivaldi-ffmpeg-codecs

  sudo /opt/vivaldi/update-ffmpeg

  yay_install \
    gnome-browser-connector-git

  # add 1password support to vivaldi
  sudo mkdir -p /etc/1password
  echo "vivaldi-bin" | sudo tee /etc/1password/custom_allowed_browsers 
  sudo chown root:root /etc/1password/custom_allowed_browsers
  sudo chmod 755 /etc/1password/custom_allowed_browsers

  return 0
}

function tudelft(){
  curl https://app.eduvpn.org/linux/v4/deb/app+linux@eduvpn.org.asc | gpg --import -

  yay_install \
    python-eduvpn-client \
    teams-for-linux-bin

  return 0
}

########################## Computer Specific ####################################
function latitude_7440(){
  # install drivers for intel webcam
  pac_install libdrm 
  git clone git@github.com:stefanpartheym/archlinux-ipu6-webcam.git /tmp/archlinux-ipu6-webcam
  cd /tmp/archlinux-ipu6-webcam
  git apply $DOTFILES_DIR/scripts/patches/intel_webcam.patch
  ./install.sh

  # install driver for fingerprint scanner, enable it, and enroll left and right
  # index fingers
  pac_install libfprint-2-tod1-broadcom fprintd libpam-fprintd
  sudo fprintd-enroll -f left-index-finger
  sudo fprintd-enroll -f right-index-finger
  sudo pam-auth-update --enable fprintd
}

########################## update and upgrade ##################################
function update_sys(){
  echo "Updating system..."
  if [ $CI ]; then
    return 0
  fi

  pac_update
  yay_update

  return 0
}

############################## annoyances ######################################
function sudo_rules(){
  echo "Setting sudo rules..."
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
       update_sys
       sudo_rules
       run_me
       ;;
    2)
       sym_links
       run_me
       ;;
    3)
       base_sys
       run_me
       ;;
    4)
       tudelft
       run_me
       ;;
    5)
       latitude_7440
       run_me
       ;;
    6)
       update_sys
       run_me
       ;;
    7)
       sudo_rules
       run_me
       ;;
  esac
done
