# 🚀 Dotfiles

A comprehensive collection of configuration files for a modern development environment, featuring a highly customized LazyVim setup, zsh configuration, and automated installation scripts.

## ✨ What's Included

### Core Configurations
- **Neovim**: Heavily customized LazyVim configuration with enhanced keybindings and additional plugins
- **Zsh**: Modern shell setup using zgenom and oh-my-zsh
- **Git**: Optimized git configuration and aliases
- **Terminal**: Various terminal emulator configurations

### Key Features
- 📦 **Automated Installation**: One-command setup for new systems
- 🔗 **GNU Stow Integration**: Clean symlink management
- 🎯 **LazyVim Enhancement**: Custom keybindings and plugin configurations
- 🔧 **DevContainer Support**: Includes `nvim-devcontainer-cli` plugin
- 🌟 **Cross-Platform**: Support for multiple operating systems

## 📁 Repository Structure

```
dotfiles/
├── home/           # Files that go directly in $HOME
├── config/         # Files that go in $HOME/.config
│   └── nvim/       # LazyVim configuration
│       └── lua/user/   # Custom user configurations
├── scripts/        # Installation and utility scripts
│   ├── main.sh     # Interactive installation menu
│   └── utils.sh    # Shared functions and utilities
├── private/        # Private configurations (not tracked)
└── install.sh      # Main installation script
```

## 🚀 Quick Start

### Full Installation

Clone the repository and run the installation script:

```bash
git clone https://github.com/erichlf/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
./install.sh
```

### Dotfiles Only

If you only want to install the configuration files without additional software:

```bash
./scripts/main.sh
# Select "Create symbolic links" from the menu
```

## ⚙️ Installation Process

The installation system automatically:

1. **Detects your operating system** and selects appropriate installation scripts
2. **Installs required dependencies** based on your system
3. **Creates symbolic links** using GNU Stow for clean file management
4. **Configures shell environment** with zsh and custom themes

### Environment Variables

The installation scripts use these environment variables:

- `DOTFILES_DIR`: Path to the dotfiles repository
- `SYSTEM`: System identifier (auto-detected, used for debugging)

## 🎯 LazyVim Configuration

The crown jewel of this repository is the highly customized LazyVim configuration located in `config/nvim/`. 

### Key Improvements
- **Enhanced Keybindings**: More intuitive and efficient key mappings
- **Additional Plugins**: Including `nvim-devcontainer-cli` for container development
- **Custom User Configurations**: Located in `config/nvim/lua/user/`
- **Modular Structure**: Easy to understand and modify

### Notable Plugins
- DevContainer CLI integration
- Enhanced file navigation
- Improved LSP configurations
- Custom statusline and themes

## 🛠️ Customization

### Adding New Configurations

1. **For $HOME files**: Add to `home/` directory
2. **For $HOME/.config files**: Add to `config/` directory
3. **Run stow**: `stow home config` to create symlinks

### Modifying LazyVim

The most important customization files are in `config/nvim/lua/user/`. The naming convention is self-explanatory:

- `keymaps.lua` - Custom keybindings
- `options.lua` - Neovim options
- `plugins/` - Additional plugin configurations

## 📋 Requirements

- **Git**: For cloning the repository
- **GNU Stow**: For symlink management
- **Zsh**: Modern shell (auto-installed if not present)
- **Neovim**: Recent version for LazyVim compatibility

## 🔧 Troubleshooting

### Common Issues

1. **Stow conflicts**: Remove existing dotfiles before running installation
2. **Missing dependencies**: Run `./scripts/main.sh` and select dependency installation
3. **Permission issues**: Ensure you have write access to your home directory

### Getting Help

If you encounter issues:

1. Check the `scripts/utils.sh` for debugging functions
2. Run with `SYSTEM` variable set for additional debugging output
3. Open an issue on GitHub with your system information

## 🤝 Contributing

Feel free to:
- Report bugs or issues
- Suggest improvements
- Submit pull requests
- Share your own configurations

## 📄 License

This project is open source. Feel free to use, modify, and distribute as needed.

---

**Note**: The `private/` directory is intentionally not tracked in git and contains personal configurations that shouldn't be shared publicly.