# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# Terminal colors. {{{1
if tput setaf 1 &> /dev/null; then
    tput sgr0; # reset colors
    bold=$(tput bold);
    reset=$(tput sgr0);
    # Solarized colors, taken from http://git.io/solarized-colors.
    black=$(tput setaf 0);
    blue=$(tput setaf 33);
    cyan=$(tput setaf 37);
    green=$(tput setaf 64);
    orange=$(tput setaf 166);
    purple=$(tput setaf 125);
    red=$(tput setaf 124);
    violet=$(tput setaf 61);
    white=$(tput setaf 15);
    yellow=$(tput setaf 136);
else
    bold='';
    reset="\e[0m";
    black="\e[1;30m";
    blue="\e[1;34m";
    cyan="\e[1;36m";
    green="\e[1;32m";
    orange="\e[1;33m";
    purple="\e[1;35m";
    red="\e[1;31m";
    violet="\e[1;35m";
    white="\e[1;37m";
    yellow="\e[1;33m";
fi;
# }}}1

# Env variables for installed apps and tools. {{{1
export POWERLINE_ENABLE=0
export VAGRANT_HOME="$HOME/vmdisk/.vagrant.d"
export COMPOSER_HOME="$HOME/.local/lib/composer"
# }}}1

# Bash enviroment variables. {{{1
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
# Highlight section titles in manual pages.
export LESS_TERMCAP_md="${yellow}"
# ls color scheme.
export CLICOLOR=1
LS_COLORS='no=00:fi=00:di=01;31:ln=01;36:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arj=01;31:*.taz=01;31:*.lzh=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.gz=01;31:*.bz2=01;31:*.deb=47;04;31:*.rpm=01;31:*.jar=01;31:*.jpg=01;35:*.jpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.avi=01;35:*.fli=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.ogg=01;35:*.mp3=01;35:*.wav=01;35:'
LS_COLORS+='*.php=92:'
export LS_COLORS
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'
# }}}1

# $PATH extension. {{{1
# Add ~/bin to `$PATH`.
if [ -d "$HOME/bin" ]; then
    export PATH="$HOME/bin:$PATH"
fi
# Add ~/.local/bin to `$PATH`.
if [ -d "$HOME/.local/bin" ]; then
    export PATH="$HOME/.local/bin:$PATH"
fi
# Add composer global install path.
if [ -d "$COMPOSER_HOME/vendor/bin" ]; then
    export PATH="$PATH:$COMPOSER_HOME/vendor/bin"
fi
# }}}1

