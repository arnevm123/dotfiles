alias kport=_kport
alias cdg=_cdg
alias cdt=_cdt
alias zshconf=_zshconf
alias extract=_extract
alias setbg=_setbg

# git aliases
alias gfco='git fetch && gco'
alias gco='fzf-git-checkout'
# fzf-git-branch and fzf-git-checkout moved to bin/
alias gcml='gfo && gcm && ggl'
alias gsfzf=' git stash pop `git stash list | fzf | cut \}`'
alias gitdelete="git branch --no-color | fzf -m | sed 's/^* //g' | xargs -I {} git branch -D '{}'"
alias gyolo='git commit -am "`curl -sL https://whatthecommit.com/index.txt`" &&  ggp'
alias gdate='git commit -am "Last Sync: $(date +%Y-%m-%d\ %H:%M) (Manual commit)" && ggp'
alias ggf=ggfl

# editor aliases
alias vim=nvim
alias vi='\vim'

# config aliases
alias conf=fzf-conf
alias vimconf='if [[ "$PWD" != "$NVIM_CONF" ]]; then pushd "$NVIM_CONF" && vim . && popd || popd; else vim .; fi'
alias tmuxconf='if [[ "$PWD" != "$HOME" ]]; then pushd $HOME && vim .tmux.conf && popd || popd; else vim .tmux.conf; fi'
alias zshsrc="source ~/.zshrc"
alias cdnv="cd ~/.config/nvim"

# tmux aliases
alias tms='tmux-sessionizer'
alias tks='tmux kill-server'

# docker aliases
alias dcu='docker compose up -d'
alias dcd='docker compose down'
alias dcr='docker compose down && docker compose up -d'
alias dcpull='docker compose pull'
alias dclogs='docker compose logs -f --tail="150" '
alias dcl='docker compose logs -f --tail="150" '
alias dce='docker compose exec -it'
alias dc='docker compose'

# go aliases
alias lnt="golangci-lint run 2>&1 | tee .lint.txt"
alias dbg="go build -gcflags='all=-N -l' -o debug && ./debug && rm debug"
alias GW="export GOOS=windows"
alias GL="export GOOS=linux"
alias GU="unset GOOS"

# lint/fix aliases
alias fix='nvim -q .lint.txt'

# file/dir aliases
alias ls="ls --color=tty -F"
alias open='xdg-open'
alias rmrf='fc -s "rm=rm -rf"'

# misc aliases
alias pwdcp="pwd | tr -d '\n' | wl-copy"
alias checkout=grove-checkout
alias grove-fzf=grove-tmux

alias oc=opencode
alias occ='opencode -c'

# global aliases
alias -g NE='2>/dev/null'
alias -g NO='>/dev/null'
alias -g NUL='>/dev/null 2>&1'
alias -g J='| jq'
alias -g C='| wl-copy'
alias -g G='| rg '
