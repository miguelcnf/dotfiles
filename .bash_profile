# Start an HTTP server from a directory
function http_server() {
  local port="${1:-8000}"
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

function __kube_prompt() {
  local Def='\[\e[0m\]' # Default
  local Clean='\[\e[0;36m\]'

  kube_context=$(grep current-context ~/.kube/config | awk -F ' ' '{print $2}')

  # Build the prompt
  PS1="[\u@\h \W ${Clean}($kube_context)${Def}]\$ "
  unalias kubeshell 2>/dev/null
}

alias kubeshell='export PROMPT_COMMAND=__kube_prompt'

function __aws_ls() {
  profile=$1
  filter=$2
  aws ec2 describe-instances --filters "Name=tag:Name,Values=$filter" --query 'Reservations[*].Instances[*].[InstanceId,State.Name,InstanceType,PrivateIpAddress,PublicIpAddress,Tags[?Key==`Name`].Value[]]' --output json --profile $profile | tr -d '\n[] "' | perl -pe 's/i-/\ni-/g' | tr ',' '\t' | sed -e 's/null/None/g' | grep '^i-' | column -t
}

alias awsls='__aws_ls $1 $2'

# Locale
export LC_CTYPE=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# Brew
if [ -f $(brew --prefix)/etc/bash_completion ]; then
  . $(brew --prefix)/etc/bash_completion
fi
PATH=$(brew --prefix)/bin:$(brew --prefix)/sbin:$PATH

# Alias
alias grep='grep --color=auto'
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
alias ll='ls -Gpalh'
alias which='alias | /usr/bin/which --tty-only --read-alias --show-dot --show-tilde'

# Hack for Finder
alias showFiles='defaults write com.apple.finder AppleShowAllFiles YES; killall Finder /System/Library/CoreServices/Finder.app'
alias hideFiles='defaults write com.apple.finder AppleShowAllFiles NO; killall Finder /System/Library/CoreServices/Finder.app'

# Hack for chefdk
alias chef_path='PATH=/opt/chefdk/bin:$PATH'

# Exports
export HISTCONTROL=ignoredups
export HISTTIMEFORMAT='%F %T '
export EDITOR=/usr/bin/vim
export KNIFE_HOME=~/.chef
export P4CONFIG=~/.p4config

# Ruby
export PATH="$PATH:$HOME/.rvm/bin" # Add RVM to PATH for scripting
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*

# Random pass generator
keygen(){ perl -MTime::HiRes -e 'printf("%.0f\n",Time::HiRes::time()*10000)' | shasum | base64 | head -c 15;echo; }

# Maven
PATH=$PATH:~/Applications/apache-maven-3.2.3/bin
export M2_HOME=~/Applications/apache-maven-3.2.3

# ChefDK
PATH=$PATH:/opt/chefdk/embedded/bin:/opt/chefdk/bin

# GO
export GOPATH=~/Projects/go
PATH=$PATH:$GOPATH/bin

# Node
export NVM_DIR="/Users/miguelfonseca/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm

test -e "${HOME}/.iterm2_shell_integration.bash" && source "${HOME}/.iterm2_shell_integration.bash"

# Todolist
export TODO_DB_PATH=$HOME/Dropbox/todo.json

# Android
export ANDROID_HOME=/Applications/android-sdk-macosx

# GPG
PATH="/usr/local/opt/gnupg@1.4/libexec/gpgbin:$PATH"

# History
export HISTSIZE=5000
