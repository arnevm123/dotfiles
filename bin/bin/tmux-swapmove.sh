#!/bin/bash

index="$1"

if [[ -z "$index" ]]; then
	echo "Usage: $0 <index>"
	exit 1
fi

if tmux list-windows | awk -F: '{print $1}' | grep -q "$index"; then
	tmux swap-window -d -t "$index"
else
	tmux move-window -d -t "$index"
	tmux select-window -t "$index"
fi
