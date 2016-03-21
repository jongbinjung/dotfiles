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

# open boxcryptor
alias boxcryptor='~/Boxcryptor/Boxcryptor_Portable.sh'

# count lines of file
alias count='wc -l < '

# ssh in new window with Monokai
alias remote='gnome-terminal --window-with-profile=Monokai'

# impressive to impressive.py
#alias impressive='impressive.py -T 0'
# }}}
