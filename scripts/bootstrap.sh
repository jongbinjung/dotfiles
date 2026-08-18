#!/usr/bin/env bash
set -Eeuo pipefail

usage() {
  cat <<'EOF'
Usage: bootstrap.sh [options]

Install packages and deploy the shared dotfiles configuration.

Options:
  --profile NAME  Install an optional profile: dev, fedora-desktop, mac-gui
  --dry-run       Show actions without changing the system
  --force         Back up regular destination files before replacing them
  --yes           Do not prompt for package-manager confirmation
  --no-packages   Only deploy configuration
  -h, --help      Show this help
EOF
}

ROOT=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)
PROFILE=core
DRY_RUN=0
FORCE=0
YES=0
INSTALL_PACKAGES=1

while (($#)); do
  case $1 in
    --profile) [[ $# -ge 2 ]] || { printf 'Missing profile name.\n' >&2; exit 2; }; PROFILE=$2; shift 2 ;;
    --dry-run) DRY_RUN=1; shift ;;
    --force) FORCE=1; shift ;;
    --yes) YES=1; shift ;;
    --no-packages) INSTALL_PACKAGES=0; shift ;;
    -h|--help) usage; exit 0 ;;
    *) printf 'Unknown option: %s\n' "$1" >&2; usage >&2; exit 2 ;;
  esac
done

case $PROFILE in
  core|dev|fedora-desktop|mac-gui) ;;
  *) printf 'Unknown profile: %s\n' "$PROFILE" >&2; exit 2 ;;
esac

if [[ -z ${HOME:-} || ! -d $HOME ]]; then
  printf 'HOME must name an existing directory.\n' >&2
  exit 1
fi

log() { printf '[dotfiles] %s\n' "$*"; }
run() {
  log "$*"
  ((DRY_RUN)) || "$@"
}

backup_path() {
  local destination=$1 backup index=0
  backup="${destination}.dotfiles-backup"
  while [[ -e $backup || -L $backup ]]; do
    ((index += 1))
    backup="${destination}.dotfiles-backup.${index}"
  done
  printf '%s' "$backup"
}

link_file() {
  local source=$1 destination=$2 parent backup
  [[ -e $source ]] || { printf 'Missing source: %s\n' "$source" >&2; exit 1; }
  parent=$(dirname -- "$destination")
  run mkdir -p "$parent"

  if [[ -L $destination && $(readlink "$destination") == "$source" ]]; then
    log "Already linked: $destination"
    return
  fi
  if [[ -e $destination || -L $destination ]]; then
    if (( ! FORCE )); then
      printf 'Refusing to replace existing path: %s (use --force)\n' "$destination" >&2
      exit 1
    fi
    backup=$(backup_path "$destination")
    run mv "$destination" "$backup"
  fi
  run ln -s "$source" "$destination"
}

deploy_config() {
  link_file "$ROOT/zsh/zshrc" "$HOME/.zshrc"
  link_file "$ROOT/.p10k.zsh" "$HOME/.p10k.zsh"
  link_file "$ROOT/.config/tmux/tmux.conf" "${XDG_CONFIG_HOME:-$HOME/.config}/tmux/tmux.conf"
  link_file "$ROOT/.config/git/config" "${XDG_CONFIG_HOME:-$HOME/.config}/git/config"
}

install_macos() {
  command -v brew >/dev/null 2>&1 || { printf 'Homebrew is required: https://brew.sh\n' >&2; exit 1; }
  local packages=(git git-delta fzf ripgrep)
  [[ $PROFILE == dev || $PROFILE == mac-gui ]] && packages+=(dprint marksman)
  run brew install "${packages[@]}"
  if [[ $PROFILE == mac-gui ]]; then
    run brew install --cask easy-move+resize
    log 'Grant Easy Move+Resize Accessibility permission in System Settings if prompted.'
  fi
}

install_fedora() {
  command -v dnf >/dev/null 2>&1 || { printf 'dnf is required on Fedora.\n' >&2; exit 1; }
  local packages=(git git-delta fzf ripgrep)
  [[ $PROFILE == dev ]] && packages+=(dprint)
  [[ $PROFILE == fedora-desktop ]] && packages+=(cliphist wl-clipboard fcitx5 fcitx5-hangul)
  local confirmation=()
  (( YES )) && confirmation=(-y)
  run sudo dnf install "${confirmation[@]}" "${packages[@]}"
}

install_packages() {
  case $(uname -s) in
    Darwin) install_macos ;;
    Linux)
      [[ -r /etc/os-release ]] && . /etc/os-release
      [[ ${ID:-} == fedora ]] || { printf 'This Linux bootstrap supports Fedora only.\n' >&2; exit 1; }
      install_fedora
      ;;
    *) printf 'Unsupported operating system: %s\n' "$(uname -s)" >&2; exit 1 ;;
  esac
}

log "Repository: $ROOT"
log "Profile: $PROFILE"
(( INSTALL_PACKAGES )) && install_packages
deploy_config
log 'Configuration deployment complete.'
log 'Git identity/signing is intentionally not configured; add local values to ~/.gitconfig.'
