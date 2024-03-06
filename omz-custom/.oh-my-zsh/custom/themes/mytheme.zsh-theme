function my_git_prompt() {
  tester=$(git rev-parse --git-dir 2> /dev/null) || return

  INDEX=$(git status --porcelain 2> /dev/null)
  STATUS=""

  # is branch ahead?
  if $(echo "$(git log origin/$(git_current_branch)..HEAD 2> /dev/null)" | grep '^commit' &> /dev/null); then
    STATUS="$STATUS$ZSH_THEME_GIT_PROMPT_AHEAD"
  fi

  # is branch behind?
  if $(echo "$(git log HEAD..origin/$(git_current_branch) 2> /dev/null)" | grep '^commit' &> /dev/null); then
    STATUS="$STATUS$ZSH_THEME_GIT_PROMPT_BEHIND"
  fi

  # is anything untracked?
  if $(echo "$INDEX" | grep '^?? ' &> /dev/null); then
    STATUS="$STATUS$ZSH_THEME_GIT_PROMPT_UNTRACKED"
  fi

  # is anything unstaged?
  if $(echo "$INDEX" | command grep -E -e '^[ MARC][MD] ' &> /dev/null); then
    STATUS="$STATUS$ZSH_THEME_GIT_PROMPT_UNSTAGED"
  fi

  # is anything staged?
  if $(echo "$INDEX" | command grep -E -e '^(D[ M]|[MARC][ MD]) ' &> /dev/null); then
    STATUS="$STATUS$ZSH_THEME_GIT_PROMPT_STAGED"
  fi

  # is anything unmerged?
  if $(echo "$INDEX" | command grep -E -e '^(A[AU]|D[DU]|U[ADU]) ' &> /dev/null); then
    STATUS="$STATUS$ZSH_THEME_GIT_PROMPT_UNMERGED"
  fi

  if command git -c log.showSignature=false log -n 1 2>/dev/null | grep -q -- "--wip--" &> /dev/null; then
    STATUS="$STATUS$ZSH_THEME_GIT_PROMPT_WIP"
  fi
  echo "$STATUS "
}

function git_prompt() {
  # If we are on a folder not tracked by git, get out.
  # Otherwise, check for hide-info at global and local repository level
  if ! __git_prompt_git rev-parse --git-dir &> /dev/null \
     || [[ "$(__git_prompt_git config --get oh-my-zsh.hide-info 2>/dev/null)" == 1 ]]; then
    return 0
  fi

  local ref
  ref=$(__git_prompt_git symbolic-ref --short HEAD 2> /dev/null) \
  || ref=$(__git_prompt_git describe --tags --exact-match HEAD 2> /dev/null) \
  || ref=$(__git_prompt_git rev-parse --short HEAD 2> /dev/null) \
  || return 0

  maxLength=25
  if [[ ${#ref} -gt ${maxLength} ]]; then
    suffixLength=$(command git config --get oh-my-zsh.suffix-length 2>/dev/null)
    if [[ -z ${suffixLength} ]]; then
      suffixLength=0
    fi

    length=${#ref}
    suffixStart=`expr ${length} - ${suffixLength} + 1`
    separatorLength=3 #3 dots...
    nameEnd=`expr ${maxLength} - ${suffixLength} - ${separatorLength}`
    ref="$(command echo ${ref} | cut -c 1-${nameEnd})...$(command echo ${ref} | cut -c ${suffixStart}-)"
  fi

  # Use global ZSH_THEME_GIT_SHOW_UPSTREAM=1 for including upstream remote info
  local upstream
  if (( ${+ZSH_THEME_GIT_SHOW_UPSTREAM} )); then
    upstream=$(__git_prompt_git rev-parse --abbrev-ref --symbolic-full-name "@{upstream}" 2>/dev/null) \
    && upstream=" -> ${upstream}"
  fi

  echo "${ZSH_THEME_GIT_PROMPT_PREFIX}${ref:gs/%/%%}${upstream:gs/%/%%}${ZSH_THEME_GIT_PROMPT_CLEAN}$(my_git_prompt)${ZSH_THEME_GIT_PROMPT_SUFFIX}"
}

PROMPT="%(?:%{$fg_bold[green]%}%1{➜%}:%{$fg_bold[red]%}%1{➜%}) %{$fg[cyan]%}%c%{$reset_color%}"
PROMPT+=' $(git_prompt)'

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg_bold[blue]%}git:(%{$fg[red]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[blue]%}) %{$fg[yellow]%}%1{✗%}"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[blue]%})"

ZSH_THEME_PROMPT_RETURNCODE_PREFIX="%{$fg_bold[red]%}"
ZSH_THEME_GIT_PROMPT_AHEAD="%{$fg_bold[magenta]%}↑"
ZSH_THEME_GIT_PROMPT_BEHIND="%{$fg_bold[red]%}↓"
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg_bold[magenta]%}●"
ZSH_THEME_GIT_PROMPT_UNSTAGED="%{$fg_bold[yellow]%}●"
ZSH_THEME_GIT_PROMPT_STAGED="%{$fg_bold[green]%}●"
ZSH_THEME_GIT_PROMPT_UNMERGED="%{$fg_bold[red]%}✕"
ZSH_THEME_GIT_PROMPT_WIP="%{$fg_bold[red]%} !!!WIP!!!"
