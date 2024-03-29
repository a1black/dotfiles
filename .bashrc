# Note: difference between [ and [[ -  https://stackoverflow.com/a/3427931
## Load login shell configuration file.
[[ -s $HOME/.profile ]] && . $HOME/.profile

# Setup shell enviroment variables. {{{
export EDITOR='vim'
export LANG='en_US.UTF-8'
export LC_COLLATE='en_US.UTF-8'
# Make python use UTF-8 encoding.
export PYTHONIOENCODING='UTF-8'
export PYTHONDONTWRITEBYTECODE=1
# don't put duplicate lines or lines starting with space in the history.
export HISTCONTROL=ignoredups
export HISTCONTROL=ignoreboth
# Ignore simple commands.
export HISTIGNORE="clear:dir:ls:l[clw1]:[bf]g:exit:%[0-9]:top:htop"
export HISTSIZE=4000
export HISTFILESIZE=4000
# }}}

# Bash Shell options. {{{
shopt -so vi
shopt -s histappend
shopt -s checkwinsize
# Correct minor errors in the spelling of directory component.
shopt -s cdspell
# Attempt host completion when a word containing a '@' is being completed.
shopt -s hostcomplete
# autocd: `~/**/mp` will result in `cd -- ~/dir/dir/mp`
shopt -s autocd
# globstar: ls `~/**/mydir*/*.py` will list all ".py" file in subdirectories which name starts with "mydir".
shopt -s globstar
# Case-insensitive globbing (used in pathname expansion).
shopt -s nocaseglob
# }}}

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# Prompt autocomplition. {{{
# enable bash completion in interactive shells
if ! shopt -oq posix ; then
    [[ -f /etc/bash_completion ]] && . /etc/bash_completion
fi
# }}}

# Software settings. {{{
# Enable detailed git information in PS1.
export PS1_GIT_DETAILED=1
# Max length of virtual enviroment in PS1.
export PS1_ENV_NAME_LEN=14
# make less more friendly for non-text input files, see lesspipe(1).
[[ -x /usr/bin/lesspipe ]] && eval "$(SHELL=/bin/sh lesspipe)"
# Disable TTY XOFF flow control command (Ctrl+S)
stty -ixon
# less history file.
export LESS='-iXFJMRs'
export LESSHISTFILE="/dev/null"
# }}}

