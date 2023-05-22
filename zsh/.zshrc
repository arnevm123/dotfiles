# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin
path+=/bin
path+=/sbin
path+=/usr/local/bin
path+=/usr/bin
path+=/usr/sbin
PATH+=/usr/local/go/bin
path+=/opt/homebrew/bin
path+=/opt/homebrew/sbin
path+=/opt/homebrew/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/bin
path+=$HOME/bin
path+=$HOME/neovim/bin
path+=$HOME/go/bin
path+=$HOME/.cargo/bin
path+=$HOME/.deno/bin
path+=$HOME/.moaprcli/bin
path+=$HOME/google-cloud-sdk/bin
path+=$HOME/.tmuxifier/bin
export PATH
# Path to your oh-my-zsh installation.
setopt PUSHDSILENT
export ZSH="$HOME/.oh-my-zsh"
export MOAPR_ROOT=/Users/arnevm/Documents/moaprplatform
export NEXUZ_ROOT=/Users/arnevm/Documents/nexuz
export JAVA_HOME=/Library/Java/JavaVirtualMachines/zulu-18.jdk/Contents/Home
export NVIM_APPNAME="nvim"
export TMUXIFIER_LAYOUT_PATH="$HOME/.tmux-layouts"
export TIMEFMT=$'\n================\nCPU\t%P\nuser\t%*U\nsystem\t%*S\ntotal\t%*E'

if [ -f /opt/homebrew/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc ]; then
    source /opt/homebrew/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc
fi

# Set name of the theme to load --- if set to "random", it will
ZSH_THEME="robbyrussell"

HYPHEN_INSENSITIVE="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
DISABLE_UNTRACKED_FILES_DIRTY="true"

# Which plugins would you like to load?
plugins=(git fzf zsh-z zsh-autosuggestions)

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
        git checkout --track $branch
    else
        git checkout $branch;
    fi
}
fzf-conf() {
    selected=$(find -L ~/.config -mindepth 1 -maxdepth 1 -type d | fzf)
	pushd $selected && nvim . && popd || popd
}

# alias buildbe="cdlocalfull && go build -gcflags='all=-N -l'"
# alias r="cdbe && rm .pid || true && ./localfull -enable-java -dump-pid"
alias vim="nvim"
alias vi="nvim"
alias v="nvim ."
alias conf=fzf-conf
alias vimconf="pushd ~/.config/nvim && vim . && popd || popd"
alias tmuxconf="vim ~/.tmux.conf"
alias zshconf="pushd ~ && vim .zshrc && popd && source ~/.zshrc"
alias zshsrc="source ~/.zshrc"
alias tldrf='tldr --list | fzf --preview "tldr {1} --color=always" --preview-window=right,70% | xargs tldr'
alias gcml='gcm && ggl && git fetch'
alias gfco='git fetch && gco'
alias gco=fzf-git-checkout
alias gsfzf=' git stash pop `git stash list | fzf | cut \}`'
alias gitdelete="git branch --no-color | fzf -m | sed 's/^* //g' | xargs -I {} git branch -D '{}'"
# alias -g P='| pe | fzf | read filename; [ ! -z $filename ] && vim $filename'
alias weer='curl https://wttr.in/zedelgem'
alias tks='tmux kill-server'
alias ts='tmux-sessionizer'
alias tw='tmux-switch'
alias ta='tmux attach'
alias tl='tmuxifier load-window'
alias lnt="golangci-lint run --config=~/.golangci.yaml ./..."

### moapr specific
alias cdfe="cd ~/Documents/moaprfrontend/moapr"
alias runfe="cdfe && npm run"
alias cdlf="cd ~/Documents/moaprplatform/platform/scripts/local-full"
alias cdnv="cd ~/.config/nvim"
alias cdlf="cd ~/Documents/moaprplatform/platform/scripts/local-full"
alias pubsub="gcloud beta emulators pubsub start --project=prj-nxh-moaprplatform-dev-7e0ck --host-port=localhost:8085 --verbosity=debug"
_cdbe () {
  if [[ $# -gt 0 ]]; then
	  cd $MOAPR_ROOT/platform/golang/nexuz/${1}/src/golang
  else
	  cd $MOAPR_ROOT
  fi
}
_goki () {
  if [[ $# -gt 0 ]]; then
	  cd $MOAPR_ROOT/platform/golang/nexuz/${1}/src/golang
  else
	  cd $MOAPR_ROOT
  fi
  if [[ $# -gt 1 ]]; then
	  gokiburi --listen-port ${2}
  else
	  gokiburi
  fi
}

_gtest () {
	cd $MOAPR_ROOT/platform/golang/nexuz/${1}/src/golang && richgo test ./... && popd
}
alias gtest=_gtest
alias cdbe=_cdbe
alias goki=_goki
_mpg () {
    pushd $MOAPR_ROOT && moapr proto go ${1} && popd || popd
}
_setbg () {
	kill -9 $(ps -aux  | grep swaybg -i | awk '{ print $2}')
    swaybg -i ${1} -m fill &!
}
alias mpg=_mpg
alias setbg=_setbg

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/home/arne/google-cloud-sdk/path.zsh.inc' ]; then . '/home/arne/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/home/arne/google-cloud-sdk/completion.zsh.inc' ]; then . '/home/arne/google-cloud-sdk/completion.zsh.inc'; fi
