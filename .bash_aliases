#!/bin/bash

# set colors {{{
if [ -x /usr/bin/dircolors ]; then
  test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
  alias ls='ls --color=auto --group-directories-first -h'

  alias grep='grep --color=auto'
  alias fgrep='fgrep --color=auto'
  alias egrep='egrep --color=auto'
fi
# }}}
# Navigation aliases {{{
alias ..='cd ..'
alias ...='cd .. && cd ..'
alias open='xdg-open'

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
# }}}
# ls aliases {{{
alias ll='ls -lv --group-directories-first'
alias la='ll -A'
alias l='ls -CF'
alias lg='ls -la | grep'
# }}}
# Others {{{
alias echo='echo -e'
# ipython should never auto-indent
alias ipython='ipython --no-autoindent'

alias path='echo -e ${PATH//:/\\n}'

# count lines of file
alias count='wc -l < '

# impressive to impressive.py
alias impressive='impressive -T 0'

# todo.sh w/ completion
alias td='todo.sh -d /home/jongbin/Dropbox/todo/.todo.cfg'
complete -F _todo td
# }}}
# Remote connections {{{
alias soal='ssh soal-cluster.stanford.edu'
#}}}
# fileutil aliases {{{
alias fll='fileutil ls -l -h'
alias fla='fll -a'
alias fcp='fileutil cp'
alias fcat='fileutil cat'
# }}}
