#!/bin/bash

set -e

# get the kernel string
os=$(uname -o)

if [[ "$os" == "GNU/Linux" ]]; then
  kernel=$(uname -r)
  case "$kernel" in
    *"azure"* ) # github action
        export CI=true
        ./scripts/main.sh
        ;;
    *"generic"* ) # ubuntu
      if [[ $DEV_WORKSPACE != "" ]]; then
        ./scripts/devcontainer.sh
      else
        ./scripts/main.sh
      fi
      ;;
    *"qnap"* )
      ./scripts/nas.sh
      ;;
    *)
      echo \
"
  Uknown kernel: $kernel
  KTHNXBYE
"
      ;;
  esac
elif [[ "$os" == "Android" ]]; then
  ./scripts/phone.sh
elif [[ "$os" == "Darwin" ]]; then
  ./scripts/mac.sh
else
  echo \
"
  Unknown system: $os
  KTHNXBYE
"
  exit 1
fi

