#!/usr/bin/env zsh

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

export GOPATH="$HOME/go"
export MYGO="$GOPATH/src/github.com/jongbinjung"

pathmunge "$GOPATH/bin"
[[ -d "$HOME/repos/scripts" ]] && pathmunge "$HOME/repos/scripts"
pathmunge "$HOME/bin"
pathmunge "$HOME/.cargo/bin"
pathmunge "/usr/local/sbin"
[[ -d /opt/uber/bin ]] && pathmunge /opt/uber/bin
[[ -d "/Applications/MuseScore 4.app/Contents/MacOS" ]] && pathmunge "/Applications/MuseScore 4.app/Contents/MacOS"
pathmunge "$HOME/.local/bin"

export PATH

(( $+commands[rg] )) && export FZF_DEFAULT_COMMAND='rg --files --no-ignore-vcs --hidden'
