#!/bin/sh
flatpak run net.waterfox.waterfox "$@"
swaymsg '[app_id="waterfox"] focus' >/dev/null 2>&1
