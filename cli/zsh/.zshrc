# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  # source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Set the directory we want to store zinit and plugins
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

# Download Zinit, if it's not there yet
if [ ! -d "$ZINIT_HOME" ]; then
  mkdir -p "$(dirname $ZINIT_HOME)"
  git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

# Source/Load zinit
source "${ZINIT_HOME}/zinit.zsh"

# Add better Vim
zinit ice depth=1; zinit light jeffreytse/zsh-vi-mode
function zvm_after_init() {
  source <(fzf --zsh)
  source ~/.zsh_bindkeys
}

# # Add in zsh plugins
zinit light zsh-users/zsh-history-substring-search
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab
zinit light b4b4r07/enhancd
zinit light MichaelAquilina/zsh-auto-notify

# Add in snippets
zinit snippet OMZP::git
zinit snippet OMZP::sudo
zinit snippet OMZP::archlinux
zinit snippet OMZP::command-not-found
zinit snippet OMZP::colored-man-pages
zinit snippet OMZP::fancy-ctrl-z
zinit snippet OMZP::extract

# Load completions
autoload -Uz compinit && compinit

zinit cdreplay -q

# clean home
export XDG_CONFIG_HOME="$HOME/.local/state"
alias wget=wget --hsts-file="$XDG_DATA_HOME/wget-hsts"
compinit -d "$XDG_CACHE_HOME"/zsh/zcompdump-"$ZSH_VERSION"
mkdir -p $XDG_CONFIG_HOME/zsh

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# History
HISTSIZE=5000
export HISTFILE="$XDG_STATE_HOME"/zsh/history
# HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups


# Completion styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':completion:*:descriptions' format '[%d]'
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'

# Run rehash on completion so new installed program are found automatically
_force_rehash() {
  (( CURRENT == 1 )) && rehash
  return 1  # Because we didn't really complete anything
}

# Aliases
alias DDNet='mangohud gamemoderun \DDNet'
# alias DDTet='mangohud gamemoderun \DDTet' # shit lags for hf

alias fetch="fastfetch -c 'examples/8'"

alias cleanup="sudo pacman -Rsn $(pacman -Qtdq)"

alias cat='bat --theme base16'

alias ls='exa --icons --group-directories-first'
alias la='ls -a'
alias ll='ls -l'
alias lla='la -l'

alias hx="helix"
alias vim='nvim'
alias v='vim'

alias ..='\cd ..'
alias ...='\cd ../..'
alias ....='\cd ../../..'
alias .....='\cd ../../../..'

alias mkdir='mkdir -vp'
alias cp='cp -vR'

alias jl='julia'
alias jp='julia --project'
alias lg='lazygit'

function f() {
  local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
  yazi "$@" --cwd-file="$tmp"
  if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
    cd -- "$cwd"
  fi
  rm -f -- "$tmp"
}

# FZF
export FZF_DEFAULT_OPTS=" \
  --color=bg+:-1,bg:-1,spinner:2,hl:2 \
  --color=fg:-1,header:7,info:6,pointer:2 \
  --color=marker:2,fg+:7,prompt:2,hl+:3"

export FZF_DEFAULT_OPTS=$FZF_DEFAULT_OPTS'
--border="none" --border-label="" --preview-window="border-rounded"
--padding="0" --margin="0" --prompt=" " --marker="┃" --pointer=""
--separator="─" --scrollbar="│" --layout="reverse"'

export FZF_DEFAULT_COMMAND='rg --files --no-ignore --hidden --follow -g "!{.git,node_modules}" 2> /dev/null'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

# Shell integrations
source <(starship init zsh)

# Environment Variables
source $HOME/.profile
