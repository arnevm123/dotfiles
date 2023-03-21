# set -g default-terminal "screen-256color"
# Add truecolor support for the terminals you use
set-option -ga terminal-overrides ",xterm-256color:Tc,screen-256color:Tc,tmux-256color:Tc"
# Default terminal is 256 colors
set -g default-terminal "tmux-256color"


# set -g default-terminal "tmux-256color".
set -as terminal-overrides ',xterm*:Tc:sitm=\E[3m'
unbind C-b
set-option -g prefix C-a
bind-key C-a send-prefix

bind r source-file ~/.tmux.conf
set -g base-index 1

set-window-option -g mode-keys vi
set-option -sg escape-time 10
set-option -g focus-events off
set -g mouse on
set -ag terminal-overrides ",xterm-256color:RGB"
bind -T copy-mode-vi v send-keys -X begin-selection
bind -T copy-mode-vi y send-keys -X copy-pipe-and-cancel 'xclip -in -selection clipboard'

# vim-like pane switching
bind -r ^ last-window
bind -r k select-pane -U
bind -r j select-pane -D
bind -r h select-pane -L
bind -r l select-pane -R

# Stay in copy mode on drag end.
# (Would use `bind-key -T copy-mode-vi MouseDragEnd1Pane send-keys -X
# stop-selection` but it is a bit glitchy.)
unbind-key -T copy-mode-vi MouseDragEnd1Pane

bind-key i run-shell "tmux neww ~/bin/tmux-cht.sh"
bind-key a run-shell "tmux neww ~/FOSS/andcli/bin/andcli"
bind-key W run-shell "tmux neww nvim ~/WerkNotes/"

bind-key C-e setw synchronize-panes on \; send-keys  C-c !! Enter Enter \; setw synchronize-panes off
bind-key C-c setw synchronize-panes on \; send-keys  C-c \; setw synchronize-panes off
bind-key -n C-e send-keys C-c !! Enter Enter
bind-key R command-prompt "send-keys -t '%%' C-c !! Enter Enter"

bind '"' split-window -c "#{pane_current_path}"
bind '%' split-window -h -c "#{pane_current_path}"

bind -r n next-window
bind -r p previous-window
bind -r o select-pane -t :.+
bind-key S choose-session
bind-key X kill-pane



bind -r C-h resize-pane -L 5
bind -r C-j resize-pane -D 5
bind -r C-k resize-pane -U 5
bind -r C-l resize-pane -R 5

# List of plugins
set -g @plugin 'tmux-plugins/tpm'
set -g @plugin 'tmux-plugins/tmux-yank'
set -g @plugin 'tmux-plugins/tmux-open'
set -g @plugin 'tmux-plugins/tmux-resurrect'
set -g @plugin 'xamut/tmux-spotify'
set -g @plugin 'laktak/extrakto'
set -g @plugin 'tmux-plugins/tmux-fpp'
set -g @extrakto_popup_size "50%, 30%"
set -g @extrakto_copy_key "tab"      # use tab to copy to clipboard
set -g @extrakto_insert_key "enter"  # use enter to insert selection

# Disable default binding
set -g @fpp-bind off

# Bind 'o' to run FPP launching an editor
bind-key o run-shell '~/.tmux/plugins/tmux-fpp start edit'

# Bind 'O' to run FPP and paste the list of files in the initial pane
bind-key O run-shell '~/.tmux/plugins/tmux-fpp start paste'

set -g @open-S 'https://www.google.com/search?q='
set -g @open 'gx'

bind-key f run-shell "tmux neww ~/bin/tmux-sessionizer"
bind-key F command-prompt "find-window -Z -- '%%'"
bind w display-popup -E "tmux list-windows | grep -v \"^$(tmux display-message -p '#S')\$\" | fzf --reverse | cut -d \":\" -f 1 | xargs tmux select-window -t"

bind-key Space next-layout

set -g mode-style "fg=#c9d1d9,bg=#1f2428"

set -g pane-border-format '#(sleep 0.5; ps -t #{pane_tty} -o args= | head -n 2)'

