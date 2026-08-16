#!/bin/bash
WAYBAR_DIR="$HOME/.config/waybar"
STYLECSS="$WAYBAR_DIR/style.css"
CONFIG="$WAYBAR_DIR/config"
ASSETS="$WAYBAR_DIR/assets"
THEMES="$WAYBAR_DIR/themes"
menu() {
    find "${ASSETS}" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.gif" \) | awk '{print "img:"$0}'
}
apply_theme() {
    local style_source="$1"
    local config_source="$2"
    local style_tmp config_tmp

    style_tmp=$(mktemp "$WAYBAR_DIR/.style.css.XXXXXX") || return 1
    config_tmp=$(mktemp "$WAYBAR_DIR/.config.XXXXXX") || {
        rm -f "$style_tmp"
        return 1
    }

    if ! {
        printf '%s\n\n' '@import url("colors.generated.css");' > "$style_tmp" &&
        cat "$style_source" >> "$style_tmp" &&
        cp "$config_source" "$config_tmp"
    }; then
        rm -f "$style_tmp" "$config_tmp"
        return 1
    fi

    chmod 0644 "$style_tmp" "$config_tmp"
    mv "$style_tmp" "$STYLECSS"
    mv "$config_tmp" "$CONFIG"
    pkill waybar || true
    waybar &
}
main() {
    choice=$(menu | wofi -c ~/.config/wofi/waybar -s ~/.config/wofi/style-waybar.css --show dmenu --prompt "  Select Waybar (Scroll with Arrows)" -n)
    selected_wallpaper=$(printf '%s\n' "$choice" | sed 's/^img://')
    if [[ "$selected_wallpaper" == "$ASSETS/experimental.png" ]]; then
        apply_theme "$THEMES/experimental/style-experimental.css" "$THEMES/experimental/config-experimental"
    elif [[ "$selected_wallpaper" == "$ASSETS/main.png" ]]; then
        apply_theme "$THEMES/default/style-default.css" "$THEMES/default/config-default"
    elif [[ "$selected_wallpaper" == "$ASSETS/line.png" ]]; then
        apply_theme "$THEMES/line/style-line.css" "$THEMES/line/config-line"
    elif [[ "$selected_wallpaper" == "$ASSETS/zen.png" ]]; then
        apply_theme "$THEMES/zen/style-zen.css" "$THEMES/zen/config-zen"
    fi
}
main
