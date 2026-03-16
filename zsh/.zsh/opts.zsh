setopt PUSHDSILENT
set -o ignoreeof

# Enable vi mode
bindkey -v
bindkey -e

bindkey "^X^X" edit-command-line
bindkey "^y" autosuggest-accept

# Copy current command line to clipboard
function copy-buffer-to-clipboard() {
	echo -n "$BUFFER" | wl-copy
	zle -M "Copied to clipboard"
}
zle -N copy-buffer-to-clipboard

bindkey '^Xcp' copy-buffer-to-clipboard

# Insert git commit template
bindkey -s '^Xgc' 'git commit -m ""\C-b'
