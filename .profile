## Extend PATH enviroment variable.
# Software enviroment variables. {{{
export VAGRANT_HOME="$HOME/vmdisk/.vagrant.d"
export ANDROID_SDK_ROOT="$HOME/vmdisk/android/sdk"
export ANDROID_AVD_HOME="$HOME/vmdisk/android/avd"
export SDKMAN_DIR="$HOME/Soft/sdkman"
export WORKON_HOME="$HOME/Soft/virtualenvs"
export POETRY_HOME="$HOME/Soft/poetry"
export PYENV_ROOT="$HOME/Soft/pyenv"
# }}}

# $PATH extension. {{{
[ -d $HOME/bin ] && PATH="$HOME/bin:$PATH"
[ -d $HOME/.local/bin ] && PATH="$HOME/.local/bin:$PATH"
if [ -n "$POETRY_HOME" -a -x "$POETRY_HOME/bin/poetry" ]; then
    PATH="$PATH:$POETRY_HOME/bin"
fi

export PATH
# }}}

# vi: ft=sh fdm=marker fdl=99 ts=4 sw=4 et
