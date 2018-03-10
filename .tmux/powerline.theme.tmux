# Tmux Powerline plugin
run-shell "powerline-daemon -q"
run-shell "tmux set-environment -g POWERLINE_BASH_CONTINUATION 1"
run-shell "tmux set-environment -g POWERLINE_BASH_SELECT 1"
source $HOME/.local/lib/python3.6/site-packages/powerline/bindings/tmux/powerline.conf
