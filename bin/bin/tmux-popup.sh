#!/bin/sh

set -e

if [ $# -eq 1 ]; then
	CURRENT_PATH="$1"
else
	CURRENT_PATH="$(tmux display-message -p -F "#{pane_current_path}")"
fi

CURRENT_PANE="$(tmux display-message -p -F "#{session_name}")"
if echo "$CURRENT_PANE" | grep -q '^floating.*'; then
	tmux detach-client
else
	tmux popup -d "$CURRENT_PATH" -xC -yC -w70% -h75% -E "tmux attach -t 'floating-$CURRENT_PANE' || tmux new -s 'floating-$CURRENT_PANE'" || true
fi
