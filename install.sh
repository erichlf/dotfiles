#!/bin/bash

set -e

# get the kernel string
kernel=$(uname -r)
case "$kernel" in
  *"android"* )
    ./scripts/phone.sh
    ;;
  *"azure"* ) # github action
    export CI=true
    ./scripts/main.sh
    ;;
  *"generic"* ) # ubuntu
    ./scripts/devcontainer.sh
    ;;
  *"manjaro"* )
    ./scripts/main.sh
    ;;
  *"qnap"* )
    ./scripts/nas.sh
    ;;
  *)
    if [[ $(uname -o) == "Darwin" ]]; then
      ./scripts/mac.sh
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