# User defined commands.
# Create and switch directory. {{{
mkcd() {
   case "$1" in /*) :;; *) set -- "./$1";; esac
   mkdir -p "$1" && cd "$1"
} #}}}
# Travel up the tree. {{{
up() {
    local path=".."
    for ((i=2; i<=${1:-1}; i++)); do
        path=$path/..
    done
    cd $path
} #}}}
# Function to generating passwords. {{{
genpass() {
    local len=8 choices=1
    if [[ "$1" =~ ^[0-9]+$ && "$1" -gt 7 ]]; then
        len="$1"
    fi
    if [[ "$2" =~ ^[0-9]+$ && "$2" -gt 1 ]]; then
        choices="$2"
    fi
    tr -dc '[:alnum:]' < /dev/urandom | fold -w $len | head -n $choices
} #}}}
# Function to toggling touchpad state. {{{
togtouch() {
    if command -v xinput &> /dev/null; then
        local id state
        id=$(xinput list --short 2> /dev/null | sed -n '/touchpad/Is/.*id=\([0-9]\+\).*/\1/p')
        [[ -z "$id" ]] && return 1
        state=$(xinput list-props "$id" | awk -F: '/Device Enabled/ {print 0+$2}' 2> /dev/null)
        if [[ "$state" -eq 1 ]]; then
            xinput disable "$id" &> /dev/null
            echo "Touchpad is disabled"
        else
            xinput enable "$id" &> /dev/null
            # Try to enable touchpad via synaptics (Xorg input driver).
            # It fixes unresponsive pointer problem.
            command -v synclient &> /dev/null && synclient TouchpadOff=0
            echo "Touchpad is enabled"
        fi
    fi
} #}}}
# Function to toggling wifi state. {{{
togwifi() {
    if command -v nmcli &> /dev/null; then
        local action=$(nmcli -c no -m multiline r wifi | grep -c enabled | sed -e 's/1/off/; s/0/on/')
        nmcli radio wifi $action &> /dev/null
        echo "Wi-Fi is $action"
    fi
} #}}}
# Function to display processes that utilize inotify watchers. {{{
# Args:
#   $1      Filter process list by the number of watchers (default: 100)
iwatchers() {
    local min=${1:-100} procs=0 total=0 cnt=0 pid=0 cmd
    printf "%6s %8s  %s\n" "COUNT" "PID" "COMMAND"
    while read watcher; do
        cnt=${watcher##*:}
        pid=${watcher%%:*}
        ((total += cnt))
        ((procs++))
        if ((cnt >= min)); then
            cmd=$(ps -o command= -p $pid)
            ((${#cmd} >= 79)) && cmd="${cmd:0:30}...${cmd: -46}"
            printf "%6d %8d  %s\n" "$cnt" "$pid" "$cmd"
        fi
    done < <(find /proc/*/fd -ilname anon_inode:*inotify* -printf '%h:' \
                -execdir grep -c '^inotify' ../fdinfo/{} \; 2> /dev/null | \
                sed -E 's/[^0-9:]//g ; /:0$/d' | sort -nr -t: -k2)
    printf -- "----------------------------------------\n"
    printf "%d  use  %d of %d" "$procs" "$total" "$(cat /proc/sys/fs/inotify/max_user_watches)"

} #}}}

# Alias definitions. {{{
# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'
# Enable colored output.
if [[ -x /usr/bin/dircolors ]]; then
    alias ls='ls --color=auto'
    alias grep='grep --color=auto'
fi
# list of aliases for ls utilite.
alias ll='ls -AlF --human-readable --escape'
alias lw='ls -AlF --human-readable --escape --group-directories-first'
alias lc='ls -CF --escape --group-directories-first'
alias l1='ls -1F --escape --group-directories-first'
# X clipboard
if command -v xsel &> /dev/null; then
    alias pbcopy='xsel -i -b'
    alias pbpaste='xsel -o -b'
elif command -v xclip &> /dev/null; then
    alias pbcopy='xclip -selection -c'
    alias pbpaste='xclip -selection clipboard -o'
fi
# Show process total memory usage.
alias memtotal="smem -t -k -c pss -P"
# Kill Chrome processes.
alias killchrome="ps -C chrome | grep chrome | awk '{print \$1}' | xargs -r kill -9"
# Kill VLC processes.
alias killvlc="ps -C vlc | grep vlc | awk '{print \$1}' | xargs -r kill -9"
# Disable display
alias doff="xset -display :0.0 dpms force off"
# }}}

# Solarized theme prompt colors. {{{
reset=$'\e[0m'
bold=$'\e[1m'
underline=$'\e[4m'
blink=$'\e[5m'
revs=$'\e[7m'
if [[ $TERM =~ 256color ]]; then
    # Solarized colors, taken from http://git.io/solarized-colors.
    black=$'\e[38;5;0m'
    blue=$'\e[38;5;33m'
    cyan=$'\e[38;5;37m'
    green=$'\e[38;5;64m'
    orange=$'\e[38;5;130m'
    purple=$'\e[38;5;125m'
    red=$'\e[38;5;124m'
    violet=$'\e[38;5;61m'
    white=$'\e[38;5;15m'
    yellow=$'\e[38;5;136m'
else
    black=$'\e[30m'
    blue=$'\e[34m'
    cyan=$'\e[36m'
    green=$'\e[32m'
    orange=$'\e[33m'
    purple=$'\e[35m'
    red=$'\e[31m'
    violet=$'\e[95m'
    white=$'\e[97m'
    yellow=$'\e[33m'
fi;
# }}}

# Command color output setup. {{{
# Highlight section titles in manual pages.
export LESS_TERMCAP_mb=$blink$red        # begin blinking
export LESS_TERMCAP_md=$bold$yellow      # begin bold
export LESS_TERMCAP_me=$reset            # end mode
export LESS_TERMCAP_se=$reset            # end standout-mode
export LESS_TERMCAP_so=$revs$green
#export LESS_TERMCAP_so=$'\e[40;48;5;28m' # begin standout-mode - info box
export LESS_TERMCAP_ue=$reset            # end underline
export LESS_TERMCAP_us=$underline$violet # begin underline
export GROFF_NO_SGR=1
# ls color scheme.
export CLICOLOR=1
LS_COLORS='no=00:fi=00:di=01;31:ln=01;36:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:ex=01;32:ow=34;47:*.tar=01;31:*.tgz=01;31:*.arj=01;31:*.taz=01;31:*.lzh=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.gz=01;31:*.bz2=01;31:*.deb=47;04;31:*.rpm=01;31:*.jar=01;31:*.jpg=01;35:*.jpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.mp4=01;35:*.mkv=01;35:*.avi=01;35:*.fli=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.ogg=01;35:*.mp3=01;35:*.wav=01;35:*.php=00;32:*.py=00;95:*.pyc=00;40:*.conf=00;31:*rc=00;31:*.sh=00;34:'
export LS_COLORS
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'
# }}}

## Primary and secondary prompt string customization.
# Statusline customization functions.
# Display sortend pwd. {{{
_prompt_short_pwd() {
    begin=""
    homebegin=""
    shortbegin=""
    current=""
    end="${2:-$(pwd)}/" # The unmodified rest of the path.
    end="${end#/}" # Strip the first /
    shortenedpath="$end"
    shopt -q nullglob && NGV="-s" || NGV="-u"
    shopt -s nullglob
    while [[ -n "$end" ]]; do
        current="${end%%/*}" # Everything before the first /
        end="${end#*/}" # Everything after the first /
        shortcur="$current"
        for ((i=${#current}-2; i>=0; i--)); do
            [[ ${#current} -le 20 && -z "$end" ]] && break
            subcurrent="${current:0:i}"
            # Array of all files that start with $subcurrent.
            matching=("$begin/$subcurrent"*)
            # Stop shortening if more than one file matches.
            (( ${#matching[*]} != 1 )) && break
            # Add character filler at the end of this string.
            [[ -z "$end" ]] && shortcur="$subcurrent..."
            # Add character filler at the end of this string.
            [[ -n "$end" ]] && shortcur="$subcurrent+"
        done
        begin="$begin/$current"
        homebegin="$homebegin/$current"
        # Convert HOME to ~.
        [[ "$homebegin" =~ ^"$HOME"(/|$) ]] && homebegin="~${homebegin#$HOME}"
        shortbegin="$shortbegin/$shortcur"
        # Use ~ for home.
        [[ "$homebegin" == "~" ]] && shortbegin="~"
        shortenedpath="$shortbegin/$end"
    done
    shortenedpath="${shortenedpath%/}" # Strip trailing /
    shortenedpath="${shortenedpath#/}" # Strip leading /
    # Make sure it starts with /
    [[ ! "$shortenedpath" =~ ^"~" ]] && printf "/$shortenedpath"
    # Don't use / for home directory.
    [[ "$shortenedpath" =~ ^"~" ]] && printf "$shortenedpath"
    # Reset nullglob in case this is being used as a function.
    shopt "$NGV" nullglob
} #}}}

# Return git status string. {{{
_prompt_git_status() {
    if [[ -v 'PS1_GIT_DETAILED' && $PS1_GIT_DETAILED == 1 ]]; then
        _prompt_git_status_detailed
    else
        _prompt_git_status_simple
    fi
} #}}}

# Return simple git status string. {{{
_prompt_git_status_simple() {
    # Check if current directory is git working tree.
    ! git rev-parse --is-inside-work-tree &> /dev/null && return
    # Check if the current directory is ".git".
    [[ $(git rev-parse --is-inside-git-dir 2> /dev/null) == 'true' ]] && return
    # Branch name.
    local branch=$(git symbolic-ref --quiet --short HEAD 2> /dev/null)
    local brcom=$(git rev-parse --short HEAD 2> /dev/null)
    local marks=''
    local bc=$green
    # Update index.
    git update-index --really-refresh -q &> /dev/null
    # Staged changes.
    ! git diff --quiet --ignore-submodules --cached && marks+='*' && bc=$yellow
    # Unstaged changes.
    ! git diff --quiet --ignore-submodules && marks+='+' && bc=$cyan
    # Untracked files.
    [[ $(git ls-files -o --exclude-standard | wc -l) != 0 ]] && marks+='?'
    # Unmerged files.
    [[ $(git ls-files --unmerged | wc -l) != 0 ]] && marks+='!' && bc=$red
    # Stashed changes.
    git rev-parse --verify refs/stash &> /dev/null && marks+='#'
    # Form git status string.
    if [[ -z "$branch" && -z "$brcom" ]]; then
        branch='(unknown)'
    elif [[ -z "$branch" ]]; then
        branch="$brcom"
    else
        branch="$branch($brcom)"
    fi
    [[ -n "$marks" ]] && marks=" [$marks] "
    printf '\001%s%s\002 %s \001%s\002%s\001%s\002' $revs $bc "$branch" $blue "$marks" $reset
} #}}}

# Return detailed git status string. {{{
_prompt_git_status_detailed() {
    # Check if current directory is git working tree.
    ! git rev-parse --is-inside-work-tree &> /dev/null && return
    # Check if the current directory is ".git".
    [[ $(git rev-parse --is-inside-git-dir 2> /dev/null) = 'true' ]] && return
    # Collect data.
    local seg=$(git status --branch --porcelain=v1 2> /dev/null)
    local seg_branch=$(echo -e "$seg" | head -n 1)
    local branch='' origin=''
    local ahead=0 behind=0
    [[ $seg_branch =~ ^##.([-a-zA-Z0-9_]+) ]] && branch=${BASH_REMATCH[1]}
    [[ $seg_branch =~ \.\.\.origin/([-a-zA-Z0-9_]+) ]] && origin=${BASH_REMATCH[1]}
    [[ $seg_branch =~ ahead[[:space:]]([0-9]+) ]] && ahead=${BASH_REMATCH[1]}
    [[ $seg_branch =~ behind[[:space:]]([0-9]+) ]] && behind=${BASH_REMATCH[1]}
    # Show commit hash if no branch name.
    [[ -z "$branch" ]] && branch=$(git rev-parse --short HEAD 2> /dev/null)
    # Show @upstream if branch names are different.
    [[ -n "$origin" && "$branch" != "$origin" ]] && branch="$branch...$origin"

    local stashed=$(git stash list --no-decorate 2> /dev/null | wc -l)
    local staged=0 changed=0 unmerged=0 untracked=0
    # For all posiable combinations of status codes see `man git-status`.
    while read line; do
        X=${line:0:1} Y=${line:1:1}
        # Process unmerged first, that makes counting staged and unstaged changes easier.
        if [[ "$X" = '?' ]]; then
            ((untracked++))
            continue
        elif [[ "$X" = 'U' || "$Y" = 'U' ]] || [[ "$X" = 'A' && "$Y" = 'A' ]] || [[ "$X" = 'D' && "$Y" = 'D' ]]; then
            ((unmerged++))
            continue
        elif [[ "$Y" = 'M' || "$Y" = 'D' ]]; then
            # DD / UD were excluded then counting `unmerged`.
            ((changed++))
        fi
        if [[ "$X" = 'A' || "$X" = 'C' || "$X" = 'D' || "$X" = 'M' || "$X" = 'R' ]]; then
            # AA / DD / AU / DU were excluded then counting `unmerged`.
            ((staged++))
        fi
    done < <(echo -e "$seg" | sed 's/^ /_/')

    local bg=$'\e[48;5;236m'
    # Determine branch color.
    local br_clr=$green
    [[ $staged != 0 ]] && br_clr=$yellow
    [[ $changed != 0 ]] && br_clr=$cyan
    [[ $unmerged != 0 ]] && br_clr=$red
    # Display branch name: \u2387 or \ue0a0 glyph.
    printf '\001%s%s\002 \ue0a0 %s \001%s\002' $revs $br_clr "$branch" $reset
    if [[ $ahead != 0 || $behind != 0 || $staged != 0 || $changed != 0 || $unmerged != 0 || $untracked != 0 || $stashed != 0 ]]; then
        printf '\001%s\002' $bg
        [[ $ahead != 0 ]] && printf ' \001%s\002%s\u21be' $white $ahead
        [[ $behind != 0 ]] && printf ' \001%s\002%s\u21c2' $red $behind
        [[ $staged != 0 ]] && printf ' \001%s\002*%s' $yellow $staged
        [[ $changed != 0 ]] && printf ' \001%s\002+%s' $cyan $changed
        [[ $untracked != 0 ]] && printf ' \001%s\002..%s' $orange $untracked
        [[ $unmerged != 0 ]] && printf ' \001%s\002\ud7 %s' $red $unmerged
        [[ $stashed != 0 ]] && printf ' \001%s\002\u2691 %s' $blue $stashed
        printf ' \001%s\002' $reset
    fi
} #}}}

# Return color accourding to privilages.
function _prompt_uid_color() {
    if [[ $UID == 0 ]]; then
        printf '\001%s\002\001%s\002' $bold $red
    elif sudo -n true &> /dev/null; then
        printf '\001%s\002\001%s\002' $bold $purple
    else
        printf '\001%s\002' $orange
    fi
}

# Return python virtualenv prompt component.
function _prompt_virtualenv() {
    if [[ -n "$VIRTUAL_ENV" ]]; then
        local virtenv_name=$(basename $VIRTUAL_ENV)
        local virtenv_len=${PS1_ENV_NAME_LEN:-12}
        if [[ ${#virtenv_name} -gt $virtenv_len ]]; then
            local virt_left=$(( ($virtenv_len-2)/3 ))
            local virt_right=$(( $virtenv_len-2-$virt_left ))
            virtenv_name=$(echo $virtenv_name | sed -En 's/(.{'$virt_right'}).*(.{'$virt_left'})/\1..\2/p')
        fi
        printf '\001%s%s\002 \u24d4 %s \001%s\002' $revs $violet $virtenv_name $reset
    fi
}
# }}}1

# Shell prompt customization. {{{
PS1="\[\033]0;\$(_prompt_short_pwd)\007\]"
PS1+="\n"
PS1+="\$(_prompt_uid_color)\u\[$reset\]"
[ -n "$SSH_TTY" ] && PS1+="\[$blue\] at \[$bold\]\[$purple\]\h\[$reset\]"
PS1+="\[$blue\] in "
PS1+="\[$green\]\w"
PS1+="\n"
PS1+="\[$revs\]\[$white\]\[$bold\]\A \[$reset\]"
PS1+="\$(_prompt_virtualenv)"
PS1+="\$(_prompt_git_status)"
PS1+=" \$(_prompt_uid_color)\$ \[$reset\]"
export PS1
PS2="\[$yellow\]→ \[$reset\]"
export PS2
# }}}

# fzf search settings. {{{
fzf_cmd=$(command -v fzf 2> /dev/null)
if [[ -n $fzf_cmd ]]; then
    fzf_home=$(realpath "$fzf_cmd" | xargs dirname | sed 's/\/bin//')
    [[ -s $fzf_home/shell/key-bindings.bash ]] && . "$fzf_home/shell/key-bindings.bash"

    export FZF_DEFAULT_OPTS='--no-height --no-reverse'
    export FZF_CTRL_T_OPTS='--select-1 --exit-0 --color=bw --preview "(highlight -O ansi -l {} 2> /dev/null || cat {} || ls --color=always -1 {}) 2> /dev/null | head -100"'
    export FZF_CTRL_R_OPTS='--preview "echo {}" --preview-window down:3:hidden:wrap --bind "?:toggle-preview"'

    unset fzf_home
fi
unset fzf_cmd
# }}}

# python virtualenv settings. {{{
if [[ -s "$WORKON_HOME/bin/virtualenvwrapper-init.sh" ]]; then
    # Move if-body to virtualenvwrapper-init.sh
    wrapper_source="$(command -v virtualenvwrapper_lazy.sh 2> /dev/null)"
    python_bin="$(command -v python3 2>/dev/null || command -v python 2>/dev/null)"
    if [[ -n $wrapper_source && -n $python_bin ]]; then
        export VIRTUALENVWRAPPER_PYTHON="$python_bin"
        export VIRTUALENVWRAPPER_HOOK_DIR=$WORKON_HOME/.config/virtualenvwrapper
        export VIRTUALENVWRAPPER_VIRTUALENV_ARGS='--no-site-packages'
        . "$wrapper_source"
    fi
fi
# }}}

# java sdkman settings.
[[ -r "$SDKMAN_DIR/bin/sdkman-init.sh" && ! -v "SDKMAN_PLATFORM" ]] \
    && . "$SDKMAN_DIR/bin/sdkman-init.sh"

# vi: ft=sh fdm=marker ts=4 sw=4 et
