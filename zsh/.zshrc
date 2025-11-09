export ZSH="$HOME/.oh-my-zsh"
export LANG="en_GB.UTF-8"
export LC_ALL="en_GB.UTF-8"

# --- PATH SETUP  ---

# personal bins
export PATH="$HOME/.local/bin:$HOME/bin:$PATH"

# homebrew
export PATH="/opt/homebrew/bin:$PATH"
export PATH="/opt/homebrew/opt/libpq/bin:$PATH"

# dev tools
export PATH="$HOME/dev/bin:$PATH"
export PATH="$HOME/dev/dev-environment/bin:$PATH"

# gnu utils
brew_prefix="$(brew --prefix)"
export PATH="$brew_prefix/opt/coreutils/libexec/gnubin:$PATH"
export PATH="$brew_prefix/opt/findutils/libexec/gnubin:$PATH"
export PATH="$brew_prefix/opt/gnu-sed/libexec/gnubin:$PATH"

# rbenv
eval "$(rbenv init - zsh)"

# --- Oh-My-Zsh ---
ZSH_THEME="af-magic"

plugins=(
  git
  emoji
  zsh-syntax-highlighting
  zsh-autosuggestions
)

source "$ZSH/oh-my-zsh.sh"
source "$HOME/.aliases"
source "$HOME/.secrets"

# --- Keybindings ---
bindkey "^[[1;3C" forward-word
bindkey "^[[1;3D" backward-word

# --- History settings ---
HISTFILE="$HOME/.zsh_history"
HISTSIZE=5000
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory sharehistory
setopt hist_ignore_space hist_ignore_all_dups hist_save_no_dups hist_ignore_dups hist_find_no_dups

unsetopt nomatch

# --- nvm ---
export NVM_DIR="$HOME/.nvm"
[[ -s "$NVM_DIR/nvm.sh" ]] && . "$NVM_DIR/nvm.sh"
[[ -s "$NVM_DIR/bash_completion" ]] && . "$NVM_DIR/bash_completion"

# --- Misc tools ---
eval "$(zoxide init zsh)"
. "$HOME/.local/bin/env"