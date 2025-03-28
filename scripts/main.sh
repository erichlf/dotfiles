#!/bin/bash
set -e

SYSTEM="MAIN"
cd "$(dirname "$0")/.."
DOTFILES_DIR=$(pwd)

source "$DOTFILES_DIR/scripts/utils.sh"
source "$DOTFILES_DIR/scripts/base_install.sh"

print_details

THIS=$0

pac_install \
    base-devel \
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
  4 "Install TU Delft tools"
  5 "Latitude 7440 Hacks"
  6 "Update system"
  7 "sudo rules")

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
  echo "Installing base system"
  base_install

  echo "Installing extras..."
  pac_install \
    gnome-shell-extension-appindicator \
    gnome-tweaks \
    gtk3 \
    guake \
    meld \
    networkmanager-openvpn \
    networkmanager-vpnc \
    obsidian 

  guake --restore-preferences "$DOTFILES_DIR/guake.conf"
  gnome-extensions enable appindicatorsupport@rgcjonas.gmail.com
  gnome-extensions enable pamac-updates@manjaro.org

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

function tudelft() {
  curl https://app.eduvpn.org/linux/v4/deb/app+linux@eduvpn.org.asc | gpg --import -

  yay_install \
    python-eduvpn-client \
    teams-for-linux-bin

  return 0
}

########################## Computer Specific ####################################
function latitude_7440() {
  # install drivers for intel webcam
  pac_install libdrm
  git clone git@github.com:stefanpartheym/archlinux-ipu6-webcam.git /tmp/archlinux-ipu6-webcam
  cd /tmp/archlinux-ipu6-webcam
  git apply "$DOTFILES_DIR/scripts/patches/intel_webcam.patch"
  ./install.sh

  # install driver for fingerprint scanner, enable it, and enroll left and right
  # index fingers
  pac_install libfprint-2-tod1-broadcom fprintd libpam-fprintd
  sudo fprintd-enroll -f left-index-finger
  sudo fprintd-enroll -f right-index-finger
  sudo pam-auth-update --enable fprintd
}

########################## update and upgrade ##################################
function update_sys() {
  echo "Updating system..."
  if [ "$CI" ]; then
    return 0
  fi

  pac_update
  yay_update

  return 0
}

############################## annoyances ######################################
function sudo_rules() {
  echo "Setting sudo rules..."
  sudo_rule /sbin/shutdown
  sudo_rule /sbin/reboot

  return 0
}

for choice in $choices; do
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
