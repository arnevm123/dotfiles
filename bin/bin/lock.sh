#!/bin/bash

pactl set-sink-mute @DEFAULT_SINK@ 0

swayidle -w \
	timeout 800 'swaylock -f' \
	timeout 810 'swaymsg "output * power off"' \
	resume 'swaymsg "output * power on"' \
	timeout 5 'if pgrep -x swaylock; then swaymsg "output * power off"; fi' \
	resume 'swaymsg "output * power on"' \
	before-sleep 'swaylock -f'

kill %%
