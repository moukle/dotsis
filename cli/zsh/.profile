export PATH=$PATH:$HOME/.local/bin/            # user scripts
export PATH=$PATH:/opt/cuda/nsight_systems/bin # cuda

export SDL_VIDEODRIVER=wayland

# default programs
export BROWSER=firefox
export EDITOR=nvim


# clean up home
export XDG_DATA_HOME=$HOME/.local/share
export XDG_CONFIG_HOME=$HOME/.config
export XDG_STATE_HOME=$HOME/.local/state
export XDG_CACHE_HOME=$HOME/.cache

export GOPATH=$HOME/.go

export CARGO_HOME="$XDG_DATA_HOME"/cargo
export CUDA_CACHE_PATH="$XDG_CACHE_HOME"/nv
export IPYTHONDIR="$XDG_CONFIG_HOME/ipython"
export JULIA_DEPOT_PATH="$XDG_DATA_HOME/julia:$JULIA_DEPOT_PATH"
# export ZDOTDIR="$HOME"/.config/zsh
