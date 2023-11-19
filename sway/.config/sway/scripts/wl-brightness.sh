#!/bin/bash
# Run the command in the background and capture the PID
~/.cargo/bin/wl-gammarelay-rs watch "{bp}" > /tmp/output.log 2>&1 &
pid=$!

# Wait for the command to produce some output
sleep 0.05

# Capture the second line of the output
OUTPUT=$(tail -n 2 /tmp/output.log | head -n 1)

# Kill the process using its PID
kill $pid

notification="Brightness ${OUTPUT}%"

# Send the notification with the icon:
~/.config/sway/notify-send/notify-send.sh "$notification" \
    --replace-file=/tmp/wl-notification \
    -t 2000 \
    -h int:value:"${OUTPUT}" \
    -h string:synchronous:brightness-change
