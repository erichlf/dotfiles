shopt -s expand_aliases

OS=$(uname -o)
KERNEL=$(uname -s)
KERNEL_RELEASE=$(uname -r)
KERNEL_VERSION=$(uname -v)
NODE=$(uname -n)

BWHITE='\033[1;37m'
GREEN='\033[0;32m'
ORANGE='\033[0;33m'
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
" "${RESET}"
}

# function to create my links
# This expects the variable $DOTFILES_DIR to exist
function sym_links() {
  INFO "Creating symlinks..."
  mkdir -p "$HOME/.config"
  stow -v --dotfiles --adopt --dir "$DOTFILES_DIR" --target "$HOME" --restow home
  stow -v --adopt --dir "$DOTFILES_DIR" --target "$HOME/.config/" --restow config

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
  pip3 install --break-system-packages "$@"

  return 0
}

function sudo_rule() {
  INFO "$USER ALL = NOPASSWD: $*" | sudo tee -a /etc/sudoers

  return 0
}

function npm_install() {
  sudo npm install -g "$@"
}

function go_install() {
  go install "$@"
}

function pkg_install() {
  pkg install -y "$@"
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

function install_docker() {
  if [ "$system" == "arch" ]; then
    pkg_install="pac_install"
    DOCKER_PACKAGES=("containerd" "docker" "docker-compose")
  else
    pkg_install="apt_install"
    sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | sudo tee /etc/apt/sources.list.d/docker.list >/dev/null

    apt_update
    DOCKER_PACKAGES=("docker-ce" "docker-ce-cli" "docker-buildx-plugin" "docker-compose-plugin")
  fi

  $pkg_install "${DOCKER_PACKAGES[@]}"

  sudo usermod -a -G docker "$USER"
  if [ ! "$CI" ]; then
    sudo systemctl daemon-reload
    sudo systemctl enable docker
    sudo systemctl start docker
  fi
}

function install_fonts() {
  mkdir -p "$HOME/.local/bin"
  curl -fsSL https://raw.githubusercontent.com/getnf/getnf/main/install.sh | bash
  "$HOME/.local/bin/getnf" -i DejaVuSansMono,DroidSansMono,Hack,Recursive,RobotoMono | true # don't fail on fonts
}

function increase_network_kernel_mem() {
  echo "net.core.rmem_max=26214400" | sudo tee /etc/sysctl.d/10-udp-buffer-sizes.conf
  echo "net.core.rmem_default=26214400" | sudo tee -a /etc/sysctl.d/10-udp-buffer-sizes.conf
}

function install_rvm() {
  curl -sSL https://get.rvm.io | bash -s -- --auto-dotfiles
}

function install_1password() {
  deb_install 1password https://downloads.1password.com/linux/debian/amd64/stable/1password-latest.deb
  # add 1password support to vivaldi
  sudo mkdir -p /etc/1password
  echo "vivalid" | sudo tee /etc/1password/custom_allowed_browsers
  sudo chown root:root /etc/1password/custom_allowed_browsers
  sudo chmod 755 /etc/1password/custom_allowed_browsers
}

function install_vivaldi() {
  deb_install vivaldi https://downloads.vivaldi.com/stable/vivaldi-stable_7.5.3735.54-1_amd64.deb
}

function devcontainer_extras() {
  # change to zsh as default shell
  sudo chsh -s /usr/bin/zsh

  # ensure that .config is owned by the current user
  if [[ -d $HOME/.config && ! $(stat -c "%U" "$HOME/.config") == "$(whoami)" ]]; then
    sudo chown "$(id -u)":"$(id -g)" "$HOME/.config"
  fi

  sudo ln -sf /usr/bin/clang-19 /usr/bin/clang || true
  sudo ln -sf /usr/bin/clang++-19 /usr/bin/clang++ || true

  # hack to get the proper shell to open when using devcontainer connect and nvim
  echo "export SHELL=zsh" >>"$HOME/.profile"
}

function install_yay() {
  INFO "Setting up an arch based system"
  if [ "$(which yay)" == "" ]; then
    INFO "Setting up yay..."
    [ ! -d /tmp/yay ] && git clone https://aur.archlinux.org/yay.git /tmp/yay
    cd /tmp/yay || exit 1
    makepkg -si --noconfirm
    cd - || exit 1
  else
    INFO "yay already installed"
  fi
}

function nas_extras() {
  WARNING "Remember to create ntfy config at /root/.config/ntfy/ntfy.yml"

  sudo systemctl enable --now sshd
  sudo systemctl enable --now cockpit.socket

  # zfs mainenance
  sudo cp "$DOTFILES_DIR/sanoid.conf" /etc/sanoid/
  sudo systemctl daemon-reload
  sudo systemctl enable --now sanoid.timer sanoid-prune.service
  sudo systemctl enable --now zfs-scrub-weekly@zpcachyos.timer
  sudo systemctl enable --now zfs-scrub-monthly@media.timer

  # allow ufw to manage docker traffic
  sudo iptables -I DOCKER-USER -i enp4s0 -s 192.168.1.0/24 -j ACCEPT
  sudo iptables -I DOCKER-USER -i enp5s0 -s 192.168.1.0/24 -j ACCEPT
}

function install_devcontainer_cli() {
  export OS=linux   # also darwin
  export ARCH=amd64 # also 386
  cd /tmp
  wget https://raw.githubusercontent.com/stuartleeks/devcontainer-cli/main/scripts/install.sh
  chmod +x install.sh
  sudo -E ./install.sh
  cd -
}

function guake_config() {
  guake --no-startup-script --restore-preferences "$DOTFILES_DIR/guake.conf"
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
  INFO "GOROOT=$(go env GOROOT)"
  INFO "GOPATH=$(go env GOPATH)"
  go_install google.golang.org/protobuf/cmd/protoc-gen-go@latest
  go_install google.golang.org/grpc/cmd/protoc-gen-go-grpc@latest

  if [ ! -d "$HOME/.local/balena" ]; then
    INFO "Installing balena"
    mkdir -p "$HOME/.local"
    mkdir -p /tmp/balena
    cd /tmp/balena
    RELEASE=v22.1.1
    BALENA="balena-cli-$RELEASE-linux-x64-standalone.tar.gz"
    wget https://github.com/balena-io/balena-cli/releases/download/$RELEASE/$BALENA
    tar xzvf $BALENA
    mv balena "$HOME/.local/"
    cd -
    rm -rf /tmp/balena
  fi

  if [ "$(which aws)" == "" ]; then
    INFO "Installing AWS"
    mkdir -p /tmp/aws
    cd /tmp/aws
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
    unzip awscliv2.zip
    sudo ./aws/install
    cd -
    rm -rf /tmp/aws
  fi

  if [ ! "$CI" ]; then # avoid issue with CI and uv_cwd
    INFO "Installing Yarn"
    npm_install --global yarn
  fi

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
  mkdir -p /tmp/tailscale
  cd /tmp/tailscale
  curl -fsSL https://tailscale.com/install.sh | sh
  cd -
  rm -rf /tmp/tailscale

  if [ "$(which foxglove)" == "" ]; then
    deb_install foxglove https://get.foxglove.dev/desktop/latest/foxglove-studio-latest-linux-amd64.deb
  fi

  INFO "Installing wireshark"
  apt_install wireshark

  if [ "$(which QGroundControl)" == "" ]; then
    INFO "Installing QGroundControl"
    sudo usermod -a -G dialout "$USER"
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

  # INFO "Installing drivers"
  # sudo add-apt-repository -y --remove ppa:oem-solutions-group/intel-ipu6
  # sudo add-apt-repository -y --remove ppa:oem-solutions-group/intel-ipu7
  # sudo add-apt-repository ppa:oem-solutions-engineers/oem-projects-meta
  #
  # sudo apt autopurge -y oem-*-meta libia-* libgcss* libipu* libcamhal*
  # sudo apt autopurge -y lib*ipu6*
  # sudo apt autopurge -y lib*ipu7*
  #
  # apt_install \
  #   ubuntu-oem-keyring
  # sudo add-apt-repository -y "deb http://dell.archive.canonical.com/ noble somerville"
  # apt_update
  # apt_install \
  #   oem-somerville-magmar-meta \
  #   libcamhal0
  # apt_install \
  #   intel-ipu6-dkms \
  #   linux-generic-hwe-24.04 \
  #   linux-modules-ipu6-generic-hwe-24.04 \
  #   linux-modules-usbio-generic-hwe-24.04 \
  #   oem-somerville-magmar-meta \
  #   oem-somerville-tentacool-meta
  # sudo apt-get autoclean
  # sudo apt-get autoremove
  #
  # sudo usermod -a -G video "$USER"
}
