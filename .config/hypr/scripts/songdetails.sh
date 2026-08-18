#!/bin/bash

get_metadata() {
	key=$1
	playerctl metadata --format "{{ $key }}" 2>/dev/null
}

get_source_info() {
	trackid=$(get_metadata "mpris:trackid")
	if [[ "$trackid" == *"firefox"* ]]; then
		echo -e "󰈹"
	elif [[ "$trackid" == *"spotify"* ]]; then
		echo -e ""
	elif [[ "$trackid" == *"chromium"* ]]; then
		echo -e ""
	else
		echo ""
	fi
}



title=$(get_metadata "title")
artist=$(get_metadata "artist")
icon=$(get_source_info)
status=$(playerctl status 2>/dev/null)

if [[ $status == "Playing" ]]; then
    song_info="▶  <b>$title</b> $icon <i>$artist</i>"
elif [[ $status == "Paused" ]]; then
    song_info="⏸  <b>$title</b> $icon <i>$artist</i>"
else
    song_info=""
fi

echo "$song_info"

