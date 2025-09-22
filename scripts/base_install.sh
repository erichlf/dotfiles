# helpers
_do() {
  "$@"
}

function base_install() {
  local SYSTEM="$1"

  local file="$DOTFILES_DIR/scripts/configs/$SYSTEM.yml"
  source "$DOTFILES_DIR/scripts/read_yaml.sh"
  source "$DOTFILES_DIR/scripts/utils.sh"

  print_details

  INFO "Collecting packages for $SYSTEM ($file)"
  collect_yaml_lists "$file"

  local i name orig
  # run the most basic install first then run some required commands

  INFO "Running base program install"
  for i in "${!categories[@]}"; do
    name="${categories[$i]}"
    orig="${orig_keys[$i]}"

    # materialize the dynamically-named array into pkgs[]
    eval 'pkgs=( "${'"$name"'[@]}" )'

    [ ${#pkgs[@]} -eq 0 ] && continue

    case "$orig" in
    base-ubuntu)
      _do apt_update
      _do apt_install "${pkgs[@]}"
      ;;
    base-arch)
      _do pac_install "${pkgs[@]}"
      ;;
    base-phone)
      _do pkg_install "${pkg[@]}"
      ;;
    esac
  done

  INFO "Updated dotfile submodules"
  git submodule update --init --recursive

  INFO "Setting zsh as default shell"
  sudo usermod -s "$(which zsh)" "$(whoami)"

  sym_links

  INFO "Running system install"
  for i in "${!categories[@]}"; do
    name="${categories[$i]}"
    orig="${orig_keys[$i]}"

    # materialize the dynamically-named array into pkgs[]
    eval 'pkgs=( "${'"$name"'[@]}" )'

    [ ${#pkgs[@]} -eq 0 ] && continue

    case "$orig" in
    pacstall)
      _do pacstall_install "${pkgs[@]}"
      ;;
    pac)
      _do pac_install "${pkgs[@]}"
      ;;
    yay)
      _do yay_install "${pkgs[@]}"
      ;;
    apt | apt-get)
      _do apt_update
      _do apt_install "${pkgs[@]}"
      ;;
    pkg)
      _do pkg_install "${pkgs[@]}"
      ;;
    pip | pip3 | pipx)
      if [ $SYSTEM == "devcontainer" ]; then
        _do pip3_install "${pkgs[@]}"
      else
        _do pip3_install --break-system-packages "${pkgs[@]}"
      fi
      ;;
    npm | node | npm_global)
      _do npm_install "${pkgs[@]}"
      ;;
    brew | homebrew)
      _do brew_install "${pkgs[@]}"
      ;;
    extras)
      local x
      for x in "${pkgs[@]}"; do
        _do "$x" || return $?
      done
      ;;
    base-ubuntu | base-arch | base-phone | final-ubuntu | final-arch | final-phone | final-extras)
      continue
      ;;
    *)
      WARN "No handler for category '$orig'; items:"
      WARN "  - '${pkgs[@]}'"
      ;;
    esac
  done

  INFO "Running any final setups"
  for i in "${!categories[@]}"; do
    name="${categories[$i]}"
    orig="${orig_keys[$i]}"

    # materialize the dynamically-named array into pkgs[]
    eval 'pkgs=( "${'"$name"'[@]}" )'

    [ ${#pkgs[@]} -eq 0 ] && continue

    case "$orig" in
    final-ubuntu)
      _do apt_install "${pkgs[@]}"
      ;;
    final-arch)
      _do pac_install "${pkgs[@]}"
      ;;
    final-phone)
      _do pkg_install "${pkg[@]}"
      ;;
    final-extras)
      local x
      for x in "${pkgs[@]}"; do
        _do "$x" || return $?
      done
      ;;
    esac
  done

  INFO "Finished setting up system."
}
