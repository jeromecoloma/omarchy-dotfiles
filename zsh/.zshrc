########## PATH ##########
typeset -U PATH path   # dedupe while preserving order
path=(
  "$HOME/.local/bin"
  "$HOME/.cargo/bin"
  "$HOME/.config/composer/vendor/bin"
  "$HOME/bin"
  vendor/bin
  /usr/bin
  $path
)
export PATH

########## Locale / History / Editor ##########
export LC_CTYPE=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export HISTTIMEFORMAT='%F %T '
export EDITOR='nvim'

########## Oh My Posh ##########
eval "$(oh-my-posh init zsh --config ~/.config/omp/star.omp.json)"

########## Completions ##########
typeset -U fpath
fpath=("$HOME/.zsh/completions" $fpath)
autoload -Uz compinit
compinit

########## Plugins (direct source) ##########
[ -f /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh ] && \
  source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
[ -f /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ] && \
  source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

########## FZF ##########
eval "$(fzf --zsh)" 2>/dev/null || {
  [ -f /usr/share/fzf/completion.zsh ] && source /usr/share/fzf/completion.zsh
  [ -f /usr/share/fzf/key-bindings.zsh ] && source /usr/share/fzf/key-bindings.zsh
}

########## Clipboard functions (replacing OMZ copypath/copyfile/copybuffer) ##########
# Base clipboard functions with Wayland/X11/tmux support
clipcopy() {
  if [[ -n "$WAYLAND_DISPLAY" ]] && command -v wl-copy &>/dev/null; then
    wl-copy
  elif [[ -n "$DISPLAY" ]] && command -v xclip &>/dev/null; then
    xclip -selection clipboard
  elif [[ -n "$TMUX" ]]; then
    tmux load-buffer -
  else
    return 1
  fi
}

clippaste() {
  if [[ -n "$WAYLAND_DISPLAY" ]] && command -v wl-paste &>/dev/null; then
    wl-paste
  elif [[ -n "$DISPLAY" ]] && command -v xclip &>/dev/null; then
    xclip -selection clipboard -o
  elif [[ -n "$TMUX" ]]; then
    tmux save-buffer -
  else
    return 1
  fi
}

# Copy file/directory path to clipboard
copypath() {
  local file="${1:-.}"
  [[ -e "$file" ]] || { echo "copypath: no such file: $file" >&2; return 1; }
  local abspath="$(cd "$(dirname "$file")" && pwd)/$(basename "$file")"
  echo -n "$abspath" | clipcopy && echo "Copied: $abspath"
}

# Copy file contents to clipboard
copyfile() {
  [[ -f "$1" ]] || { echo "copyfile: no such file: $1" >&2; return 1; }
  cat "$1" | clipcopy && echo "Copied contents of $1"
}

# Copy current command line to clipboard (bound to Ctrl+O)
copybuffer() {
  echo -n "$BUFFER" | clipcopy && zle -M "Copied: $BUFFER"
}
zle -N copybuffer
bindkey '^O' copybuffer

########## Shell options (nice defaults) ##########
setopt autocd
setopt auto_pushd pushd_ignore_dups pushd_silent
setopt complete_aliases

########## Keys / plugin settings ##########
# zsh-autosuggestions: "ghost text" accept
bindkey '^p' autosuggest-accept

########## NVM + auto .nvmrc ##########
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ]          && . "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && . "$NVM_DIR/bash_completion"

# Auto-switch node version when entering directory with .nvmrc (only if nvm installed)
if command -v nvm &>/dev/null; then
  autoload -U add-zsh-hook
  load-nvmrc() {
    local nvmrc_path nvmrc_node_version
    nvmrc_path="$(nvm_find_nvmrc)"
    if [ -n "$nvmrc_path" ]; then
      nvmrc_node_version=$(nvm version "$(cat "${nvmrc_path}")")
      if [ "$nvmrc_node_version" = "N/A" ]; then
        nvm install
      elif [ "$nvmrc_node_version" != "$(nvm version)" ]; then
        nvm use
      fi
    elif [ -n "$(PWD=$OLDPWD nvm_find_nvmrc)" ] && [ "$(nvm version)" != "$(nvm version default)" ]; then
      echo "Reverting to nvm default version"
      nvm use default
    fi
  }
  add-zsh-hook chpwd load-nvmrc
  load-nvmrc
fi

########## Extra completions ##########
# Laravel Artisan (if it uses compdef)
[ -f "$HOME/bin/completion.d/artisan" ] && . "$HOME/bin/completion.d/artisan"
# tmux sessions helper
[ -f "$HOME/bin/completion.d/__tmux_list_sessions" ] && . "$HOME/bin/completion.d/__tmux_list_sessions"


########## Aliases ##########
# eza aliases for colored directory listings with icons
alias ls='eza -lh --group-directories-first --icons=auto'
alias la='ls -a'
alias lt='eza --tree --level=2 --long --icons --git'
alias lta='lt -a'
alias tma='tmux attach -t $1'
alias tmk='tmux kill-session -t $1'
alias tml='tmux ls'
alias newbranch='git checkout -b'
alias gs="git status"
alias gc="git commit -m"
alias gco="git checkout"

########## yazi helper (cd back to chosen dir) ##########
y() {
  local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
  yazi "$@" --cwd-file="$tmp"
  if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
    builtin cd -- "$cwd"
  fi
  rm -f -- "$tmp"
}

########## Vi mode ##########
# Use vi keybindings at the prompt
bindkey -v

# Faster ESC-to-normal (adjust if Alt/Meta feels flaky)
export KEYTIMEOUT=1

# Keep autosuggest accept on ^p in INSERT mode
bindkey -M viins '^p' autosuggest-accept
bindkey -M viins '^e' autosuggest-accept
bindkey -M emacs '^e' autosuggest-accept

# Handy NORMAL-mode bindings (optional)
bindkey -M vicmd 'H' beginning-of-line
bindkey -M vicmd 'L' end-of-line
bindkey -M vicmd 'k' up-line-or-search
bindkey -M vicmd 'j' down-line-or-search

# Change cursor shape by mode (works in WezTerm/Kitty)
function zle-keymap-select() {
  case $KEYMAP in
    vicmd)      printf '\e[1 q' ;;  # block
    viins|main) printf '\e[5 q' ;;  # blinking bar
  esac
  zle reset-prompt
}
zle -N zle-keymap-select
# Set initial cursor to INSERT style
print -n '\e[5 q'

# Better bracketed paste (built-in widget)
autoload -Uz bracketed-paste-magic
zle -N bracketed-paste bracketed-paste-magic

# --- Secrets (not in Git) ---
# Put exports in ~/.zshrc.secrets and keep it chmod 600 + gitignored
[[ -f "$HOME/.zshrc.secrets" ]] && source "$HOME/.zshrc.secrets"

# Langflow uv environment
[ -f "$HOME/.langflow/uv/env" ] && . "$HOME/.langflow/uv/env"

: # ensure zero exit status
