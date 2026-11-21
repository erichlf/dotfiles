# Dotfiles

A config-driven dotfiles installer. It wires up the files in this repository,
installs packages from simple YAML manifests, and runs named helper functions to
handle anything a package manager can't.

The shipped config is tailored to the author's machines, but the installer is
generic: to use this for your own setup, replace the files under `home/` and
`config/`, then write your own manifests in `scripts/configs/`.

---

## What's inside

- **`home/`** — Files destined for `$HOME`. Names use a `dot-` prefix (GNU Stow's
  dotfile convention), e.g. `home/dot-zshrc` → `~/.zshrc`.
- **`config/`** — Files destined for `$HOME/.config`, e.g. `config/nvim/` →
  `~/.config/nvim`.
- **`scripts/configs/`** — One YAML manifest per system, e.g. `ubuntu.yml`.
- **`scripts/utils.sh`** — Package-manager wrappers and named setup functions.
- **`scripts/base_install.sh`** — The installer engine that reads a manifest.
- **`scripts/read_yaml.sh`** — A small YAML list parser (no `yq` required).
- **`install.sh`** — Entry point: detects the system and picks a manifest.

Optional extras in the repo root include `vimium.json` (browser keybinds),
`resticprofile.toml` and `sanoid.conf` (backups/snapshots).

---

## Requirements

The installer needs `bash`, `git`, and network access. It installs everything
else itself, including GNU Stow (used for symlinking) and zsh. On desktop Linux
it uses `sudo`; on Termux it uses `pkg` and `chsh` instead.

---

## Quick start

```bash
# Fork this repo, then clone your fork
git clone --recurse-submodules https://github.com/YOU/dotfiles.git ~/.dotfiles
cd ~/.dotfiles

# Run the installer (detects your system from the kernel)
./install.sh
```

The installer will:

1. Detect the system and choose `scripts/configs/<system>.yml`.
2. Walk the manifest in file order, installing packages and running functions.
3. Create symlinks from `home/` and `config/` into your home directory.
4. Set zsh as your default shell.

> If you already cloned without `--recurse-submodules`, that's fine — the
> `update_git_submodules` step in each manifest fetches them.

---

## How the system is detected

`install.sh` matches `uname -r`:

| Kernel contains | Manifest | Notes |
| --- | --- | --- |
| `android` | `phone` | Termux |
| `azure` or `aws` | `ubuntu` (or `devcontainer` if `DEV_WORKSPACE` is set) | GitHub Actions |
| `generic` | `ubuntu` (or `devcontainer`) | Some containers |
| `cachyos` | `nas` | Arch-based |
| `microsoft` | `wsl` | WSL |

For anything else it uses `devcontainer` when `DEV_WORKSPACE` is set; otherwise
it exits with "Unknown system".

> **Using your own system name:** create `scripts/configs/<name>.yml` and either
> add a case to `install.sh`, or run the engine directly with
> `source scripts/base_install.sh && base_install <name>`.

---

## Manifest format

Each manifest is a sequence of top-level keys. Keys run **in the order they
appear**, and any key may appear more than once. Comments and flow-style lists
(`pkg: [git, zsh]`) are supported.

Package keys:

| Key | Package manager |
| --- | --- |
| `apt`, `apt-get` | `apt-get` (runs `apt-get update` first) |
| `pac` | `pacman` |
| `pkg` | Termux `pkg` |
| `pacstall` | `pacstall` — add `install_chaotic` in an earlier `functions:` section |
| `yay` | `yay` — add `install_yay` in an earlier `functions:` section |
| `pip`, `pip3`, `pipx` | `pip3` |
| `npm`, `node`, `npm_global` | `npm install -g` |
| `brew`, `homebrew` | Homebrew |

The `functions` key runs shell functions from `utils.sh` by name. Each section
runs wherever it appears in the file, so you can interleave packages and setup
steps freely:

```yaml
pkg:
  - git
  - stow
  - zsh
functions:
  - update_git_submodules
  - set_default_shell
  - sym_links
pip3:
  - pygments
functions:
  - zsh_extras
  - install_starship
```

These are the core setup functions shipped in `utils.sh`:

- `update_git_submodules` — `git submodule update --init --recursive`
- `set_default_shell` — sets zsh as the login shell (uses `chsh` on Termux)
- `sym_links` — runs GNU Stow for `home/` and `config/`

Other helpers you can put in `functions:` include `install_fzf`,
`install_lazygit`, `install_starship`, `install_docker`, `install_fonts`,
`install_rust`, `install_nodejs`, `install_wezterm`, `zsh_extras`, and more — see
the function list in `scripts/utils.sh`.

> `set_default_shell` defaults to the detected `SYSTEM` when called with no
> arguments.

---

## Customizing

- **Dotfiles:** edit or replace files under `home/` and `config/`. Keep the
  `dot-` prefix for files that live directly in `$HOME`.
- **Packages:** edit the manifests in `scripts/configs/`, or add a new one.
- **Setup steps:** add functions to `scripts/utils.sh` and list their names in
  a `functions:` section. Every function must return 0 on success; a non-zero
  return aborts the installer.
- **Private files:** keep local-only overrides out of Git (add them to
  `.gitignore`).

---

## Manual usage

You can run individual helpers without the full installer:

```bash
export DOTFILES_DIR="$PWD"
source scripts/utils.sh
INFO "hello"
sym_links
install_starship
```

To inspect how a manifest is parsed without executing anything:

```bash
source scripts/read_yaml.sh
collect_yaml_lists scripts/configs/ubuntu.yml --print
```

---

## Updating

```bash
cd ~/.dotfiles
git pull
./install.sh
```

Re-running the installer is safe: Stow reconciles symlinks and the package
managers skip already-installed packages.

---

## Uninstalling

There is no automatic uninstall. To reverse the symlinks:

```bash
cd ~/.dotfiles
stow -D --dotfiles --dir . --target "$HOME" home
stow -D --dir . --target "$HOME/.config" config
```

Packages installed by the manifests must be removed with your package manager.

---

## FAQ

**Q: Do I need `yq` or another YAML parser?**
No. `scripts/read_yaml.sh` parses the simple list format used here with `awk`,
so it works with BusyBox/mawk/BSD awk too. Nested YAML is not supported — keep
manifests as flat lists.

**Q: Can a key appear more than once?**
Yes, and this is intentional — repeated sections run at their position in the
file. That's how the core tools get installed before submodules and symlinks.

**Q: Which platforms are supported out of the box?**
The shipped manifests cover Termux (`phone`), Ubuntu (`ubuntu`/`devcontainer`/
CI), Arch (`nas`), and WSL (`wsl`). Add your own manifest for anything else.

**Q: macOS?**
Homebrew helpers (`brew_install`, `install_brew`) are available in `utils.sh`,
but there is no macOS manifest or kernel detection case yet.

---

## License

Open source — see the LICENSE file in the repo.
