# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin
export GOROOT=$HOME/go
export GOPATH=$HOME/.gopath
export GOTESTS_TEMPLATE=testify
export VALE_CONFIG_PATH="/home/arne/.config/linters/vale/vale.ini"
path+=/bin
path+=/sbin
path+=/usr/local/bin
path+=/usr/bin
path+=/usr/sbin
path+=$HOME/bin
path+=$HOME/.local/bin
path+=$HOME/.local/share/bob/nvim-bin
path+=$HOME/.deno/bin
path+=$GOROOT/bin
path+=$GOPATH/bin

export PATH
# Path to your oh-my-zsh installation.
setopt PUSHDSILENT
set -o ignoreeof
export ZSH="$HOME/.oh-my-zsh"
export NVIM_APPNAME="nvim"
export NVIM_CONF="$HOME/.config/nvim"
export EMACS_CONF="$HOME/.config/emacs"
export TMUXIFIER_LAYOUT_PATH="$HOME/.tmux-layouts"
export TIMEFMT=$'\n================\nCPU\t%P\nuser\t%*U\nsystem\t%*S\ntotal\t%*E'

# Set name of the theme to load --- if set to "random", it will
ZSH_THEME="mytheme"

HYPHEN_INSENSITIVE="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
DISABLE_UNTRACKED_FILES_DIRTY="true"

# Which plugins would you like to load?
plugins=(git fzf zsh-autosuggestions branch)

