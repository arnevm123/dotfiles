# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin
export GOROOT=$HOME/go
export GOPATH=$HOME/.gopath
path+=/bin
path+=/sbin
path+=/usr/local/bin
path+=/usr/bin
path+=/usr/sbin
path+=$HOME/bin
path+=$HOME/.local/bin
path+=$HOME/.tmuxifier/bin
path+=$HOME/.local/share/bob/nvim-bin
path+="$HOME/.deno/bin"
path+="$GOROOT/bin"
path+="$GOPATH/bin"

export PATH
# Path to your oh-my-zsh installation.
setopt PUSHDSILENT
set -o ignoreeof
export ZSH="$HOME/.oh-my-zsh"
export NVIM_APPNAME="nvim"
export NVIM_CONF="$HOME/.config/nvim"
export TMUXIFIER_LAYOUT_PATH="$HOME/.tmux-layouts"
export TIMEFMT=$'\n================\nCPU\t%P\nuser\t%*U\nsystem\t%*S\ntotal\t%*E'

# Set name of the theme to load --- if set to "random", it will
ZSH_THEME="robbyrussell"

HYPHEN_INSENSITIVE="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
DISABLE_UNTRACKED_FILES_DIRTY="true"

# Which plugins would you like to load?
plugins=(git fzf zsh-z zsh-autosuggestions omz-git)

eval "$(tmuxifier init -)"

# eval "$(zoxide init zsh)"

source $ZSH/oh-my-zsh.sh
source $HOME/.zshexports

# User configuration

# Preferred editor for local and remote sessions
 if [[ -n $SSH_CONNECTION ]]; then
   export EDITOR='vim'
 else
   export EDITOR='nvim'
 fi
# set editors
export GIT_EDITOR='nvim'
export VISUAL='nvim'
export EDITOR='nvim'

# Enable vi mode
bindkey -v

bindkey "^X^X" edit-command-line
bindkey "^y" autosuggest-accept

bindkey -M vicmd 'Y' vi-yank-whole-line
bindkey -M vicmd '^r' redo

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases

_kport () {
    kill -9 `lsof -ti :${1}`
}
alias kport=_kport

fzf-git-branch() {
    git rev-parse HEAD > /dev/null 2>&1 || return

    git branch --all --sort=-committerdate |
        grep -v HEAD |
        fzf --height 50% --ansi --no-multi --preview-window right:65% \
            --preview 'git log -n 50 --color=always --date=short --pretty="format:%C(auto)%cd %h%d %s" $(sed "s/.* //" <<< {})' |
        sed "s/.* //"
}

fzf-git-checkout() {
    git rev-parse HEAD > /dev/null 2>&1 || return

    local branch

    branch=$(fzf-git-branch)
    if [[ "$branch" = "" ]]; then
        echo "No branch selected."
        return
    fi

    # If branch name starts with 'remotes/' then it is a remote branch. By
    # using --track and a remote branch name, it is the same as:
    # git checkout -b branchName --track origin/branchName
    if [[ "$branch" = 'remotes/'* ]]; then
        output=$(git checkout --track "$branch")
        exit_status=$?
        if [[ "$exit_status" == "128" ]]; then
            local=$(basename "$branch")
            echo "$local"
            git checkout $local;
        else
            echo $resp
            echo "does not already exists"
        fi
    else
        git checkout $branch;
    fi
}
fzf-conf() {
	if [ "$#" -eq 0 ]; then
		selected=$(find -L ~/.config -mindepth 1 -maxdepth 1 -type d | fzf)
	else
		selected="$HOME/.config/$1"
	fi

	if [[ "$PWD" != "$selected" ]]; then
		pushd $selected && nvim . && popd;
	else
		nvim .
	fi
}

alias ls="ls --color=tty -F"

alias vim="nvim"
alias vi="nvim --clean"
alias conf=fzf-conf
alias vimconf='if [[ "$PWD" != "$NVIM_CONF" ]]; then pushd "$NVIM_CONF" && vim . && popd; else vim .; fi'
alias tmuxconf='if [[ "$PWD" != "$HOME" ]]; then pushd $HOME && vim .tmux.conf && popd ; else vim .tmux.conf; fi'
alias zshconf='if [[ "$PWD" != "$HOME" ]]; then pushd $HOME && vim .zshrc && popd && source ~/.zshrc; else vim .zshrc && source ~/.zshrc; fi'
alias zshsrc="source ~/.zshrc"
alias tldrf='tldr --list | fzf --preview "tldr {1} --color=always" --preview-window=right,70% | xargs tldr'
alias gcml='gcm && ggl && git fetch'
alias gfco='git fetch && gco'
alias gco=fzf-git-checkout
alias gco-='git checkout -'
alias gsfzf=' git stash pop `git stash list | fzf | cut \}`'
alias gitdelete="git branch --no-color | fzf -m | sed 's/^* //g' | xargs -I {} git branch -D '{}'"
alias vpn_tcit='sudo openfortivpn -c /etc/openfortivpn/tcit_vpn.conf --trusted-cert 15ef9850eb4025223a6d60a05c4a0378f6a7e34f0e50c69ec3e5f31d4a4c1ae1'
# alias -g P='| pe | fzf | read filename; [ ! -z $filename ] && vim $filename'
_tkfzf() {
	session=tmux ls | fzf | awk '{print $1;}'| sed 's/://'
	if [ !-z "$session" ]; then
		tmux kill-session -t $session
	fi
}
alias tkfzf=_tkfzf

alias ts='tmux-sessionizer'
alias tw='tmux-switch'
alias tks='tmux kill-server'
alias open='xdg-open'
alias ta='tmux attach'
alias tl='tmuxifier load-window'
alias tls='tmuxifier load-session'
alias lnt="golangci-lint run --config=~/.golangci.yaml ./..."
alias dbg="go build -gcflags='all=-N -l' -o debug && ./debug && rm debug"

_qfl () {
  echo -n "lint.txt:1:: Start\n" > lint.txt
  golangci-lint run >> lint.txt
  nvim -q lint.txt
}
alias qfl=_qfl

alias cdnv="cd ~/.config/nvim"
alias cdr='cd $(git rev-parse --show-toplevel)'
alias cdt=_cdt
_cdt () {
	if tmux info &> /dev/null; then
		cd $(tmux display-message -p '#{session_path}')
	else
		echo no tmux session running
	fi
}

_setbg () {
	kill -9 $(ps -aux  | grep swaybg -i | awk '{ print $2}')
    swaybg -i ${1} -m fill &!
}
alias setbg=_setbg
