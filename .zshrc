export ZSH="${HOME}/.oh-my-zsh"
export LANG="en_GB.UTF-8"
export LC_ALL="en_GB.UTF-8"
export PATH="/opt/homebrew/bin:${PATH}"

# Theme

ZSH_THEME="dpoggi"

# Plugins

plugins=(
  git
  emoji
  zsh-syntax-highlighting
  zsh-autosuggestions
)

source $ZSH/oh-my-zsh.sh
source $HOME/.aliases