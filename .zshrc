export ZSH="${HOME}/.oh-my-zsh"
export LANG="en_GB.UTF-8"
export LC_ALL="en_GB.UTF-8"

# Theme

ZSH_THEME="af-magic"

# Plugins

plugins=(
  git
  emoji
  zsh-syntax-highlighting
  zsh-autosuggestions
)

source $ZSH/oh-my-zsh.sh
source $HOME/.aliases