# set -g pane-border-format "[#[fg=white]#{?pane_active,#[bold],} :#P: #T #[fg=default,nobold]]"
# set -g pane-border-format " #P: #(cat -A /proc/#{pane_pid}/cmdline) "
# set -g pane-border-format '#(ps -f --pid #{pane_ppid} -o args)'
# set -g pane-border-format '#(ps -t #{pane_tty} -o args -c)'
# set -g pane-border-format '#(ps -t #{pane_tty} -o args= | head -n 1)'
# set -g pane-border-format '#P: #{pane_pid}'
# set -g pane-border-format " #P: #{pane_current_command} "
# set -g pane-border-format "#{pane_current_path} #{pane_current_command}"

# Auto hide pane-border-status line when only one pane is displayed (see tmux/tmux#566)
set-hook -g 'after-new-session'  'run-shell -b "if [ \#{window_panes} -eq 1 ]; then tmux set pane-border-status off; fi"'
set-hook -g 'after-new-window'   'run-shell -b "if [ \#{window_panes} -eq 1 ]; then tmux set pane-border-status off; fi"'
set-hook -g 'after-kill-pane'    'run-shell -b "if [ \#{window_panes} -eq 1 ]; then tmux set pane-border-status off; fi"'
set-hook -g 'pane-exited'        'run-shell -b "if [ \#{window_panes} -eq 1 ]; then tmux set pane-border-status off; fi"'
set-hook -g 'after-split-window' 'run-shell -b "if [ \#{window_panes} -gt 1 ]; then tmux set pane-border-status top; fi"'

set -g status "on"
set -g status-justify "left"
set-option -g focus-events on

# set -g status-style "fg=#2188ff,bg=#1f2428"

# # Github colors for Tmux
# set -g message-style "fg=#c9d1d9,bg=#1f2428"
# set -g message-command-style "fg=#c9d1d9,bg=#1f2428"
#
# set -g pane-border-style "fg=#444c56"
# set -g pane-active-border-style "fg=#2188ff"
#

# panes
set -g pane-border-style 'fg=colour244'
set -g pane-active-border-style 'fg=colour255'

# window style

set -g status-style 'bg=#303030 fg=#97bdde'
# set -g status-style 'bg=#303030'
setw -g window-status-current-style 'fg=colour255'
setw -g window-status-current-format ' #I#[fg=colour255]:#[fg=colour255]#W#[fg=#97bdde]#F '
setw -g window-status-style 'fg=colour250'
setw -g window-status-format ' #I#[fg=colour250]:#[fg=colour250]#W#[fg=colour244]#F '

set -g status-left-length "100"
set -g status-right "%a %d/%m/%Y %H:%M"
# set -g status-right-length "100"
#
# set -g status-left-style NONE
# set -g status-right-style NONE
#
# set -g status-left "#[fg=#1f2428,bg=#2188ff,bold] #S #[fg=#2188ff,bg=#1f2428,nobold,nounderscore,noitalics]"
# set -g status-right "#[fg=#e1e4e8,bg=#1f2428,nobold,nounderscore,noitalics]#[fg=#586069,bg=#e1e4e8] %d/%m/%Y %I:%M #[fg=#1f2428,bg=#1f2428,nobold,nounderscore,noitalics]#[fg=#666666,bg=#1f2428,nobold,nounderscore,noitalics]"
# set -g mode-style "fg=default,bg=default,reverse"
#
# setw -g window-status-activity-style "underscore,fg=#d1d5da,bg=#1f2428"
# setw -g window-status-separator ""
# setw -g window-status-style "NONE,fg=#24292e,bg=#1f2428"
# setw -g window-status-format "#[fg=#1f2428,bg=#1f2428,nobold,nounderscore,noitalics]#[fg=#666666,bg=#1f2428,nobold,nounderscore,noitalics] #I  #W #F"
# setw -g window-status-current-format "#[fg=#1f2428,bg=#e1e4e8,nobold,nounderscore,noitalics]#[fg=#586069,bg=#e1e4e8,bold] #I  #W #F"
# Initialize TMUX plugin manager (keep this line at the very bottom of tmux.conf)
run '~/.tmux/plugins/tpm/tpm'

