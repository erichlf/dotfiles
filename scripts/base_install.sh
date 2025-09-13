_run_alias_or_func() { # _run_alias_or_func <name>
  local name="$1"
  if alias "$name" >/dev/null 2>&1; then
    # Re-parse so alias expands
    eval "$name"
    return $?
  fi

  if typeset -f "$name" >/dev/null 2>&1 || declare -f "$name" >/dev/null 2>&1; then
    "$name"
    return $?
  fi

  printf 'extras: "%s" is not an alias or function in this shell\n' "$name" >&2
  return 127
}

# helpers
_do() {
  "$@"
}

function base_install() {
  source "$DOTFILES_DIR/scripts/read_yaml.sh"
  source "$DOTFILES_DIR/scripts/utils.sh"

  local system="$1"
  local file="$DOTFILES_DIR/scripts/configs/$system.yml"

  INFO "Collecting packages for $system ($file)"
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

  INFO "Creating symlinks"
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
      _do pip3_install "${pkgs[@]}"
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
        _run_alias_or_func "$x" || return $?
      done
      ;;
    *)
      ERROR 'No handler for category "%s"; items:\n' "$orig"
      ERROR '  - %s\n' "${pkgs[@]}"
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
    esac
  done

  INFO "Finished setting up system."
}
