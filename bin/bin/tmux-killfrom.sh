#!/bin/bash

from_index="$1"

if [[ -z "$from_index" ]]; then
	echo "Usage: $0 <index>"
	exit 1
fi

# Get the list of window indexes from tmux and iterate over them
for index in $(tmux list-windows | awk -F': ' '{print $1}'); do
	# Check if the index is greater than 2
	if [ "$index" -gt "$from_index" ]; then
		# If it is, execute tmux kill-window
		tmux kill-window -t "$index"
	fi
done
