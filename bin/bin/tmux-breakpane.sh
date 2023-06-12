#!/bin/sh
set -e

CURRENT_PANE="$(tmux display-message -p -F "#{session_name}")"
MAIN_PANE=$(echo "$CURRENT_PANE" | sed 's/floating-//')
if echo "$CURRENT_PANE" | grep -q '^floating.*'; then
    tmux break-pane -s "$CURRENT_PANE" -t "$MAIN_PANE"
else
    tmux break-pane
fi
