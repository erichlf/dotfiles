# automatically run `zgenom reset` if we modify our .zshrc
ZGEN_RESET_ON_CHANGE=("${HOME}/.zshrc")

# load zgenom
source "${HOME}/.zgenom/zgenom.zsh"

zgenom selfupdate

# if the init scipt doesn't exist
if ! zgenom saved; then
    zgenom ohmyzsh

    # plugins
    zgenom ohmyzsh plugins/1password
    zgenom ohmyzsh plugins/colored-man-pages
    zgenom ohmyzsh plugins/colorize
    zgenom ohmyzsh plugins/command-not-found
    zgenom ohmyzsh plugins/common-aliases
    zgenom ohmyzsh plugins/copyfile
    zgenom ohmyzsh plugins/copypath
    zgenom ohmyzsh plugins/cp
    zgenom ohmyzsh plugins/dirhistory
    zgenom ohmyzsh plugins/docker
    zgenom ohmyzsh plugins/docker-compose
    zgenom ohmyzsh plugins/emacs
    zgenom ohmyzsh plugins/fzf
    zgenom ohmyzsh plugins/git
    zgenom ohmyzsh plugins/git
    zgenom ohmyzsh plugins/man
    zgenom ohmyzsh plugins/pass
    zgenom ohmyzsh plugins/rsync
    zgenom ohmyzsh plugins/safe-paste
    zgenom ohmyzsh plugins/sudo
    zgenom ohmyzsh plugins/sudo
    zgenom ohmyzsh plugins/ubuntu
    zgenom ohmyzsh plugins/web-search
    zgenom ohmyzsh plugins/zsh-interactive-cd

    zgenom load zsh-users/zsh-autosuggestions
    zgenom load zsh-users/zsh-history-substring-search
    zgenom load zsh-users/zsh-syntax-highlighting

    # theme
    # zgenom ohmyzsh themes/arrow

    # save all to init script
    zgenom save
fi

# automatically upgrade ohmyzsh without asking
DISABLE_UPDATE_PROMPT=true
zstyle ':omz:update' mode auto      # update automatically without asking

# enable command auto-correction.
ENABLE_CORRECTION="true"

# display red dots whilst waiting for completion.
COMPLETION_WAITING_DOTS="true"

extensions=(
  1password.plugin.zsh
  zmv
  zcp
  zln
)

for extension in $extensions; do
  autoload -U $extension;
done

# no point in rewriting my aliases
[ -f ~/.exports ] && source ~/.exports
[ -f ~/.aliases ] && source ~/.aliases

eval "$(zoxide init --cmd cd zsh)"

setopt nonomatch

eval "$(starship init zsh)"

set -o vi
