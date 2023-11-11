session=$(tmux list-sessions | grep -v '(attached)' | fzf | sed 's/: .*//g')
tmux switch-client -t "$session"
