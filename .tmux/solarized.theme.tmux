# https://github.com/seebi/tmux-colors-solarized/blob/master/tmuxcolors-256.conf
# default statusbar colors
set-option -g status-bg colour234                       #base03
set-option -g status-fg colour136                       #yellow
set-option -g status-attr default

# default window title colors
set-window-option -g window-status-fg colour244         #base0
set-window-option -g window-status-bg default
#set-window-option -g window-status-attr dim

# active window title colors
set-window-option -g window-status-current-fg colour166 #orange
set-window-option -g window-status-current-bg default
#set-window-option -g window-status-current-attr bright

# pane border
set-option -g pane-border-fg colour235                  #base02
set-option -g pane-active-border-fg colour240           #base01

# message text
set-option -g message-bg colour235                      #base02
set-option -g message-fg colour166                      #orange

# pane number display
set-option -g display-panes-active-colour colour33      #blue
set-option -g display-panes-colour colour166            #orange

# clock
set-window-option -g clock-mode-colour colour64         #green

set -g status-justify left                              # aligning of window list
set -g status-left-length 20
set -g status-right-length 140
set -g status-left '#[default](#S) #[fg=red]• #[default]'
set -g status-right '#[fg=green,bg=default]#(cut -d " " -f 1-3 /proc/loadavg) #[fg=white]< #[default]%a #[fg=white]< #[default]%b %d #[fg=white]< #[fg=blue]%H:%M #[fg=white]< #[fg=magenta]#(whoami)@#H #[default]'
