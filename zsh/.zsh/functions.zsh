_kport () {
	kill -9 `lsof -ti :${1}`
}

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


_cdg () {
	if git rev-parse --is-inside-work-tree &> /dev/null; then
		cd "$(git rev-parse --show-toplevel)"
	else
		echo "Not inside a Git repository."
	fi
}

_cdt () {
	if tmux info &> /dev/null; then
		pth=$(tmux display-message -p '#{session_path}')
		if [[ "$pth" == "/home/arne/home" ]]; then
			cd "$HOME"
		else
			cd "$pth"
		fi
	else
		echo no tmux session running
	fi
}

_setbg () {
	kill -9 $(ps -aux  | grep swaybg -i | awk '{ print $2}')
	swaybg -i ${1} -m fill &!
}

_extract() {
	if [ -f "$1" ]; then
		case "$1" in
			*.tar.bz2)   tar xjf "$1"    ;;
			*.tar.gz)    tar xzf "$1"    ;;
			*.bz2)       bunzip2 "$1"    ;;
			*.rar)       unrar x "$1"    ;;
			*.gz)        gunzip "$1"     ;;
			*.tar)       tar xf "$1"     ;;
			*.zip)       unzip "$1"      ;;
			*.Z)         uncompress "$1" ;;
			*)           echo "'$1' cannot be extracted" ;;
		esac
	fi
}

function _dcsh() {
	docker compose exec -it "$1" sh
}

function git_main_branch() {
	echo $(git remote show origin | sed -n '/HEAD branch/s/.*: //p')
}

cl() {
	local dir
	dir=$(find $(pwd) -type d | grep "^$(pwd)" | fzf) && cd "$dir"
}
