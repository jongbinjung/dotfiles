env LDFLAGS=-L$HOME/.local/lib ./configure --with-features=huge \
       	--enable-multibyte \
       	--enable-rubyinterp=yes \
       	--enable-python3interp=yes \
       	--with-python3-config-dir=$(python3.7-config --configdir) \
       	--enable-perlinterp=yes \
       	--enable-luainterp=yes \
       	--enable-cscope \
       	--prefix=$HOME/.local
