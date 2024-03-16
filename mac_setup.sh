#!/usr/bin/env bash

# Created: 2019-07-11
# Author: jongbin
# Description: Stuff that I end up doing on macOS

# X-style drag/resize:
# https://github.com/dmarcotte/easy-move-resize
brew cask install easy-move-plus-resize

brew install fzf
# To install useful key bindings and fuzzy completion:
$(brew --prefix)/opt/fzf/install

brew install git_delta

# Markdown LSP (https://github.com/artempyanykh/marksman)
brew install marksman

# dprint for arbitrary code formatting
brew install dprint
