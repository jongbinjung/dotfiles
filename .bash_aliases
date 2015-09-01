#!/bin/bash

# set colors {{{
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto -h'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi
# }}}
# Navigation aliases {{{
alias ..='cd ..'
alias ...='cd .. && cd ..'
# }}}
# ls aliases {{{
alias ll='ls -l'
alias la='ll -A'
alias l='ls -CF'
alias lg='la | grep'
# }}}
# Others {{{
alias echo='echo -e'
# ipython should never auto-indent
alias ipython='ipython --no-autoindent'
# }}}
