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
FAILED_STEPS=0
LAST_RUN_OK=1
declare -a STEP_NAMES=()
declare -a STEP_STATUSES=()

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
record_step() {
  local name=$1 status=$2
  STEP_NAMES+=("$name")
  STEP_STATUSES+=("$status")
  if [[ $status == failed ]]; then
    ((FAILED_STEPS += 1))
  fi
}

run() {
  log "$*"
  if (( DRY_RUN )); then
    LAST_RUN_OK=1
    record_step "$*" planned
  elif "$@"; then
    LAST_RUN_OK=1
    record_step "$*" succeeded
  else
    LAST_RUN_OK=0
    record_step "$*" failed
    log "Failed: $*"
  fi
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
  if [[ ! -e $source ]]; then
    log "Missing source: $source"
    record_step "link $destination" failed
    return 0
  fi
  parent=$(dirname -- "$destination")
  run mkdir -p "$parent"
  (( LAST_RUN_OK )) || return 0

  if [[ -L $destination && $(readlink "$destination") == "$source" ]]; then
    log "Already linked: $destination"
    record_step "link $destination" succeeded
    return
  fi
  if [[ -e $destination || -L $destination ]]; then
    if (( ! FORCE )); then
      log "Skipping existing path: $destination (use --force to replace it)"
      record_step "link $destination" skipped
      return
    fi
    backup=$(backup_path "$destination")
    run mv "$destination" "$backup"
    (( LAST_RUN_OK )) || return 0
  fi
  run ln -s "$source" "$destination"
}

deploy_config() {
  link_file "$ROOT/zsh/zshrc" "$HOME/.zshrc"
  link_file "$ROOT/.p10k.zsh" "$HOME/.p10k.zsh"
  link_file "$ROOT/.config/tmux/tmux.conf" "${XDG_CONFIG_HOME:-$HOME/.config}/tmux/tmux.conf"
  link_file "$ROOT/bin/tmux-worktree-window" "$HOME/bin/tmux-worktree-window"
  link_file "$ROOT/.config/git/config" "${XDG_CONFIG_HOME:-$HOME/.config}/git/config"
}

install_macos() {
  if ! command -v brew >/dev/null 2>&1; then
    log 'Homebrew is required: https://brew.sh'
    record_step 'check Homebrew' failed
    return 0
  fi
  local packages=(git git-delta fzf ripgrep tmux)
  [[ $PROFILE == dev || $PROFILE == mac-gui ]] && packages+=(dprint marksman)
  run brew install "${packages[@]}"
  if [[ $PROFILE == mac-gui ]]; then
    run brew install --cask easy-move+resize
    log 'Grant Easy Move+Resize Accessibility permission in System Settings if prompted.'
  fi
}

install_fedora() {
  if ! command -v dnf >/dev/null 2>&1; then
    log 'dnf is required on Fedora.'
    record_step 'check dnf' failed
    return 0
  fi
  local packages=(git git-delta fzf ripgrep tmux)
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
      if [[ ! -r /etc/os-release ]]; then
        log 'Unable to identify Linux distribution: /etc/os-release is unreadable.'
        record_step 'check Linux distribution' failed
        return 0
      fi
      . /etc/os-release
      if [[ ${ID:-} != fedora ]]; then
        log 'This Linux bootstrap supports Fedora only.'
        record_step "check supported distribution (${ID:-unknown})" failed
        return 0
      fi
      install_fedora
      ;;
    *)
      log "Unsupported operating system: $(uname -s)"
      record_step 'check operating system' failed
      ;;
  esac
}

summary() {
  local index status marker
  printf '\n[dotfiles] Bootstrap summary\n'
  for index in "${!STEP_NAMES[@]}"; do
    status=${STEP_STATUSES[index]}
    case $status in
      succeeded) marker='OK' ;;
      planned) marker='PLAN' ;;
      skipped) marker='SKIP' ;;
      failed) marker='FAIL' ;;
    esac
    printf '  %-6s %s\n' "$marker" "${STEP_NAMES[index]}"
  done
  if (( FAILED_STEPS )); then
    printf '[dotfiles] %d step(s) failed; review the entries marked FAIL.\n' "$FAILED_STEPS" >&2
  else
    printf '[dotfiles] All bootstrap steps completed without failures.\n'
  fi
}

log "Repository: $ROOT"
log "Profile: $PROFILE"
if (( INSTALL_PACKAGES )); then
  install_packages
else
  record_step 'package installation' skipped
fi
deploy_config
log 'Configuration deployment complete.'
log 'Git identity/signing is intentionally not configured; add local values to ~/.gitconfig.'
summary
(( FAILED_STEPS == 0 ))
