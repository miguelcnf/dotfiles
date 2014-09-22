# Start an HTTP server from a directory
function server() {
  local port="${1:-8000}"
  open "http://localhost:$port"
  python -mSimpleHTTPServer "$port"
}

# Custom prompt
function __prompt_command() {
 # Get last command exist status
 local last_cmd_exit=$?

 # Define Colors
 local Def='\[\e[0m\]' # Default
 local Red='\[\e[0;31m\]' # Last exit code != 0
 local Clean='\[\e[0;36m\]' # Git repo is clean
 local Dirty='\[\e[0;31m\]' # Git repo is dirty

 # Paint the $ char based on last command exit status
 [ $last_cmd_exit == 0 ] && local dollar="\$ " || local dollar="${Red}\$ ${Def}"

 # Does current dir belongs to a git repo ?
 git rev-parse --git-dir >/dev/null 2>&1
 local git_repo=$?

 # Run git status
 [ $git_repo == 0 ] && local git_status=$(git status --ignore-submodules)

 # Get git repo commit status
 [ $git_repo == 0 ] && echo $git_status | grep -q "nothing to commit" && local Gitcst=$Clean || local Gitcst=$Dirty

 # Get git repo push status
 [ $git_repo == 0 ] && local Gitahead=$(echo $git_status | grep "Your branch" | grep -v "up-to-date" | sed -E 's/.*([[:digit:]]+).*/\1/')
 [ ! -z $Gitahead ] && Gitahead=" ${Red}+${Gitahead}${Def}"

 # Build the prompt
  PS1="[\u@\h \W${Gitcst}$(__git_ps1)${Def}${Gitahead}]$dollar"
}

export PROMPT_COMMAND=__prompt_command

# Locale
export LC_CTYPE=en_US.UTF-8
export LC_ALL=en_US.UTF-8

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

# Hack for Finder
alias showFiles='defaults write com.apple.finder AppleShowAllFiles YES; killall Finder /System/Library/CoreServices/Finder.app'
alias hideFiles='defaults write com.apple.finder AppleShowAllFiles NO; killall Finder /System/Library/CoreServices/Finder.app'

# Exports
export HISTCONTROL=ignoredups
export HISTTIMEFORMAT='%F %T '
export EDITOR=/usr/bin/vim
export KNIFE_HOME=/Users/miguel.fonseca/.chef
export P4CONFIG=/Users/miguel.fonseca/.p4config

# Load RVM into a shell session *as a function*
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"

# Random pass generator
passgen(){ perl -MTime::HiRes -e 'printf("%.0f\n",Time::HiRes::time()*10000)' | shasum | base64 | head -c 15;echo; }

# Maven
PATH=$PATH:/Users/miguel.fonseca/Applications/apache-maven-3.2.2/bin
export M2_HOME=/Users/miguel.fonseca/Applications/apache-maven-3.2.2

