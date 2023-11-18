#!/usr/bin/env bash

external_display=$(swaymsg -t get_outputs | jq 'any(.name != "eDP-1")')

if $external_display; then
  swaymsg "output eDP-1 disable"
else
  swaylock --daemonize && systemctl suspend -i
fi