# User defined commands. {{{1
# Create and switch directory.
mkcd () {
   case "$1" in /*) :;; *) set -- "./$1";; esac
   mkdir -p "$1" && cd "$1"
}
# Travel up the tree
up() {
    local path=".."
    for ((i=2; i<=${1:-1}; i++)); do
        path=$path/..
    done
    cd $path
}
# System shutdown.
function medown () {
    local mode=-h
    local cmd="%sshutdown %s now" subcmd='sudo apt-get -q update;sudo apt-get -yq upgrade;'
    for ((i=1; i<=$#; i++)); do
        case ${!i} in
            -r|--reboot|-h|--halt) mode=${!i};;
            now) subcmd='';;
        esac
    done
    cmd=$(printf "$cmd" "$subcmd" $mode)
    eval "$cmd"
}
# Display sortend pwd
spwd () {
    begin=""
    homebegin=""
    shortbegin=""
    current=""
    end="${2:-$(pwd)}/" # The unmodified rest of the path.
    end="${end#/}" # Strip the first /
    shortenedpath="$end"
    shopt -q nullglob && NGV="-s" || NGV="-u"
    shopt -s nullglob

    while [[ "$end" ]]; do
        current="${end%%/*}" # Everything before the first /
        end="${end#*/}" # Everything after the first /
        shortcur="$current"
        for ((i=${#current}-2; i>=0; i--)); do
            [[ ${#current} -le 20 ]] && [[ -z "$end" ]] && break
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
}
# }}}1

# Terminal settings. {{{1
set -o vi
shopt -s histappend
shopt -s checkwinsize
shopt -s cdspell
# autocd: `~/**/mp` will result in `cd -- ~/dir/dir/mp`
shopt -s autocd
# globstar: ls `~/**/mydir*/*.py` will list all ".py" file in subdirectories which name starts with "mydir".
shopt -s globstar
# Case-insensitive globbing (used in pathname expansion).
shopt -s nocaseglob
# make less more friendly for non-text input files, see lesspipe(1).
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"
# set variable identifying the chroot you work in (used in the prompt below).
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi
# Enable bash-completion.
if ! shopt -oq posix ; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi
# Add tab completion for SSH hostnames based on ~/.ssh/config, ignoring wildcards (@todo: causes problem if ~/.ssh/config doesn't exists, fix later)
#[ -e "$HOME/.ssh/config" ] && complete -o "default" -o "nospace" -W "$(grep "^Host" ~/.ssh/config | grep -v "[?*]" | cut -d " " -f2- | tr ' ' '\n')" scp sftp ssh;
# }}}1

# Shell prompt customization. {{{1
if [[ $COLORTERM = gnome-* && $TERM = xterm ]] && infocmp gnome-256color >/dev/null 2>&1; then
    export TERM='gnome-256color';
elif infocmp xterm-256color >/dev/null 2>&1; then
    export TERM='xterm-256color';
fi;
# Display shortent pwd in title.
PROMPT_COMMAND='echo -en "\033]0; $("spwd") \a"'
# Form string with git status.
prompt_git() {
    local s='';
    local branchName='';
    # Check if the current directory is in a Git repository.
    if [ $(git rev-parse --is-inside-work-tree &>/dev/null; echo "${?}") == '0' ]; then
        # check if the current directory is in .git before running git checks.
        if [ "$(git rev-parse --is-inside-git-dir 2> /dev/null)" == 'false' ]; then
            # Ensure the index is up to date.
            git update-index --really-refresh -q &>/dev/null;
            # Check for uncommitted changes in the index.
            if ! $(git diff --quiet --ignore-submodules --cached); then
                s+='+';
            fi;
            # Check for unstaged changes.
            if ! $(git diff-files --quiet --ignore-submodules --); then
                s+='!';
            fi;
            # Check for untracked files.
            if [ -n "$(git ls-files --others --exclude-standard)" ]; then
                s+='?';
            fi;
            # Check for stashed files.
            if $(git rev-parse --verify refs/stash &>/dev/null); then
                s+='$';
            fi;
        fi;
        # Get the short symbolic ref.
        # If HEAD isn’t a symbolic ref, get the short SHA for the latest commit.
        branchName="$(git symbolic-ref --quiet --short HEAD 2> /dev/null || \
            git rev-parse --short HEAD 2> /dev/null || \
            echo '(unknown)')";
        [ -n "${s}" ] && s=" [${s}]";
        echo -e "${1}${branchName}${2}${s}";
    else
        return;
    fi;
}
# Highlight the user name when logged in as root.
if [[ "${USER}" == "root" ]]; then
    userStyle="${red}";
else
    userStyle="${orange}";
fi;
# Highlight the hostname when connected via SSH.
if [[ "${SSH_TTY}" ]]; then
    hostStyle="${bold}${red}";
else
    hostStyle="${yellow}";
fi;
# Set the terminal title and prompt.
PS1="\[\033]0;\W\007\]";   # working directory base name
PS1+="\[${bold}\]\n";      # newline
PS1+="\[${userStyle}\]\u"; # username
PS1+="\[${blue}\] at ";
PS1+="\[${hostStyle}\]\h"; # host
PS1+="\[${blue}\] in ";
PS1+="\[${green}\]\w";     # working directory full path
PS1+="\n"
PS1+="\[${bold}\]\[${green}\]\$(date +%H:%M)\[${reset}\]"
PS1+=" \$(prompt_git \"\[${black}\]\[${violet}\]\" \"\[${blue}\]\")"; # Git repository details
PS1+="  \[${blue}\]\$ \[${reset}\]"; # `$` (and reset color)
export PS1;
PS2="\[${yellow}\]→ \[${reset}\]";
export PS2;
# Enable powerline plugin (see github.com/powerline/powerline)
if [[ $POWERLINE_ENABLE -eq 1 && -e ~/.local/lib/powerline-plugins/ ]] && powerline -h > /dev/null 2>&1; then
    powerline-daemon -q
    POWERLINE_BASH_CONTINUATION=1
    POWERLINE_BASH_SELECT=1
    source ~/.local/lib/powerline-plugins/bash/powerline.sh
fi
# }}}1

# Alias definitions. {{{1
# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'
# Enable colored output.
if [ -x /usr/bin/dircolors ]; then
    alias ls='ls --color=auto'
    alias dir='dir --color=auto'
    alias vdir='vdir --color=auto'
    alias grep='grep --color=auto'
fi
# list of aliases for ls utilite.
alias ll='ls -AlF --human-readable --escape'
alias lw='ls -AlF --human-readable --escape --group-directories-first'
alias lc='ls -CF --escape --group-directories-first'
alias l1='ls -1F --escape --group-directories-first'
# Python
alias py2='python2'
alias py2c='python2 -m py_compile'
alias py3='python3'
alias py3c='python3 -m py_compile'
# Php
alias composer='composer --profile --verbose'
# X clipboard
if which xsel >/dev/null 2>&1 ; then
    alias pbcopy='xsel -i -b'
    alias pbpaste='xsel -o -b'
elif which xclip >/dev/null 2>&1 ; then
    alias pbcopy='xclip -selection -c'
    alias pbpaste='xclip -selection clipboard -o'
fi
# Less
alias less='less -iJFRX'
# Convert sequence of whitespaces to tab.
alias stot="sed -E 's/\s+/\t/g'"

alias meup='sudo apt-get -q update; sudo apt-get -q upgrade'
alias godown='cd ~/Downloads'
alias govid='cd ~/Videos'
# }}}1

# vi: fdm=marker ts=4 sw=4 et ft=sh
