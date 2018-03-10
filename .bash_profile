# Load bash dotfiles.
for file in ~/.{bashrc,bash_alias,bash_command}; do
    [ -f "$file" ] && [ -r "$file" ] && source "$file";
done;
unset file

export LC_LANG='en_US.UTF-8'
export LC_CTYPE='en_US.UTF-8'
export LC_COLLATE="en_US.UTF-8"
