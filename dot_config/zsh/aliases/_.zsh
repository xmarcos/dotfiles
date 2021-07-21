# shellcheck shell=bash

# Enable aliases to be sudo'ed
# http://askubuntu.com/questions/22037/aliases-not-available-when-using-sudo
alias sudo='sudo '

# quick brew
alias qbrew='HOMEBREW_NO_AUTO_UPDATE=1 brew'

# human-friendly $PATH
alias path='echo -e ${PATH//:/\\n}'

# download file and keep the original filename
alias get='curl -O -L'

alias ls='ls --color=auto'
alias ll='ls -als'

alias o='open'
alias oo='open .'

if _exists code; then
  alias e='code'
else
  alias e='$EDITOR'
fi
