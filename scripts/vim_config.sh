# Dependencies, from https://github.com/ycm-core/YouCompleteMe/wiki/Building-Vim-from-source
#
# sudo yum install -y ncurses-devel ruby ruby-devel lua lua-devel luajit \
# luajit-devel ctags git python python-devel \
# python3 python3-devel tcl-devel \
# perl perl-devel perl-ExtUtils-ParseXS \
# perl-ExtUtils-XSpp perl-ExtUtils-CBuilder \
# perl-ExtUtils-Embed

./configure \
  --prefix=$HOME/.local \
  --enable-cscope \
  --enable-luainterp=yes \
  --enable-multibyte \
  --enable-perlinterp=yes \
  --enable-python3interp=yes \
  --enable-rubyinterp=yes \
  --with-features=huge \
  --with-python3-command=/usr/bin/python3 \
  --with-python3-config-dir=$(/usr/bin/python3-config --configdir) \
  --with-wayland=yes
