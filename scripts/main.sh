#!/bin/bash
set -e

SYSTEM="MAIN"
cd "$(dirname "$0")/.."
DOTFILES_DIR=$(pwd)

source "$DOTFILES_DIR/scripts/utils.sh"
source "$DOTFILES_DIR/scripts/base_install.sh"

print_details

THIS=$0

apt_install \
  build-essential \
  dialog \
  git \
  stow \
  zsh

############################# grab dotfiles ####################################
# dotfiles already exist since I am running this script!
# git clone git@github.com:erichlf/dotfiles.git
git submodule update --init --recursive

sudo usermod -s $(which zsh) $(whoami)

cmd=(
  dialog
  --clear
  --cancel-label "Exit"
  --backtitle "system setup"
  --menu "Welcome to Erich's system setup.\nWhat would you like to do?"
  14 50 16
)

options=(1 "Fresh system setup"
  2 "Create symbolic links"
  3 "Install base system"
  4 "Update system"
  5 "sudo rules"
  6 "Install HavocAI Specifics"
)

if [ "$CI" ]; then
  choices=1
else
  choices=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)
fi

function run_me() {
  [ "$CI" ] && exit
  bash "$THIS"
}

############################# my base system ###################################
#bikeshed contains utilities such as purge-old-kernels
function base_sys() {
  INFO "Installing base system"
  base_install "ubuntu"

  INFO "Installing extras..."
  apt_install \
    gnome-tweaks \
    libgtk-3-dev \
    guake \
    meld

  snap_install \
    obsidian --classic

  guake --restore-preferences "$DOTFILES_DIR/guake.conf"

  snap_install \
    1password \
    signal-desktop \
    slack \
    vivaldi

  apt_install \
    gnome-browser-connector

  # add 1password support to vivaldi
  sudo mkdir -p /etc/1password
  echo "vivalid.vivaldi-stable" | sudo tee /etc/1password/custom_allowed_browsers
  sudo chown root:root /etc/1password/custom_allowed_browsers
  sudo chmod 755 /etc/1password/custom_allowed_browsers

  return 0
}

########################## update and upgrade ##################################
function update_sys() {
  INFO "Updating system..."
  if [ "$CI" ]; then
    return 0
  fi

  apt_update

  return 0
}

############################## annoyances ######################################
function sudo_rules() {
  INFO "Setting sudo rules..."
  sudo_rule /sbin/shutdown
  sudo_rule /sbin/reboot

  return 0
}

# install HavocAI specifics
function havoc() {
  INFO "Installing HavocAI Specifics"
  INFO "Installing gRPC"
  go install google.golang.org/protobuf/cmd/protoc-gen-go@latest
  go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@latest

  if [ ! -d $HOME/.local/balena ]; then
    INFO "Installing balena"
    mkdir -p $HOME/.local
    mkdir -p /tmp/balena
    cd /tmp/balena
    RELEASE=v22.1.1
    BALENA="balena-cli-$RELEASE-linux-x64-standalone.tar.gz"
    wget https://github.com/balena-io/balena-cli/releases/download/$RELEASE/$BALENA
    tar xzvf $BALENA
    mv balena $HOME/.local/
    rm -rf /tmp/balena
  fi

  if [ $(which aws) == "" ]; then
    INFO "Installing AWS"
    mkdir -p /tmp/aws
    cd /tmp/aws
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
    unzip awscliv2.zip
    sudo ./aws/install
    rm -rf /tmp/aws
  fi

  INFO "Installing Yarn"
  npm install --global yarn

  INFO "Installing Nvidia Container Toolkit"
  curl -fsSL https://nvidia.github.io/libnvidia-container/gpgkey | sudo gpg --dearmor -o /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg &&
    curl -s -L https://nvidia.github.io/libnvidia-container/stable/deb/nvidia-container-toolkit.list |
    sed 's#deb https://#deb [signed-by=/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg] https://#g' |
      sudo tee /etc/apt/sources.list.d/nvidia-container-toolkit.list
  apt_update
  export NVIDIA_CONTAINER_TOOLKIT_VERSION=1.17.8-1
  apt_install \
    nvidia-container-toolkit=${NVIDIA_CONTAINER_TOOLKIT_VERSION} \
    nvidia-container-toolkit-base=${NVIDIA_CONTAINER_TOOLKIT_VERSION} \
    libnvidia-container-tools=${NVIDIA_CONTAINER_TOOLKIT_VERSION} \
    libnvidia-container1=${NVIDIA_CONTAINER_TOOLKIT_VERSION}

  INFO "Installing Tailscale"
  curl -fsSL https://pkgs.tailscale.com/stable/ubuntu/jammy.noarmor.gpg | sudo tee /usr/share/keyrings/tailscale-archive-keyring.gpg >/dev/null
  curl -fsSL https://pkgs.tailscale.com/stable/ubuntu/jammy.tailscale-keyring.list | sudo tee /etc/apt/sources.list.d/tailscale.list
  apt_update
  apt_install tailscale

  if [ $(which foxglove) == "" ]; then
    INFO "Install foxglove"
    mkdir -p /tmp/foxglove
    cd /tmp/foxglove
    wget https://get.foxglove.dev/desktop/latest/foxglove-studio-latest-linux-amd64.deb
    apt_install ./foxglove-studio-*.deb
    cd -
    rm -rf /tmp/foxglove
  fi

  INFO "Installing wireshark"
  apt_install wireshark

  if [ $(which QGroundControl) == "" ]; then
    INFO "Installing QGroundControl"
    sudo usermod -a -G dialout $USER
    sudo apt-get remove modemmanager -y
    apt_install \
      gstreamer1.0-gl \
      gstreamer1.0-libav \
      gstreamer1.0-plugins-bad \
      libfuse2 \
      libqt5gui5
    wget https://d176tv9ibo4jno.cloudfront.net/latest/QGroundControl.AppImage
    sudo mv QGroundControl.AppImage /usr/bin/QGroundControl
    sudo chmod u+x /usr/bin/QGroundControl
  fi
}

for choice in $choices; do
  case $choice in
  1)
    sym_links
    base_sys
    update_sys
    sudo_rules
    havoc
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
    update_sys
    run_me
    ;;
  5)
    sudo_rules
    run_me
    ;;
  6)
    havoc
    run_me
    ;;
  esac
done
