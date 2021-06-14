## Extend PATH enviroment variable.
# Software enviroment variables.
export ANDROID_SDK_ROOT="$HOME/vmdisk/android/sdk"
export ANDROID_AVD_HOME="$HOME/vmdisk/android/avd"
export SDKMAN_DIR="$HOME/Soft/sdkman"
# Virtualenv
export PYENV_ROOT="$HOME/Soft/pyenv"
export WORKON_HOME="$HOME/Soft/virtualenvs"
# Executables
export NODE_HOME="$HOME/.local/share/node"
export POETRY_HOME="$HOME/Soft/poetry"

# Include localy installed software
[[ -d $HOME/bin && ! $PATH =~ $HOME/bin: ]] && PATH="$HOME/bin:$PATH"
[[ -d $HOME/.local/bin && ! $PATH =~ $HOME/.local/bin: ]] && PATH="$HOME/.local/bin:$PATH"
# Node global bin
[[ -n $NODE_HOME && -d $NODE_HOME/bin && ! $PATH =~ $NODE_HOME/bin: ]] && PATH="$NODE_HOME/bin:$PATH"
# Python global bin
[[ -n $POETRY_HOME && -d $POETRY_HOME/bin && ! $PATH =~ $POETRY_HOME/bin: ]] && PATH="$POETRY_HOME/bin:$PATH"

export PATH

# vi: ft=sh ts=4 sw=4 et
