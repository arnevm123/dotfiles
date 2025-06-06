#!/usr/bin/env bash

external_display=$(swaymsg -t get_outputs | jq 'any(.name != "eDP-1")')

if $external_display; then
	active=$(swaymsg -t get_outputs | jq '.[] | select(.name == "eDP-1") | .active')
	if [[ $active != "true" ]]; then
		swaymsg "output eDP-1 enable"
		exit 0
	fi
	MUTE=$(pactl get-sink-mute @DEFAULT_SINK@ | awk '{ print $2 }')
	if [[ $MUTE == 'no' ]]; then
		pactl set-sink-mute @DEFAULT_SINK@ 1
	fi
	swaymsg "output eDP-1 disable"
	if [[ $MUTE == 'no' ]]; then
		pactl set-sink-mute @DEFAULT_SINK@ 0
	fi
else
	swaylock --daemonize && systemctl suspend -i
fi
