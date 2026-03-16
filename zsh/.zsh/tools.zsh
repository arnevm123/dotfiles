autoload -Uz zmv

eval "$(zoxide init zsh --cmd c)"

. "$HOME/.atuin/bin/env"
eval "$(atuin init zsh --disable-up-arrow)"

[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

eval "$(grove switch shell-init)"
eval "$(grove completion zsh)"

# bun completions
[ -s "/home/arne/.bun/_bun" ] && source "/home/arne/.bun/_bun"
