# Bail out for dumb terminals
[[ $TERM == "dumb" ]] && unsetopt zle && PS1='$ ' && return

# Source secrets (API keys, etc.) - not in version control
[[ -f "$HOME/.zshexports" ]] && source "$HOME/.zshexports"

# Load modular configuration
for config_file in \
    "$HOME/.zsh/plugins.zsh" \
    "$HOME/.zsh/exports.zsh" \
    "$HOME/.zsh/tools.zsh" \
    "$HOME/.zsh/functions.zsh" \
    "$HOME/.zsh/aliases.zsh" \
    "$HOME/.zsh/opts.zsh"; do
    [[ -f "$config_file" ]] && source "$config_file"
done
