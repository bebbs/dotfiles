#!/bin/bash

echo "Starting dotfiles install"

set -eo pipefail

# Symlink dotfiles to $HOME dir in codespaces
create_symlinks() {
    # Get the directory in which this script lives.
    script_dir=$(dirname "$(readlink -f "$0")")

    # Get a list of all files in this directory that start with a dot.
    files=$(find $script_dir -maxdepth 1 -type f -name ".*")

    # Create a symbolic link to each file in the home directory.
    for file in $files; do
        name=$(basename $file)
        echo "Creating symlink to $name in home directory."
        rm -rf ~/$name
        ln -s $script_dir/$name ~/$name
    done
}

# Attempt to install oh-my-zsh, if it is not already configured
install_ohmyzsh() {
  if [[ -d ~/.oh-my-zsh ]]; then
    echo "ohmyzsh is already installed."
  else
    echo "Installing ohmyzsh"
    sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
  fi
}

# Change default shell to zsh
switch_to_zsh() {
  echo "Changing default shell to zsh"
  sudo chsh -s "$(which zsh)" "$(whoami)"
  echo "Shell: ${SHELL}"
}

# Clone zsh plugins to oh-my-zsh dir
install_zsh_plugin() {
  echo "Installing $1"
  repo_name=https://github.com/zsh-users/${1}.git
  destination=${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/${1}

  git clone $repo_name $destination
}

install_zsh_plugins() {
  echo "Installing zsh plugins"
  install_zsh_plugin "zsh-syntax-highlighting"
  install_zsh_plugin "zsh-autosuggestions"
}

# Run steps
create_symlinks
install_ohmyzsh
switch_to_zsh
install_zsh_plugins
