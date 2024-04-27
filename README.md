# dotfiles

This repo contains all my config files.

## Contents

The main things in this are a highly modified lunarvim, a basic setup of zsh
using zgenom and oh-my-zsh. All dotfiles are installed via stow.
`$DOTFILES/my-home` contains all the dotfiles that go directly in `$HOME`,
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

To install everythings, which is quite a bit and almost certainly
not what you really want to do, just run `./install.sh`. This will bring up a
UI that allows you to select the features you want to install. There is a menu
item for installing the dotfiles only. If you are reading this it is most
likely what you would want.
