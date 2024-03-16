#!/usr/bin/env bash

# Created: 2018-06-20
# Author: jongbin.jung
# Description: Default git configs

git config --global user.name "Jongbin Jung"
# TODO: Ask for email?
git config --global user.email jungjongbin86@gmail.com

git config --global blame.date short

git config --global format.pretty format:"%C(auto)%h%d %C(green)%aN%Creset %s"

git config --global core.pager delta

git config --global alias.tags "log --no-walk --tags --color --pretty='%C(auto)%h%d%Creset %s %C(blue)(%ad)'"

git config --global log.date relative
git config --global delta.navigate true
git config --global delta.light false
git config --global merge.conflictstyle diff3
git config --global diff.colorMoved default

# [includeIf "gitdir:~/repos/"]
#   path = ~/repos/.gitconfig
# [includeIf "gitdir:~/.vim/"]
#   path = ~/repos/.gitconfig
