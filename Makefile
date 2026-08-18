.PHONY: help init bootstrap theme check

## Show available targets.
help:
	@awk 'BEGIN {FS = ":.*##"} /^## / {description = substr($$0, 4); next} /^[[:alnum:]_.-]+:/ && description {printf "\033[36m%-12s\033[0m %s\n", $$1, description; description = ""} !/^## / && !/^[[:alnum:]_.-]+:/ {description = ""}' $(MAKEFILE_LIST)

## Install uv if needed and initialize the project environment.
init:
	@if ! command -v uv >/dev/null 2>&1; then \
		curl -LsSf https://astral.sh/uv/install.sh | sh; \
		export PATH="$$HOME/.local/bin:$$PATH"; \
	fi; \
	uv sync

## Install packages and deploy shared configuration.
bootstrap:
	@scripts/bootstrap.sh $(ARGS)

## Select a desktop color scheme and reload the desktop components.
theme:
	uv run scripts/generate_theme.py
	hyprctl reload config-only
	@if pgrep -x waybar >/dev/null; then pkill -SIGUSR2 -x waybar; fi
	@swaync-client -rs

## Run static checks that do not require a desktop session.
check:
	bash -n scripts/*.sh
	zsh -n scripts/setup_zsh.sh zsh/*.zsh
	uv run scripts/generate_theme.py --check
