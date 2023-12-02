#!/usr/bin/env bash

session=$(tmux ls | fzf | awk '{print $1;}' | sed 's/://')
if [ -n "$session" ]; then
	tmux kill-session -t "$session"
fi
