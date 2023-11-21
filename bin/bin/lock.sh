#!/bin/bash

MUTE=$(pactl get-sink-mute @DEFAULT_SINK@ | awk '{ print $2 }')
if [[ $MUTE == 'no' ]]; then
    pactl set-sink-mute @DEFAULT_SINK@ 0
fi
swayidle \
    timeout 1 'swaymsg "output * dpms off"' \
    resume 'swaymsg "output * dpms on"' &
swaylock
kill %%
if [[ $MUTE == 'no' ]]; then
    pactl set-sink-mute @DEFAULT_SINK@ 1
fi
