# Start an HTTP server from a directory
function http_server() {
  local port="${1:-8000}"
  python -mSimpleHTTPServer "$port"
}

# Prompt
export PS1="[\u@\h\$(git-radar --bash --fetch)]$ "

# KUBESHELL
function __kube_prompt() {
  local Def='\[\e[0m\]' # Default
  local Clean='\[\e[0;36m\]'

  kube_context=$(grep current-context ~/.kube/config | awk -F ' ' '{print $2}')

  # Build the prompt
  PS1="[\u@\h \W ${Clean}($kube_context)${Def}]\$ "
  unalias kubeshell 2>/dev/null
}
alias kubeshell='export PROMPT_COMMAND=__kube_prompt'

# AWSLS
function __aws_ls() {
  profile=$1
  filter=$2
  aws ec2 describe-instances --filters "Name=tag:Name,Values=*$filter*" --query 'Reservations[*].Instances[*].[InstanceId,State.Name,InstanceType,PrivateIpAddress,PublicIpAddress,Tags[?Key==`Name`].Value[]]' --output json --profile $profile | tr -d '\n[] "' | perl -pe 's/i-/\ni-/g' | tr ',' '\t' | sed -e 's/null/None/g' | grep '^i-' | column -t
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

# Editor
export EDITOR=/usr/bin/vim

# Random pass generator
keygen(){ perl -MTime::HiRes -e 'printf("%.0f\n",Time::HiRes::time()*10000)' | shasum | base64 | head -c 15;echo; }

# GO
export GOPATH=~/Projects/go
PATH=$PATH:$GOPATH/bin
# Dep
alias depviz='dep status -dot | dot -T png | open -f -a /Applications/Preview.app'

# GPG
PATH="/usr/local/opt/gnupg@1.4/libexec/gpgbin:$PATH"

# History
export HISTSIZE=5000
export HISTCONTROL=ignoredups
export HISTTIMEFORMAT='%F %T '

test -e "${HOME}/.iterm2_shell_integration.bash" && source "${HOME}/.iterm2_shell_integration.bash"
