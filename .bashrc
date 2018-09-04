## Load login shell configuration file.
[ -f $HOME/.profile ] && . $HOME/.profile

# Setup shell enviroment variables. {{{1
export EDITOR='vim'
export LANG='en_US.UTF-8'
export LC_COLLATE='en_US.UTF-8'
# Make python use UTF-8 encoding.
export PYTHONIOENCODING='UTF-8'
# don't put duplicate lines or lines starting with space in the history.
export HISTCONTROL=ignoredups
export HISTCONTROL=ignoreboth
# Ignore simple commands.
export HISTIGNORE="clear:dir:ls:l[clw1]:[bf]g:exit:%[0-9]:top:htop"
export HISTSIZE=4000
export HISTFILESIZE=4000
# }}}1

# Bash Shell options. {{{1
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
# }}}1

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# Prompt autocomplition. {{{1
# enable bash completion in interactive shells
if ! shopt -oq posix && [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
fi
# }}}1

# Software settings. {{{1
# Enable periodic `git fetch` in current directory.
export PS1_GIT_FETCH_ENABLE=0
# Battery energy below this PS1 will have remain charge indicator.
export PS1_LOW_BATTERY_ENERGY=60
# Enable Powerline statusline plugin.
export POWERLINE_ENABLE=0
# make less more friendly for non-text input files, see lesspipe(1).
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"
# Disable TTY XOFF flow control command (Ctrl+S)
stty -ixon
# less history file.
export LESS='-iFJMRs'
export LESSHISTFILE="/dev/null"
# }}}1

# User defined commands. {{{1
# Create and switch directory.
mkcd() {
   case "$1" in /*) :;; *) set -- "./$1";; esac
   mkdir -p "$1" && cd "$1"
}
# System shutdown.
medown() {
    local subcmd=''
    [ "$1" != 'now' ] && { sudo apt-get update -qq;sudo apt-get -qq upgrade; }
    shutdown -h now
}
# Travel up the tree.
up() {
    local path=".."
    for ((i=2; i<=${1:-1}; i++)); do
        path=$path/..
    done
    cd $path
}
# Simple wrap for upower util for providing short battery remain charge.
wpower() {
    local battery_id battery_info
    battery_id=$(upower -e 2> /dev/null | grep -m 1 battery)
    [ -z "$battery_id" ] && return 1
    battery_info=$(upower -i $battery_id 2> /dev/null | \
        sed -n -E '/state:/p;/percentage:/p;/(remain|time to [a-z]+):/p')
    [ -z "$battery_info" ] && return 1
    # Charging/discharging state.
    local plugged=$(cat <<< $battery_info | awk '/state:/ {print $2}')
    # Remain energy in percents.
    local energy_left=$(cat <<< $battery_info | awk '/percentage:/ {print 0+$2}')
    if [ "$energy_left" -eq 0 ]; then
        return 1
    elif [ "${plugged,,}" = 'charging' ]; then
        # Prints out charging information.
        printf "\u26a1%d%%" $energy_left
    else
        # Calculate remaining time before full discharge.
        local time_to=$(cat <<< $battery_info | grep -E '(remain|time to [a-z]+)' | cut -d: -f2)
        local time_left=$(echo "$time_to" | awk '{print 0+$1}')
        # Translate hours to minutes.
        if echo "$time_to" | grep -q 'hours'; then
            time_left=$(awk -v left=$time_left 'BEGIN{printf "%.0f", left*60}')
        else
            time_left=$(printf "%.0f" $time_left)
        fi
        # Prints out remaining energy.
        printf "%d%% %d:%02d" $energy_left $(($time_left / 60)) $(($time_left % 60))
    fi
}
# Function for generating passwords.
genpass() {
    local len=8 choices=1
    if [[ "$1" =~ ^[0-9]+$ ]] && [[ "$1" -gt 7 ]]; then
        len="$1"
    fi
    if [[ "$2" =~ ^[0-9]+$ ]] && [[ "$2" -gt 1 ]]; then
        choices="$2"
    fi
    tr -dc '[:alnum:]' < /dev/urandom | fold -w $len | head -n $choices
}
# }}}1

# Alias definitions. {{{1
# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'
# Enable colored output.
if [ -x /usr/bin/dircolors ]; then
    alias ls='ls --color=auto'
    alias grep='grep --color=auto'
fi
# list of aliases for ls utilite.
alias ll='ls -AlF --human-readable --escape'
alias lw='ls -AlF --human-readable --escape --group-directories-first'
alias lc='ls -CF --escape --group-directories-first'
alias l1='ls -1F --escape --group-directories-first'
# Php
alias phpcsfix='php-cs-fix fix --verbose --show-progress=dots'
# X clipboard
if which xsel >/dev/null 2>&1 ; then
    alias pbcopy='xsel -i -b'
    alias pbpaste='xsel -o -b'
elif which xclip >/dev/null 2>&1 ; then
    alias pbcopy='xclip -selection -c'
    alias pbpaste='xclip -selection clipboard -o'
fi
# Show process total memory usage.
alias memtotal="smem -t -k -c pss -P"
# Kill Chrome processes.
alias killchrome="ps -C chrome | grep chrome | awk '{print \$1}' | xargs -r kill -9"
# Disable display
alias doff="xset -display :0.0 dpms force off"
# }}}1

# Solarized theme prompt colors. {{{1
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
# }}}1

# Command color output setup. {{{1
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
# }}}1

## Primary and secondary prompt string customization.
# Statusline customization functions. {{{1
# Display sortend pwd.
function _prompt_short_pwd() { #{{{2
    begin=""
    homebegin=""
    shortbegin=""
    current=""
    end="${2:-$(pwd)}/" # The unmodified rest of the path.
    end="${end#/}" # Strip the first /
    shortenedpath="$end"
    shopt -q nullglob && NGV="-s" || NGV="-u"
    shopt -s nullglob
    while [ -n "$end" ]; do
        current="${end%%/*}" # Everything before the first /
        end="${end#*/}" # Everything after the first /
        shortcur="$current"
        for ((i=${#current}-2; i>=0; i--)); do
            [ ${#current} -le 20 ] && [ -z "$end" ] && break
            subcurrent="${current:0:i}"
            # Array of all files that start with $subcurrent.
            matching=("$begin/$subcurrent"*)
            # Stop shortening if more than one file matches.
            (( ${#matching[*]} != 1 )) && break
            # Add character filler at the end of this string.
            [ -z "$end" ] && shortcur="$subcurrent..."
            # Add character filler at the end of this string.
            [ -n "$end" ] && shortcur="$subcurrent+"
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
} #}}}2

# Display battery indicator on low remain energy.
# Args:
#   -bg     colorize output using background
function _prompt_low_energy() {
    local info=$(wpower)
    [ -z "$info" ] && return 1
    local energy_left=$(cat <<< "$info" | grep -oP '\d+(?=%)' | awk '{print 0+$1}')
    local energy_low=$(awk -v low="$PS1_LOW_BATTERY_ENERGY" 'BEGIN{print 0+low}')
    ((energy_low > 0 && energy_left > 0 && energy_left > energy_low)) && return 0
    # Colorize output.
    local clr bg=0
    [ "$1" = '-bg' ] && bg=1
    if ((energy_left <= 20)); then
        ((bg == 1)) && clr=$'\e[48;5;124m\e[38;5;15m' || clr=$'\e[38;5;124m'
    elif ((energy_left <= 50)); then
        ((bg == 1)) && clr=$'\e[48;5;202m\e[38;5;0m' || clr=$'\e[38;5;202m'
    elif ((energy_left <= 80)); then
        ((bg == 1)) && clr=$'\e[48;5;226m\e[38;5;0m' || clr=$'\e[38;5;226m'
    else
        ((bg == 1)) && clr=$'\e[48;5;34m\e[38;5;15m' || clr=$'\e[38;5;34m'
    fi
    printf "\001%s\002 %s \001%s\002" $clr "$info" $reset
}

# Do background update of git index every N minutes.
function _git_status_fetch() { #{{{2
    [ "$PS1_GIT_FETCH_ENABLE" != '1' ] && return 0
    local state_cache="$UID-$$"
    [ ! -e "/dev/shm/$state_cache" ] && date +%s > /dev/shm/$state_cache
    local old_mark=$(cat /dev/shm/$state_cache)
    local new_mark=$(date +%s)
    ((new_mark -= $old_mark))
    if [ $new_mark -ge 300 ]; then
        date +%s > /dev/shm/$state_cache
        git fetch -q &> /dev/null &
    fi
} #}}}2

# Return simple git status string.
function _prompt_git_status_simple() { #{{{2
    # Check if current directory is git working tree.
    ! git rev-parse --is-inside-work-tree > /dev/null 2>&1 && return
    # Check if the current directory is ".git".
    [ $(git rev-parse --is-inside-git-dir 2> /dev/null) = 'true' ] && return
    # Do `git fetch`.
    _git_status_fetch
    # Branch name.
    local branch=$(git symbolic-ref --quiet --short HEAD 2> /dev/null)
    local brcom=$(git rev-parse --short HEAD 2> /dev/null)
    local marks=''
    local bc=$green
    # Update index.
    git update-index --really-refresh -q > /dev/null 2>&1
    # Staged changes.
    ! git diff --quiet --ignore-submodules --cached && marks+='*' && bc=$yellow
    # Unstaged changes.
    ! git diff --quiet --ignore-submodules && marks+='+' && bc=$cyan
    # Untracked files.
    [ $(git ls-files -o --exclude-standard | wc -l) -ne 0 ] && marks+='?'
    # Unmerged files.
    [ $(git ls-files --unmerged | wc -l) -ne 0 ] && marks+='!' && bc=$red
    # Stashed changes.
    git rev-parse --verify refs/stash > /dev/null 2>&1 && marks+='#'
    # Form git status string.
    if [[ -z "$branch" && -z "$brcom" ]]; then branch='(unknown)'
    elif [ -z "$branch" ]; then branch="$brcom"
#    else branch="$branch($brcom)"
    fi
    [ -n "$marks" ] && marks=" [$marks] "
    printf '\001%s%s\002 %s \001%s\002%s\001%s\002' $revs $bc "$branch" $blue "$marks" $reset
} #}}}2

# Return detailed git status string.
function _prompt_git_status_detailed() { #{{{2
    # Check if current directory is git working tree.
    ! git rev-parse --is-inside-work-tree > /dev/null 2>&1 && return
    # Check if the current directory is ".git".
    [ $(git rev-parse --is-inside-git-dir 2> /dev/null) = 'true' ] && return
    # Do `git fetch`.
    _git_status_fetch
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
    [ -z "$branch" ] && branch=$(git rev-parse --short HEAD 2> /dev/null)
    # Show @upstream if branch names are different.
    [[ -n "$origin" && "$branch" != "$origin" ]] && branch="$branch...$origin"

    local stashed=$(git stash list --no-decorate 2> /dev/null | wc -l)
    local staged=0 changed=0 unmerged=0 untracked=0
    # For all posiable combinations of status codes see `man git-status`.
    while read line; do
        X=${line:0:1} Y=${line:1:1}
        # Process unmerged first, that makes counting staged and unstaged changes easier.
        if [ "$X" = '?' ]; then
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
    [ $staged -ne 0 ] && br_clr=$yellow
    [ $changed -ne 0 ] && br_clr=$cyan
    [ $unmerged -ne 0 ] && br_clr=$red
    # Display branch name: \u2387 or \ue0a0 glyph.
    printf '\001%s%s\002 \ue0a0 %s \001%s\002' $revs $br_clr "$branch" $reset
    if [[ $ahead -ne 0 || $behind -ne 0 || $staged -ne 0 || $changed -ne 0 || $unmerged -ne 0 || $untracked -ne 0 || $stashed -ne 0 ]]; then
        printf '\001%s\002' $bg
        [ $ahead -ne 0 ] && printf ' \001%s\002%s\u21be' $white $ahead
        [ $behind -ne 0 ] && printf ' \001%s\002%s\u21c2' $red $behind
        [ $staged -ne 0 ] && printf ' \001%s\002*%s' $yellow $staged
        [ $changed -ne 0 ] && printf ' \001%s\002+%s' $cyan $changed
        [ $untracked -ne 0 ] && printf ' \001%s\002..%s' $orange $untracked
        [ $unmerged -ne 0 ] && printf ' \001%s\002\ud7 %s' $red $unmerged
        [ $stashed -ne 0 ] && printf ' \001%s\002\u2691 %s' $blue $stashed
        printf ' \001%s\002' $reset
    fi
} #}}}2

# Return color accourding to privilages.
function _prompt_uid_color() {
    if [ $UID -eq 0 ]; then
        printf '\001%s\002\001%s\002' $bold $red
    elif sudo -n true > /dev/null 2>&1; then
        printf '\001%s\002\001%s\002' $bold $purple
    else
        printf '\001%s\002' $orange
    fi
}

# Return python virtualenv prompt component.
function _prompt_virtualenv() {
    if [ -n "$VIRTUAL_ENV" ]; then
        printf '\001%s%s\002 \u24d4 %s \001%s\002' $revs $violet $(basename $VIRTUAL_ENV) $reset
    fi
}
# }}}1

# Shell prompt customization. {{{1
PS1="\[\033]0;\$(_prompt_short_pwd)\007\]"
PS1+="\n"
PS1+="\$(_prompt_uid_color)\u\[$reset\]"
[ -n "$SSH_TTY" ] && PS1+="\[$blue\] at \[$bold\]\[$purple\]\h\[$reset\]"
PS1+="\[$blue\] in "
PS1+="\[$green\]\w"
PS1+="\n"
PS1+="\[$revs\]\[$white\]\[$bold\]\A \[$reset\]"
PS1+="\$(_prompt_low_energy -bg)"
PS1+="\$(_prompt_virtualenv)"
PS1+="\$(_prompt_git_status_detailed)"
PS1+=" \$(_prompt_uid_color)\$ \[$reset\]"
export PS1
PS2="\[$yellow\]→ \[$reset\]"
export PS2
# Enable powerline plugin (see github.com/powerline/powerline)
if [[ $POWERLINE_ENABLE -eq 1 && -e $POWERLINE_HOME/bash/powerline.sh ]] && powerline -h > /dev/null 2>&1; then
    powerline-daemon -q
    POWERLINE_BASH_CONTINUATION=1
    POWERLINE_BASH_SELECT=1
    source $POWERLINE_HOME/bash/powerline.sh
fi
# }}}1

# fzf search settings. {{{1
if [ -f $HOME/.fzf.bash ]; then
    . $HOME/.fzf.bash
    FZF_DEFAULT_OPTS='--no-height --no-reverse'
    FZF_CTRL_T_OPTS='--select-1 --exit-0'
    FZF_CTRL_T_OPTS+=' --preview "(highlight -O ansi -l {} 2> /dev/null || cat {} || ls --color=always -1 {}) 2> /dev/null | head -100"'
    FZF_CTRL_R_OPTS='--preview "echo {}" --preview-window down:3:hidden:wrap --bind "?:toggle-preview"'

    export FZF_DEFAULT_OPTS
    export FZF_CTRL_T_OPTS
    export FZF_CTRL_R_OPTS
fi
# }}}1

# vi: ft=sh fdm=marker ts=4 sw=4 et
