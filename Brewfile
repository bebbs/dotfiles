# Core packages — installed on every machine by bin/homebrew.
# carwow-specific tooling lives in Brewfile.work.

# --- Shell and CLI essentials ---
brew "git"              # newer than the system git
brew "stow"             # dotfiles symlink manager
brew "zoxide"           # smarter cd
brew "fzf"              # fuzzy finder
brew "yazi"             # terminal file manager

# Must stay on brew: bin/gcloud sources a python from it and runs before the
# mise config is linked, so it cannot live in mise without a cycle.
brew "uv"               # python installer; bin/gcloud sources an interpreter from it

# --- GNU userland (referenced by PATH setup in zsh/.zshrc) ---
brew "coreutils"
brew "findutils"
brew "gnu-sed"

# --- Runtimes ---
# mise owns node, ruby, go, bun and the pinned CLIs (gh, jq, shellcheck).
# The versions live in mise/.config/mise/config.toml; bin/mise installs them.
brew "mise"

# mise builds ruby from source with ruby-build. openssl@3, libyaml and gmp end
# up linked into the resulting binary, so removing one breaks the installed ruby
# and not just the next build. No other entry here requires them by name.
brew "openssl@3"
brew "libyaml"
brew "gmp"
brew "readline"         # unlinked on ruby 3.4, but its absence silently costs irb features

# --- Build tools ---
brew "cmake"

# --- Database clients ---
brew "libpq"            # psql/pg_dump, added to PATH in .zshrc; no local server

# --- Applications ---
cask "ghostty"          # terminal
cask "jumpcut"          # clipboard history

# --- Fonts ---
cask "font-symbols-only-nerd-font"
