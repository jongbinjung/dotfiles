# dotfiles

Portable configuration for Fedora and macOS machines. The repository keeps
shared configuration separate from machine-specific identity, work paths, and
desktop integrations.

## Bootstrap

Clone the repository, then run the platform-specific wrapper:

```sh
./scripts/mac_setup.sh       # macOS packages and shared configuration
./scripts/fedora_setup.sh    # Fedora desktop packages and shared configuration
```

The common entry point is also available directly:

```sh
scripts/bootstrap.sh --profile core
scripts/bootstrap.sh --profile dev
scripts/bootstrap.sh --profile fedora-desktop
scripts/bootstrap.sh --profile mac-gui
```

Use `--dry-run` to inspect actions and `--force` to back up existing regular
files before replacing them. Package installation can be skipped with
`--no-packages`.

The bootstrap does not overwrite Git identity or enable commit signing. Put
machine-specific values in your existing `~/.gitconfig` (or another explicitly
included local Git config), for example:

```ini
[user]
    name = Your Name
    email = you@example.com
    signingkey = ~/.ssh/id_ed25519.pub
[gpg]
    format = ssh
[commit]
    gpgsign = true
```

Optional private Zsh settings belong in
`~/.config/dotfiles/zsh/local.zsh`. Shared Zsh configuration is installed as
`~/.zshrc`; pyenv initialization is enabled automatically when `pyenv` exists.

## Themes

Desktop themes are Linux/Hyprland-specific. Use `make theme` on a running
Fedora desktop, or apply a scheme without prompting:

```sh
uv run scripts/generate_theme.py --scheme nord
uv run scripts/generate_theme.py --check
```

`make check` runs shell syntax checks and verifies generated theme files.

## Scope

The repository intentionally does not install Oh My Zsh, pyenv, TPM, or
source-built Vim. Install those separately when needed; package installation
and configuration deployment should remain independently repeatable.
