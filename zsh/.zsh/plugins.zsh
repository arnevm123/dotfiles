export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="mytheme"

HYPHEN_INSENSITIVE="true"

# Disable marking untracked files under VCS as dirty.
# This makes repository status check for large repositories much, much faster.
DISABLE_UNTRACKED_FILES_DIRTY="true"

export PYAUTOENV_VENV_NAME=venv

plugins=(git fzf zsh-autosuggestions branch pyautoenv)

source $ZSH/oh-my-zsh.sh
