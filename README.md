# dotfiles

This repo contains all my config files.

## Contents

The main things in this are a highly modified lunarvim, a basic setup of zsh
using zgenom and oh-my-zsh. All dotfiles are installed via stow.
`$DOTFILES/home` contains all the dotfiles that go directly in `$HOME`,
while `$DOTFILES/config` contains all the dotfiles that go in `$HOME/config`.
And we don't talk about `$DOTFILES/private`.

Honestly the most useful thing in hear for those that are looking would be
the configuration of lunarvim, which can be found in `$DOTFILES/config/lvim`.
This contains a lunarvim config with, in my opinion, a much better set of
keybindings, and additional plugins like `nvim-devcontainer-cli`. There are
some less important plugins in there, but maybe the most interesting thing is
that it is an example of how to highly modify lunarvim. The most important
files are in `$DOTFILES/config/lvim/lua/user`. The naming should be mostly
self-explanatory.

## Install

I have a single `install.sh` that determines the current system and then calls
the appropriate install script (defined in `scripts`) from there. For
consistency any manually installed items and functions are defined in
`scripts/utils.sh`. The install process is as simple as running `./install.sh`,
while located in the `DOTFILES_DIR`. Some of the functions in `scrips/utils.sh`
do expect both `SYSTEM` and `DOTFILES` to be defined. `SYSTEM` is simply the
the name given to your current system. It can be anything you like and is mostly
there for debugging.

If all you are interested in is installing the dotfiles I would recommend running
`./scripts/main.sh` and selecting the menu item corresponding to "Create symbolic
links".
