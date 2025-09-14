#!/bin/bash

set -e

DOTFILES_DIR=$(pwd)
source "$DOTFILES_DIR/scripts/base_install.sh"

# get the kernel string
kernel=$(uname -r)
case "$kernel" in
*"android"*)
  base_install "phone"
  ;;
*"azure"*) # github action
  export CI=true
  if [[ $DEV_WORKSPACE != "" ]]; then
    base_install "devcontainer"
  else
    base_install "ubuntu"
  fi
  ;;
*"generic"*)
  if [[ $DEV_WORKSPACE != "" ]]; then
    base_install "devcontainer"
  else
    base_install "ubuntu"
  fi
  ;;
*"cachyos"*)
  base_install "nas"
  ;;
*)
  if [[ $DEV_WORKSPACE != "" ]]; then
    base_install "devcontainer"
  else
    echo \
      "
  Unknown system: $(uname -a)
  KTHNXBYE
"
    exit 1
  fi
  ;;
esac
