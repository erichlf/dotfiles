function base_install() {
  local system="$1"

  if [[ "$system" == "arch" ]]; then
    INFO "Setting up an arch based system"
    if [ $(which yay) == "" ]; then
      INFO "Setting up yay..."
      [ ! -d /tmp/yay ] && git clone https://aur.archlinux.org/yay.git /tmp/yay
      cd /tmp/yay
      makepkg -si --noconfirm
      cd -
    else
      INFO "yay already installed"
    fi

    pkg_install="pac_install"
    alt_install="yay_install"
    NEOVIM="neovim"
    GO="go"
  else
    INFO "Setting up an ubuntu based system"

    pkg_install="apt_install"
    alt_install="snap_install"
    NEOVIM="nvim --classic"
    GO="go --classic"
  fi

  INFO "Setting up shell..."
  $pkg_install \
    btop \
    curl \
    fzf \
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

  starship_install

  lazygit_install

  INFO "Installing developer tools..."
  if [ ! -d "$HOME/workspace" ]; then
    mkdir -p "$HOME/workspace"
  fi

  $pkg_install \
    cmake \
    gcc \
    llvm \
    python3-setuptools

  INFO "Installing NEOVIM..."
  rust_install
  $alt_install $GO
  $alt_install $NEOVIM

  $pkg_install \
    nodejs \
    npm \
    python3-debugpy \
    python3-virtualenv \
    xclip

  mkdir -p "$HOME/.npm-global"
  npm config set prefix "$HOME/.npm-global"
  npm install -g neovim tree-sitter
  curl -sSL https://get.rvm.io | bash -s -- --auto-dotfiles

  npm install -g @devcontainers/cli

  INFO "Setting up docker..."
  $pkg_install \
    ca-certificates \
    gnupg
  if [ $system == "arch" ]; then
    DOCKER_PACKAGES="containerd docker docker-compose"
  else
    $pkg_install \
      apt-transport-https \
      ca-certificates \
      curl \
      software-properties-common

    sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | sudo tee /etc/apt/sources.list.d/docker.list >/dev/null

    apt_update
    DOCKER_PACKAGES="containerd.io docker-ce docker-ce-cli docker-buildx-plugin docker-compose-plugin"
  fi

  $pkg_install $DOCKER_PACKAGES

  sudo usermod -a -G docker "$USER"
  if [ ! "$CI" ]; then
    sudo systemctl daemon-reload
    sudo systemctl enable docker
    sudo systemctl start docker
  fi

  echo "net.core.rmem_max=26214400" | sudo tee /etc/sysctl.d/10-udp-buffer-sizes.conf
  echo "net.core.rmem_default=26214400" | sudo tee -a /etc/sysctl.d/10-udp-buffer-sizes.conf
}
