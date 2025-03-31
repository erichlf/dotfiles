function base_install() {
  echo "Setting up yay..."
  [ ! -d /tmp/yay ] && git clone https://aur.archlinux.org/yay.git /tmp/yay
  cd /tmp/yay
  makepkg -si --noconfirm
  cd -

  echo "Setting up shell..."
  pac_install \
    btop \
    curl \
    fzf \
    iftop \
    pass \
    python \
    python-pip \
    tmux \
    wget

  zsh_extras

  starship_install

  lazygit_install

  echo "Setting up networking..."
  pac_install \
    openssh

  echo "Installing developer tools..."
  if [ ! -d "$HOME/workspace" ]; then
    mkdir -p "$HOME/workspace"
  fi

  pac_install \
    cmake \
    gcc \
    llvm \
    python-setuptools

  yay_install \
    dust \
    git-completion \
    lazydocker

  echo "Installing NEOVIM..."
  pac_install \
    chafa \
    git-lfs \
    go \
    neovim \
    nodejs \
    npm \
    python-debugpy \
    python-gitpython \
    python-pynvim \
    python-ply \
    python-ruff \
    python-virtualenv \
    python-yaml \
    rust \
    xclip

  mkdir -p "$HOME/.npm-global"
  npm config set prefix "$HOME/.npm-global"
  npm install -g neovim tree-sitter
  curl -sSL https://get.rvm.io | bash -s -- --auto-dotfiles

  npm install -g @devcontainers/cli

  echo "Setting up docker..."
  pac_install \
    ca-certificates \
    containerd \
    docker \
    docker-compose \
    gnupg

  sudo usermod -a -G docker "$USER"
  if [ ! "$CI" ]; then
    sudo systemctl daemon-reload
    sudo systemctl enable docker
    sudo systemctl start docker
  fi

  echo "net.core.rmem_max=26214400" | sudo tee /etc/sysctl.d/10-udp-buffer-sizes.conf
  echo "net.core.rmem_default=26214400" | sudo tee -a /etc/sysctl.d/10-udp-buffer-sizes.conf
}
