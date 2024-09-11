export PATH=$PATH:$HOME/.local/bin/
export SDL_VIDEODRIVER=wayland

export BROWSER=firefox
export EDITOR=nvim

export GOPATH=$HOME/.go

# clean up home
export XDG_DATA_HOME=$HOME/.local/share
export XDG_CONFIG_HOME=$HOME/.config
export XDG_STATE_HOME=$HOME/.local/state
export XDG_CACHE_HOME=$HOME/.cache

export CARGO_HOME="$XDG_DATA_HOME"/cargo
export CUDA_CACHE_PATH="$XDG_CACHE_HOME"/nv
export IPYTHONDIR="$XDG_CONFIG_HOME/ipython"
export JULIA_DEPOT_PATH="$XDG_DATA_HOME/julia:$JULIA_DEPOT_PATH"
# export ZDOTDIR="$HOME"/.config/zsh
