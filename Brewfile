# Core packages — installed on every machine by bin/homebrew.
# carwow-specific tooling lives in Brewfile.work.

# --- Shell and CLI essentials ---
brew "git"              # newer than the system git
brew "gh"               # github cli, also acts as git's credential helper
brew "stow"             # dotfiles symlink manager
brew "zoxide"           # smarter cd
brew "fzf"              # fuzzy finder
brew "jq"               # json processor
brew "yazi"             # terminal file manager
brew "shellcheck"       # lints the scripts in bin/

# --- GNU userland (referenced by PATH setup in zsh/.zshrc) ---
brew "coreutils"
brew "findutils"
brew "gnu-sed"

# --- Languages and build tools ---
brew "rbenv"            # ruby version manager
brew "cmake"
brew "rust"

# --- Databases ---
brew "postgresql@14"
brew "libpq"            # psql/pg_dump client libs, added to PATH in .zshrc

# --- Applications ---
cask "ghostty"          # terminal
cask "jumpcut"          # clipboard history

# --- Fonts ---
cask "font-symbols-only-nerd-font"
