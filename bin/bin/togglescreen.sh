#!/usr/bin/env bash

# Toggles the screen between two screens
swaymsg -t get_outputs | jq -e '.[] | select(.active) | select(.name == "eDP-1")' > /dev/null && swaymsg "output eDP-1 disable" || swaymsg "output eDP-1 enable"
