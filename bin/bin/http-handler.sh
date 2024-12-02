#!/bin/sh
swaymsg exec firefox "$@" >/dev/null 2>&1
swaymsg '[app_id = "org.mozilla.firefox"] focus' >/dev/null 2>&1
