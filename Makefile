.PHONY: theme

theme:
	python scripts/generate_theme.py
	hyprctl reload config-only
	@if pgrep -x waybar >/dev/null; then pkill -SIGUSR2 -x waybar; fi
	@swaync-client -rs