eval "$(zoxide init zsh --cmd c)"
eval "$(thefuck --alias)"

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
bindkey -e

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

    if [[ $# -gt 0 ]]; then
		git branch --all --sort=-committerdate |
			grep -v HEAD |
			fzf --query="$@" --height 50% --ansi --no-multi --preview-window right:65% \
				--preview 'git log -n 50 --color=always --date=short --pretty="format:%C(auto)%cd %h%d %s" $(sed "s/.* //" <<< {})' |
			sed "s/.* //"
	else
		git branch --all --sort=-committerdate |
			grep -v HEAD |
			fzf --height 50% --ansi --no-multi --preview-window right:65% \
				--preview 'git log -n 50 --color=always --date=short --pretty="format:%C(auto)%cd %h%d %s" $(sed "s/.* //" <<< {})' |
			sed "s/.* //"
	fi
}

fzf-git-checkout() {
    git rev-parse HEAD > /dev/null 2>&1 || return

    local branch

	if [[ $# -eq 0 ]]; then
		branch=$(fzf-git-branch)
	else
		branch=$(fzf-git-branch $@)
	fi

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
			prefix="remotes/origin/"
            local="${branch#$prefix}"
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

alias gfco='git fetch && gco'
alias gco=fzf-git-checkout
alias gco-="git checkout -"
alias gcoo="git checkout"

fzf-conf() {
	if [ "$#" -eq 0 ]; then
		selected=$(find -L ~/.config -mindepth 1 -maxdepth 1 -type d | fzf)
	else
		selected="$HOME/.config/$1"
	fi

    num_files=$(ls -1 "$selected/" | wc -l)
    if [ "$num_files" -eq 1 ]; then
        file_name=$(ls "$selected/")
		if [[ "$PWD" != "$selected" ]]; then
			pushd $selected && nvim "$file_name" && popd || popd;
		else
			nvim "$file_name"
		fi
    else
		if [[ "$PWD" != "$selected" ]]; then
			pushd $selected && nvim . && popd || popd;
		else
			nvim .
		fi
    fi

}

_zshconf() {
	if [[ "$PWD" != "$HOME" ]]; then
		pushd $HOME && nvim .zshrc && popd || popd;
	else
		nvim .zshrc
	fi
	source ~/.zshrc
}

alias ls="ls --color=tty -F"
alias dispdis='swaymsg "output eDP-1 disable"'
alias dispen='swaymsg "output eDP-1 enable"'
alias vim="nvim"
alias vi="NVIM_APPNAME=nvim-minimal nvim"
alias noplug="NVIM_APPNAME=plugin-free-neovim nvim"
alias conf=fzf-conf
alias vimconf='if [[ "$PWD" != "$NVIM_CONF" ]]; then pushd "$NVIM_CONF" && vim . && popd || popd; else vim .; fi'
alias emacsconf='if [[ "$PWD" != "$EMACS_CONF" ]]; then pushd "$EMACS_CONF" && vim . && popd || popd; else vim .; fi'
alias tmuxconf='if [[ "$PWD" != "$HOME" ]]; then pushd $HOME && vim .tmux.conf && popd || popd; else vim .tmux.conf; fi'
alias zshconf=_zshconf
alias zshsrc="source ~/.zshrc"
alias gcml='gcm && ggl && git fetch'
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
alias fix='nvim -q .lint.txt'
alias pwip='gwip && ggp'
alias punwip='gunwip && ggf'

alias tms='tmux-sessionizer'
alias tks='tmux kill-server'
alias open='xdg-open'
alias ta='tmux attach'
alias tl='tmuxifier load-window'
alias tls='tmuxifier load-session'
alias lnt="golangci-lint run --config=~/.config/linters/golangci.yaml ./..."
alias dbg="go build -gcflags='all=-N -l' -o debug && ./debug && rm debug"

alias gfst="gfo && gst"
alias cdnv="cd ~/.config/nvim"
alias cdr='cd $(git rev-parse --show-toplevel)'
alias GW="export GOOS=windows"
alias GL="export GOOS=linux"
alias GU="unset GOOS"
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
_gmove() {
  git stash -- $(git diff --staged --name-only) &&
  gwip ;
  git branch $1 $2 &&
  git checkout $1 &&
  git stash pop
}
alias gmove=_gmove
_fzfhash() {
	git log --oneline --no-decorate --format='%h %<(40,trunc)%s %D' | fzf --preview 'GIT_EXTERNAL_DIFF="difft --display inline --width=$FZF_PREVIEW_COLUMNS --color=always" git show --ext-diff {1}' | awk '{ print $1 }'
}
alias fzfhash=_fzfhash

alias mqttstart="mosquitto -p 7070 > /dev/null 2>&1 & mosquitto -p 1883 > /dev/null 2>&1 & "
alias srcvenv="source .venv/bin/activate"

_cdpos() {
	selected=$( (find ~/Projects/lynxPositioning/dockers -mindepth 1 -maxdepth 2 -type d) | sed 's#^\(/[^/]*\)\{2\}/##' | fzf)
	if [ -n "$selected" ]; then
		cd ~/"$selected"
		cd src
	fi
}

alias cdpos=_cdpos

_mkfile() {
	mkdir -p $( dirname "$1") && touch "$1"
}
mkfile=_mkfile

_mkfcd() {
	mkdir -p $( dirname "$1") && touch "$1" && cd  $(dirname "$1")
}
alias mkfcd=_mkfcd
_mkvim() {
	mkdir -p $( dirname "$1") && touch "$1" && cd  $(dirname "$1") && nvim $( basename "$1" )
}

alias mkvim=_mkvim


# rebase current branch on top of upstream remote changes
function _greb() {
	UPSTREAM="$(git remote | grep upstream || git remote | grep origin)"
	BRANCH="$UPSTREAM/${$(git branch -rl \*/HEAD | head -1 | rev | cut -d/ -f1 | rev):-master}"
	git fetch "$UPSTREAM" && git --no-pager log --reverse --pretty=tformat:%s "$(git merge-base HEAD "$BRANCH")".."$BRANCH" && git rebase "$BRANCH"
}

alias greb=_greb

function _la() {
	if [ "$#" -eq 0 ]; then
		ls -lAh
	else
		ls -lAh | rg -i $1
	fi
}
alias la=_la
