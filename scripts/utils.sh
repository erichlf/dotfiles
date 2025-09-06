shopt -s expand_aliases

OS=$(uname -o)
KERNEL=$(uname -s)
KERNEL_RELEASE=$(uname -r)
KERNEL_VERSION=$(uname -v)
NODE=$(uname -n)

BWHITE='\033[1;37m'
GREEN='\033[0;32m'
ORANGE='\033[0;33'
RED='\033[0;31m'
BRED='\033[1;31m'
RESET='\033[0m'

function LOG() {
  echo -e "$* ${RESET}"
}

function INFO() {
  LOG "${GREEN}$*"
}

function WARN() {
  LOG "${ORANGE}$*"
}

function ERROR() {
  LOG "${RED}$*"
}

function catch() {
  echo -e "\n${BWHITE}[${BRED}ERROR${RESET}${BWHITE}]:${RESET} Installation failed, exiting script..."
  exit 1
}

function download_stdout() {
  local dl_link="${1}"
  if type wget &>/dev/null; then
    wget -qO - "${dl_link}"
  elif type curl &>/dev/null; then
    curl -s "${dl_link}"
  fi
}

# print the current system details
# this expects DOTFILES_DIR and SYSTEM to be defined
function print_details() {
  LOG "${BWHITE}" \
    "
SYSTEM:         $SYSTEM
OS:             $OS
KERNEL:         $KERNEL
KERNEL_RELEASE: $KERNEL_RELEASE
KERNEL_VERSION: $KERNEL_VERSION
NODE:           $NODE
USER:           $(whoami)
HOME:           $HOME
DOTFILES_DIR:   $DOTFILES_DIR
"
}

# function to create my links
# This expects the variable $DOTFILES_DIR to exist
function sym_links() {
  INFO "Creating symlinks..."
  mkdir -p "$HOME/.config"
  stow -v --dotfiles --adopt --dir "$DOTFILES_DIR" --target "$HOME" --restow home
  [[ -d $DOTFILES/private/.ssh ]] && stow -v --adopt --dir "$DOTFILES_DIR/private/" --target "$HOME/.ssh" --restow .ssh
  stow -v --adopt --dir "$DOTFILES_DIR" --target "$HOME/.config/" --restow config
  # if the adopt made a local change then undo that
  git checkout HEAD -- config home private

  return 0
}

function ask() {
  read -rp "$1 [$2] " answer
  answer="${answer:-$2}"
  case "$answer" in
  y | Y) return 0 ;;
  n | N) return 1 ;;
  *) ask "$1" "$2" ;;
  esac
}

############################### Ubuntu specifics #########################################
function no_ppa_exists() {
  ppa_added=$(grep ^ /etc/apt/sources.list /etc/apt/sources.list.d/* | grep -v "list.save" | grep -v "deb-src" | grep "deb" | grep -c "$1")
  [ "$ppa_added" == 0 ]
}

function add_ppa() {
  sudo add-apt-repository ppa:"$1" -y
  apt_update

  return 0
}

function apt_update() {
  sudo apt-get update 1>/dev/null
}

function apt_install() {
  sudo apt-get install -y "$@"

  return 0
}

function pac_update() {
  sudo pacman -Syu --noconfirm

  return 0
}

function pac_install() {
  sudo pacman -S --needed --noconfirm "$@"

  return 0
}

function yay_install() {
  yay -S --needed --noconfirm "$@" --mflags "--nocheck"

  return 0
}

function yay_update() {
  yay -Syu --noconfirm

  return 0
}

function brew_install() {
  brew install "$@"
}

function snap_install() {
  sudo snap install "$@"

  return 0
}

function deb_install() {
  PACKAGE=$1
  HTTP=$2

  INFO "Installing $PACKAGE"
  mkdir -p "/tmp/$PACKAGE"
  cd "/tmp/$PACKAGE" || exit 1
  wget "$HTTP"
  apt_install ./"$PACKAGE"*.deb
  cd - || exit 1
  rm -rf "/tmp/$PACKAGE"
}

function pacstall_install() {
  sudo pacstall -PIQ -Nc "$@"

  return 0
}

function pip3_install() {
  pip3 install "$@"

  return 0
}

function sudo_rule() {
  INFO "$USER ALL = NOPASSWD: $*" | sudo tee -a /etc/sudoers

  return 0
}

############################ manual install items ########################################

# setup fzf
function install_fzf() {
  mkdir -p "$HOME/.local/bin"
  rm -rf "$HOME/.fzf"
  git clone --depth 1 https://github.com/junegunn/fzf.git "$HOME/.fzf"
  cd "$HOME/.fzf" || return
  ./install --bin
  cp bin/* "$HOME/.local/bin/" | return
  cd - || return
}

# install lazygit
function install_lazygit() {
  LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | \grep -Po '"tag_name": "v\K[^"]*')
  cd /tmp || return
  curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
  tar xf lazygit.tar.gz lazygit
  install lazygit "$HOME/.local/bin"
  cd - || return
}

# setup starship
function install_starship() {
  INFO "Installing starship..."
  curl -sS https://starship.rs/install.sh -o starship.sh
  chmod +x starship.sh
  ./starship.sh -y --bin-dir "$HOME/.local/bin"
  rm -f starship.sh
}

# install the various zsh components
function zsh_extras() {
  INFO "Setting up zsh extras..."
  # install zgenom
  [ ! -d "$HOME/.zgenom" ] && git clone https://github.com/jandamm/zgenom.git "${HOME}/.zgenom"

  # install zoxide
  download_stdout https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash
}

function install_pacstall() {
  INFO "Install pacstall"
  echo Y | sudo bash -c "$(curl -fsSL https://pacstall.dev/q/install)"
}

function install_chaotic() {
  INFO "Install pacstall"
  echo N | sudo bash -c "$(curl -fsSL https://pacstall.dev/q/ppr)"
  apt_update
  apt_install \
    pacstall
}

function install_brew() {
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
}

# install rust and cargo
function install_rust() {
  INFO "Installing rust"
  curl https://sh.rustup.rs -sSf -o rust.sh
  chmod +x rust.sh
  ./rust.sh -y
  rm -rf rust.sh

  source $HOME/.cargo/env
  rustup install nightly
  rustup default nightly
}

function install_nodejs() {
  INFO "Installing NodeJS"
  # install nvm
  download_stdout https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash

  \. "$HOME/.nvm/nvm.sh"

  # Download and install Node.js:
  nvm install 22
}

function install_nvim() {
  INFO "Installing NEOVIM..."
  apt_install libfuse2 fuse3
  wget https://github.com/neovim/neovim-releases/releases/download/v0.10.1/nvim.appimage
  sudo mv nvim.appimage /usr/bin/nvim
  sudo chmod u+x /usr/bin/nvim
}
