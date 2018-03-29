## Extend PATH enviroment variable.
# Software enviroment variables. {{{1
export VAGRANT_HOME="$HOME/vmdisk/.vagrant.d"
export COMPOSER_HOME="$HOME/.local/lib/composer"
export POWERLINE_HOME="$HOME/.local/lib/powerline-plugins"
# }}}1

# $PATH extension. {{{1
[ -d $HOME/bin ] && PATH="$HOME/bin:$PATH"
[ -d $HOME/.local/bin ] && PATH="$HOME/.local/bin:$PATH"
if [ -n "$COMPOSER_HOME" ] && [ -d "$COMPOSER_HOME/vendor/bin" ]; then
    PATH="$PATH:$COMPOSER_HOME/vendor/bin"
fi

export PATH
# }}}1

# vi: ft=sh fdm=marker fdl=99 ts=4 sw=4 et
