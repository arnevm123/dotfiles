#!/bin/bash

pactl set-sink-mute @DEFAULT_SINK@ 0

swayidle -w \
	timeout 800 'gtklock -f' \
	timeout 810 'swaymsg "output * power off"' \
	resume 'swaymsg "output * power on"' \
	timeout 5 'if pgrep -x gtklock; then swaymsg "output * power off"; fi' \
	resume 'swaymsg "output * power on"' \
	before-sleep 'gtklock -f'

kill %%
