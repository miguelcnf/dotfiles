# Brew
if [ -f $(brew --prefix)/etc/bash_completion ]; then
  . $(brew --prefix)/etc/bash_completion
fi
PATH=$(brew --prefix)/bin:$PATH

# Alias
alias grep='grep --color=auto'
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
alias ll='ls -lG'
alias ls='ls -G'
alias which='alias | /usr/bin/which --tty-only --read-alias --show-dot --show-tilde'

# Exports
export HISTCONTROL=ignoredups
export HISTTIMEFORMAT='%F %T '
export EDITOR=/usr/bin/vim
export KNIFE_HOME=/Users/miguel.fonseca/.chef
export P4CONFIG=/Users/miguel.fonseca/.p4config
export LC_ALL="en_US.UTF-8"

# Load RVM into a shell session *as a function*
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"
