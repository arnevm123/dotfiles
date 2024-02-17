#!/bin/bash

# Get the brightness percentage:
MAX_BRIGHTNESS=$(cat /sys/class/backlight/intel_backlight/max_brightness)
BRIGHTNESS=$(cat /sys/class/backlight/intel_backlight/actual_brightness)
PCT=$(echo "$BRIGHTNESS" "$MAX_BRIGHTNESS" | awk '{printf "%4.0f\n",($1/$2)*100}' | tr -d '[:space:]')

# Round the brightness percentage:
LC_ALL=C

if [ "${BRIGHTNESS}" -lt "33000" ] && [ "$BRIGHTNESS" -gt "0" ]; then
	ICON=~/.config/sway/icons/bright-low.svg
elif [ "${BRIGHTNESS}" -lt "90000" ] && [ "$BRIGHTNESS" -ge "33000" ]; then
	ICON=~/.config/sway/icons/bright-med.svg
else
	ICON=~/.config/sway/icons/bright-high.svg
fi

# Send the notification with the icon:
~/.config/sway/notify-send/notify-send.sh "Brightness ${PCT}%" \
	--replace-file=/tmp/brightness-notification \
	-t 2000 \
	-u critical \
	-f \
	-i "${ICON}" \
	-h int:value:"${PCT}" \
	-h string:synchronous:brightness-progress
