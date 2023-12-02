#!/bin/sh

set -e

CURRENT_PANE="$(tmux display-message -p -F "#{session_name}")"
if echo "$CURRENT_PANE" | grep -q '^floating.*'; then
	tmux detach-client
else
	tmux popup -d '#{pane_current_path}' -xC -yC -w70% -h70% -E "tmux attach -t 'floating-$CURRENT_PANE' || tmux new -s 'floating-$CURRENT_PANE'" || true
fi
