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
  local -a pkgs

  # Submodules, default shell and symlinks are declared as extras in the config.
  INFO "Running system install"
  for i in "${!categories[@]}"; do
    name="${categories[$i]}"
    orig="${orig_keys[$i]}"

    # materialize the dynamically-named array into pkgs[]
    eval 'pkgs=( "${'"$name"'[@]}" )'

    [ ${#pkgs[@]} -eq 0 ] && continue

    case "$orig" in
    pacstall)
      INFO "Installing pacstall packages: ${pkgs[*]}"
      _do pacstall_install "${pkgs[@]}"
      ;;
    pac)
      INFO "Installing pac packages: ${pkgs[*]}"
      _do pac_install "${pkgs[@]}"
      ;;
    yay)
      INFO "Installing yay packages: ${pkgs[*]}"
      _do yay_install "${pkgs[@]}"
      ;;
    apt | apt-get)
      INFO "Installing apt packages: ${pkgs[*]}"
      _do apt_update
      _do apt_install "${pkgs[@]}"
      ;;
    pkg)
      INFO "Installing pkg packages: ${pkgs[*]}"
      _do pkg_install "${pkgs[@]}"
      ;;
    pip | pip3 | pipx)
      INFO "Installing pip3 packages: ${pkgs[*]}"
      _do pip3_install --break-system-packages "${pkgs[@]}"
      ;;
    npm | node | npm_global)
      INFO "Installing npm packages: ${pkgs[*]}"
      _do npm_install "${pkgs[@]}"
      ;;
    brew | homebrew)
      INFO "Installing brew packages: ${pkgs[*]}"
      _do brew_install "${pkgs[@]}"
      ;;
    extras)
      INFO "Running extras: ${pkgs[*]}"
      local x
      for x in "${pkgs[@]}"; do
        _do "$x" || return $?
      done
      ;;
    *)
      WARN "No handler for category '$orig'; items:"
      WARN "  - '${pkgs[@]}'"
      ;;
    esac
  done

  INFO "Finished setting up system."
}
