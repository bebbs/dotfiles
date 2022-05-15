#!/bin/bash

echo "Starting dotfiles install"

set -euo pipefail

# Symlink dotfiles to $HOME dir in codespaces
create_symlinks() {
    # Get the directory in which this script lives.
    script_dir=$(dirname "$(readlink -f "$0")")

    # Get a list of all files in this directory that start with a dot.
    files=$(find -maxdepth 1 -type f -name ".*")

    # Create a symbolic link to each file in the home directory.
    for file in $files; do
        name=$(basename $file)
        echo "Creating symlink to $name in home directory."
        rm -rf ~/$name
        ln -s $script_dir/$name ~/$name
    done
}

# Change default shell to zsh
switch_to_zsh() {
  echo "Changing default shell to zsh"
  sudo chsh -s "$(which zsh)" "$(whoami)"
  echo "Shell: ${SHELL}"
}

# Clone zsh plugins to oh-my-zsh dir
install_zsh_plugins() {
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
  git clone https://github.com/zsh-users/zsh-autosuggestions.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
}

if [ "$CODESPACES" = "true" ]; then
  create_symlinks
  switch_to_zsh
  install_zsh_plugins
fi
