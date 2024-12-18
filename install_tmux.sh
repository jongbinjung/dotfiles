#!/usr/bin/env bash

# Script for installing tmux on systems where you don't have root access.
# See https://gist.github.com/ryin/3106801
# tmux will be installed in $HOME/.local/bin.
# It's assumed that wget and a C/C++ compiler are installed.

# exit on error
set -e

TMUX_VERSION=3.1b

# create our directories
mkdir -p $HOME/.local $HOME/src/tmux
cd $HOME/src/tmux

# download source files for tmux, libevent, and ncurses
wget -O tmux-${TMUX_VERSION}.tar.gz https://github.com/tmux/tmux/releases/download/${TMUX_VERSION}/tmux-${TMUX_VERSION}.tar.gz
wget -O libevent-stable.tar.gz https://github.com/libevent/libevent/releases/download/release-2.1.12-stable/libevent-2.1.12-stable.tar.gz
wget -O ncurses.tar.gz ftp://ftp.invisible-island.net/ncurses/ncurses.tar.gz

# extract files, configure, and compile

############
# libevent #
############
tar xvzf libevent-stable.tar.gz
cd libevent-2.1.12-stable
./configure --prefix=$HOME/.local --disable-shared
make -j 30
make install
cd ..

############
# ncurses  #
############
tar xvzf ncurses.tar.gz
cd ncurses-6.2
./configure --prefix=$HOME/.local
make -j 30
make install
cd ..

############
# tmux     #
############
tar xvzf tmux-${TMUX_VERSION}.tar.gz
cd tmux-${TMUX_VERSION}
./configure CFLAGS="-I$HOME/.local/include -I$HOME/.local/include/ncurses" LDFLAGS="-L$HOME/.local/lib -L$HOME/.local/include/ncurses -L$HOME/.local/include"
CPPFLAGS="-I$HOME/.local/include -I$HOME/.local/include/ncurses" LDFLAGS="-static -L$HOME/.local/include -L$HOME/.local/include/ncurses -L$HOME/.local/lib" make -j 30
cp tmux $HOME/.local/bin
cd ..

# cleanup
rm -rf $HOME/tmux_tmp

echo "$HOME/.local/bin/tmux is now available."
