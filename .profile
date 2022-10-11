source /opt/etc/profile

# umask 022

# export PATH=/sbin:/bin:/usr/sbin:/usr/bin:/usr/syno/sbin:/usr/syno/bin:/usr/local/sbin:/usr/local/bin:/opt/bin:/opt/sbin

export TERM=${TERM:-cons25}

# export PAGER=more

# PS1="`hostname`> "

if [[ -x /opt/bin/zsh ]]; then
  export SHELL=/opt/bin/zsh
  exec /opt/bin/zsh
fi
