# If not running interactively, don't do anything
# [ -z "$PS1" ] && return
#if [ -f $HOME/.local_bashrc ]; then
#    source $HOME/.local_bashrc
#fi

# make sure tab completion is working for apt and sudo
complete -cf sudo
complete -cf apt-get
complete -cf git

set -o notify
set -o ignoreeof

# Enable options:
shopt -s cdspell
shopt -s cdable_vars
shopt -s checkhash
shopt -s checkwinsize
shopt -s sourcepath
shopt -s no_empty_cmd_completion
shopt -s cmdhist
shopt -s histappend histreedit histverify
shopt -s extglob       # Necessary for programmable completion.
shopt -u nocaseglob    # I want things to be case sensitive

# Disable options:
shopt -u mailwarn
unset MAILCHECK        # Don't want my shell to warn me of incoming mail.

# up and down does autocomplete from history
if [[ $- == *i* ]]; then
    bind '"\e[A":history-search-backward'
    bind '"\e[B":history-search-forward'
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    source /etc/bash_completion
fi

#-------------------------------------------------------------
# add .bash_exports
#-------------------------------------------------------------
[ -f $HOME/.bash_exports ] && source $HOME/.bash_exports

#-------------------------------------------------------------
# add .bash_aliases
#-------------------------------------------------------------
[ -f $HOME/.bash_aliases ] && source $HOME/.bash_aliases

#-------------------------------------------------------------
# add git-subrepo
#-------------------------------------------------------------
[ -f $HOME/.config/git-subrepo/.rc ] && source $HOME/.config/git-subrepo/.rc

BASE16_SHELL=$HOME/dotfiles/base16-shell/
[ "${-#*i}" != "$-" ] && [ -n "$PS1"  ] && [ -s $BASE16_SHELL/profile_helper.sh  ] && eval "$($BASE16_SHELL/profile_helper.sh)"

if [ -e /usr/share/powerline/bindings/bash/powerline.sh ]; then
    POWERLINE_SCRIPT=/usr/share/powerline/bindings/bash/powerline.sh
else
    POWERLINE_SCRIPT=/volume1/\@appstore/py3k/usr/local/lib/python3.5/site-packages/powerline/bindings/bash/powerline.sh
fi

if [ -x "$(command -v powerline-daemon)" ]; then
    powerline-daemon -q
    POWERLINE_BASH_CONTINUATION=1
    POWERLINE_BASH_SELECT=1
    source $POWERLINE_SCRIPT
else
    PS1='\[\e[0;1m\]┌─[\[\e[32;1m\]\u\[\e[34;1m\]@\[\e[31;1m\]\H\[\e[0;1m\]:\[\e[33;1m\]\w\[\e[0;1m\]]$(type -t __git_ps1 >& /dev/null && __git_ps1)'$'\n└→ \[\e[0m\]'
fi