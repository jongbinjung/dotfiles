# Repository Notes

## Desktop Themes

- Desktop color schemes are defined in `theme/schemes/*.toml` using semantic roles.
- The active scheme is recorded in `theme/config.toml`.
- Run `python scripts/generate_theme.py` to choose a scheme interactively.
- Run `make theme` to choose a scheme and reload Hyprland, Waybar, and SwayNC.
- Use `python scripts/generate_theme.py --scheme <name>` for non-interactive selection and `--list` to see names.
- Run `python scripts/generate_theme.py --check` to detect stale generated files.
- The initial catalog contains Nord, Solarized Dark, and Iceberg Dark. Nord is the default.

Theme files are under `.config/hypr/`, `.config/waybar/`, `.config/wofi/`,
and `.config/swaync/`. Tmux is intentionally outside the generated desktop-theme scope.

Generated palette adapters are committed so a fresh checkout works without generation at login:

- `.config/hypr/modules/palette_generated.lua`
- `.config/hypr/palette_generated.conf`
- `.config/waybar/colors.generated.css`
- `.config/wofi/colors.generated.css`
- `.config/swaync/colors.generated.css`

## Theme Conventions

- Do not reintroduce pywal or dependencies on generated files under `.cache/wal/`.
- Do not edit generated palette adapters manually. Change a scheme and rerun the generator.
- Keep component-specific effects such as shadow colors and opacity in the application stylesheet.
- All Waybar variants consume `.config/waybar/colors.generated.css`; do not add variant-local palette literals.
- SwayNC inherits variables from its packaged stylesheet. Its generated adapter must continue to emit modern CSS variables as well as GTK symbolic colors.
- Keep generated outputs deterministic, atomically written, and committed.

## Verification

- Run `git diff --check` after edits.
- Run `bash -n` for modified shell scripts.
- Run `python scripts/generate_theme.py --check` after theme edits.
- Reload Hyprland, Waybar, and SwayNC when testing live desktop changes. Reopen Wofi to test its updated palette.
