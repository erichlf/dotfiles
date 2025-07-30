function base_install() {
  local system="$1"

  if [[ "$system" == "arch" ]]; then
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

    pkg_install="pac_install"
    alt_install="yay_install"
  else
    INFO "Setting up an ubuntu based system"

    pkg_install="apt_install"
    alt_install="brew_install"

    INFO "Installing homebrew"
    $pkg_install \
      build-essential \
      procps \
      curl \
      file \
      git
    install_brew

  fi

  INFO "Setting up shell..."
  $pkg_install \
    btop \
    curl \
    iftop \
    pass \
    python3 \
    python3-pip \
    tmux \
    wget

  # install fonts
  mkdir -p "$HOME/.local/bin"
  curl -fsSL https://raw.githubusercontent.com/getnf/getnf/main/install.sh | bash
  "$HOME/.local/bin/getnf" -i DejaVuSansMono,DroidSansMono,Hack,Recursive,RobotoMono | true # don't fail on fonts

  zsh_extras

  install_starship

  install_lazygit

  INFO "Installing developer tools..."
  if [ ! -d "$HOME/workspace" ]; then
    mkdir -p "$HOME/workspace"
  fi

  $pkg_install \
    cmake \
    gcc \
    llvm \
    python3-setuptools

  $alt_install \
    fzf \
    lazydocker

  INFO "Installing NEOVIM"
  $alt_install nvim

  INFO "Installing LazyVim Dependencies"
  rust_install

  $alt_install \
    go \
    node \
    rust

  INFO "Installing Lazy Dependencies"
  $pkg_install \
    python3-debugpy \
    python3-virtualenv \
    xclip

  nodejs_install

  npm install -g neovim tree-sitter
  curl -sSL https://get.rvm.io | bash -s -- --auto-dotfiles

  INFO "Install Devcontainer dependencies"
  npm install -g @devcontainers/cli

  INFO "Setting up docker..."
  $pkg_install \
    ca-certificates \
    gnupg
  if [ "$system" == "arch" ]; then
    DOCKER_PACKAGES=("containerd" "docker" "docker-compose")
  else
    $pkg_install \
      apt-transport-https \
      curl \
      software-properties-common

    sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | sudo tee /etc/apt/sources.list.d/docker.list >/dev/null

    apt_update
    DOCKER_PACKAGES=("containerd.io" "docker-ce" "docker-ce-cli" "docker-buildx-plugin" "docker-compose-plugin")
  fi

  $pkg_install "${DOCKER_PACKAGES[@]}"

  sudo usermod -a -G docker "$USER"
  if [ ! "$CI" ]; then
    sudo systemctl daemon-reload
    sudo systemctl enable docker
    sudo systemctl start docker
  fi

  echo "net.core.rmem_max=26214400" | sudo tee /etc/sysctl.d/10-udp-buffer-sizes.conf
  echo "net.core.rmem_default=26214400" | sudo tee -a /etc/sysctl.d/10-udp-buffer-sizes.conf
}
