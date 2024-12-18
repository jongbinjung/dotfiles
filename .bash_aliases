#!/bin/bash

# set colors
if [ -x /usr/bin/dircolors ]; then
  #shellcheck disable=SC2015,SC2086
  test -r "$HOME/.dir_colors" && eval "$(dircolors -b $HOME/.dir_colors)" || eval "$(dircolors -b)"
  alias ls='ls --color=auto --group-directories-first -h'

  alias grep='grep --color=auto'
  alias fgrep='fgrep --color=auto'
  alias egrep='egrep --color=auto'
fi

# Navigation aliases
alias ..='cd ..'
alias ...='cd .. && cd ..'
alias cdu='cd $UBER_HOME'
alias cde='cd $HOME/repos/everything/eats-pricing-modeling'

function bd {
  # navigate to any parent directory by name
  local OPTIND opt cmd p arg
  cmd="cd"
  p="$(pwd)/"
  arg="/$1/"

  while getopts ":p:" opt; do
    case "$opt" in
      p) cmd="pushd"; arg="/$OPTARG/";;
      :) echo "Option -$OPTARG requires an argument!"; return;;
      \?) echo "Invalid option: -$OPTARG"; return;;
    esac
  done

  if [[ "$p" == *"$arg"* ]]; then
    echo "${p%$arg*}$arg"
    eval "$cmd ${p%$arg*}$arg"
  fi
}

# ls aliases
alias ll='ls -lhv'
alias la='ll -A'
alias l='ls -CF'
alias lg='ls -la | grep'

# git quick aliases
alias gj='git pull'
alias gk='git push'
alias gd='git diff'
alias gl='git log --decorate-refs-exclude=tags'

# Others
alias echo='echo -e'

# ipython should never auto-indent
# alias ipython='ipython --no-autoindent'

alias path='echo -e ${PATH//:/\\n}'

# count lines of file
alias count='wc -l < '

# timewarrior
alias tw='timew'

# matlab command line
alias matlabc='matlab -nodisplay -nodesktop'
alias present='impressive -T0'

# Remote connections
# Copy Stanford 2fa before ssh
alias sussh='2fa stan; ssh -Y'

# fileutil aliases
alias fll='fileutil ls -l -h'
alias fla='fll -a'
alias fcp='fileutil cp'
alias fcat='fileutil cat'
