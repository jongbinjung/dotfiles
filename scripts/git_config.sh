#!/usr/bin/env bash
set -Eeuo pipefail

ROOT=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)
CONFIG="$ROOT/.config/git/config"

command -v git >/dev/null 2>&1 || { printf 'git is required.\n' >&2; exit 1; }
if [[ -e "$HOME/.config/git/config" && "$HOME/.config/git/config" -ef "$CONFIG" ]]; then
  printf 'Shared Git configuration is already installed.\n'
  exit 0
fi
if git config --global --get-all include.path 2>/dev/null | grep -Fqx "$CONFIG"; then
  printf 'Shared Git configuration is already installed.\n'
  exit 0
fi
git config --global --add include.path "$CONFIG"
printf 'Installed shared Git configuration. Identity and signing remain machine-local.\n'
