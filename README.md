# Dotfiles

A curated set of dotfiles and scripts to bootstrap a comfortable, modern dev
environment. It includes shell configuration (zsh), a Lua-based Neovim setup,
and a small set of helper scripts to install prerequisites and symlink
everything into place.

---

## What’s inside

- **`home/`** — Files intended to live directly under `$HOME` (e.g., shell RCs).
- **`config/`** — Files for `$HOME/.config` (e.g., `nvim/` for the Neovim config
  written in Lua).
- **`scripts/`** — Helper/installer scripts used during setup.
- **`install.sh`** — One-shot installer that orchestrates the setup.
- Extras:
  - `guake.conf` (terminal), `vimium.json` (browser Vim keybinds),
    `resticprofile.toml`, `sanoid.conf` (backup/snapshots).

> The repository is primarily **Lua** and **Shell**, reflecting the Neovim
  config plus installer scripts.

---

## Quick start

> **Requirements:** `git` and a POSIX-like environment (Linux/macOS). The
installer will try to install anything else it needs (e.g., zsh, Neovim)
depending on your system.

```bash
# clone
git clone https://github.com/erichlf/dotfiles.git ~/.dotfiles
cd ~/.dotfiles

# run the installer
./install.sh
```

What the installer typically does:

1. Detects your OS/distro.
2. Installs or updates core tools (zsh, neovim, etc.) as needed.
3. Creates symlinks from the repo to your `$HOME` and `$HOME/.config`.
4. Optionally applies terminal/editor/browser extras.

> Prefer to do things manually? See **Manual linking** below.

---

## Manual linking (advanced)

If you’d rather link files yourself:

1. Copy or symlink anything under `home/` into `$HOME`.
2. Copy or symlink anything under `config/` into `$HOME/.config`.
3. Launch a new shell to pick up zsh config; start `nvim` to let plugins finish bootstrapping.

> Tip: If you use GNU Stow, you can mirror `home/` and `config/` into place
cleanly (not required by the repo, but convenient).

---

## Updating

```bash
cd ~/.dotfiles
git pull
# re-run the installer if you want it to reconcile changes
./install.sh
```

---

## Uninstalling / reverting

There is no method right now to uninstall. However, you can remove symlinks you
created and/or restore your previous dotfiles backup. If you used Stow,
`stow -D <package>` will reverse those links. To remove packages it would be
more of a manual operation by reading what pacakges were installed and then
uninstalling them.

---

## Repository layout

```
dotfiles/
├─ home/             # items that should live directly in $HOME
├─ config/           # items for $HOME/.config (e.g., nvim/)
├─ scripts/          # installer and helper scripts
├─ install.sh        # main entry point for setup
├─ guake.conf        # terminal config (optional)
├─ vimium.json       # browser keybindings (optional)
├─ resticprofile.toml# restic profiles (optional)
├─ sanoid.conf       # zfs-auto-snapshot profiles (optional)
└─ private/          # local-only overrides (not tracked)
```

(See the repo root for the actual files and directories.)

---

## FAQ

**Q: Can I pick and choose?**
Yes. Run `source scripts/utils.sh` and then run the commands you'd like to run.

**Q: macOS or Linux?**
Both are supported; but currently `install.sh` focuses on android (termux),
cachyos, and ubuntu.

**Q: What keys are supported in the yaml files?**

Every key runs in the order it appears in the file; package keys may appear more
than once, with each section installed separately:

- apt-get, apt: uses apt-get to install packages
- pac: uses pacman to install packages
- pkg: uses termux pkg to install packages
- pacstall: uses pacstall to install packages; add `install_chaotic` to an earlier
  `functions` section
- yay: uses yay to install packages; add `install_yay` to an earlier `functions` section
- pip3, pip, pipx: uses pip3 to install packages
- npm, node, npm_global: uses npm to install packages
- brew, homebrew: uses brew to install packages
- functions: runs shell functions (sourced from `utils.sh`) by name. This key may
  appear more than once; each section runs wherever it appears in the file.
  The core setup steps `update_git_submodules`, `set_default_shell`, and `sym_links`
  are listed in the first `functions` section of each config. `set_default_shell`
  defaults to the current `SYSTEM` when called with no arguments.

---

## License

Open source—see the LICENSE file in the repo.
