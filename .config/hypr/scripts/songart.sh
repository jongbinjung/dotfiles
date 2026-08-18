#!/bin/bash

set -euo pipefail

script_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
fallback_path="$script_dir/../assets/default-album-art.png"

print_fallback() {
    printf '%s\n' "$fallback_path"
}

art_url=$(playerctl metadata --format '{{mpris:artUrl}}' 2>/dev/null || true)

if [[ -z "$art_url" ]]; then
    print_fallback
    exit 0
fi

if [[ "$art_url" == file://* ]]; then
    local_path=${art_url#file://}
    if [[ -f "$local_path" ]]; then
        printf '%s\n' "$local_path"
    else
        print_fallback
    fi
    exit 0
fi

if [[ "$art_url" != http://* && "$art_url" != https://* ]]; then
    print_fallback
    exit 0
fi

cache_dir="${XDG_CACHE_HOME:-$HOME/.cache}/hyprlock"
mkdir -p "$cache_dir"
cache_key=$(printf '%s' "$art_url" | sha256sum | cut -d' ' -f1)
cache_path="$cache_dir/album-art-$cache_key.img"

if [[ ! -s "$cache_path" ]]; then
    temporary_path=$(mktemp "$cache_dir/.album-art.XXXXXX")
    if curl --fail --silent --show-error --location --max-time 10 \
        --output "$temporary_path" "$art_url" && [[ -s "$temporary_path" ]]; then
        mv -f "$temporary_path" "$cache_path"
    else
        rm -f "$temporary_path"
        print_fallback
        exit 0
    fi
fi

printf '%s\n' "$cache_path"
