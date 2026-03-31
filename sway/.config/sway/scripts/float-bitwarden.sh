#!/bin/bash
# Float Bitwarden extension popups immediately on creation.
# Waits briefly for the window to stabilize before centering.
swaymsg -t subscribe -m '["window"]' |
	jq --unbuffered -c '
		select(.change == "new")
		| .container
		| select(.geometry.width == 480 and .geometry.height == 630)
		| .id
	' |
	while read -r id; do
		sleep 0.1
		swaymsg "[con_id=$id] floating enable, move position center"
	done
