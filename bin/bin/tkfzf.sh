#!/usr/bin/env bash

session=$(tmux ls | fzf | awk '{print $1;}'| sed 's/://')
if [ !-z "$session" ]; then
  tmux kill-session -t $session
fi
