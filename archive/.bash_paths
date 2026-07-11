#!/usr/bin/env bash

pathmunge () {
  case ":${PATH}:" in
    *:"$1":*)
      ;;
    *)
      if [ "$2" = "after" ] ; then
        PATH=$PATH:$1
      else
        PATH=$1:$PATH
      fi
  esac
}

export GOPATH=$HOME/go
export MYGO=$GOPATH/src/github.com/jongbinjung

pathmunge "$GOPATH/bin"
pathmunge "$HOME/repos/scripts"
pathmunge "$HOME/bin"
pathmunge "$HOME/.local/bin"
pathmunge "$HOME/.cargo/bin"
pathmunge "/usr/local/sbin"
pathmunge "/opt/uber/bin"

export PATH

export FZF_DEFAULT_COMMAND='rg --files --no-ignore-vcs --hidden'
