# shellcheck shell=bash
#
# Shared helpers for the scripts in bin/. Sourced, never executed.
# Kept compatible with bash 3.2 (the version macOS ships) so that bin/setup
# works on a machine where nothing has been installed yet.

DOTFILES_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
export DOTFILES_ROOT

PROFILE_FILE="$HOME/.dotfiles-profile"

if [ -t 1 ]; then
  C_RESET=$'\033[0m'
  C_BOLD=$'\033[1m'
  C_DIM=$'\033[2m'
  C_RED=$'\033[31m'
  C_GREEN=$'\033[32m'
  C_YELLOW=$'\033[33m'
  C_BLUE=$'\033[34m'
else
  C_RESET='' C_BOLD='' C_DIM='' C_RED='' C_GREEN='' C_YELLOW='' C_BLUE=''
fi

heading() { printf '\n%s==>%s %s%s%s\n' "$C_BLUE" "$C_RESET" "$C_BOLD" "$*" "$C_RESET"; }
info()    { printf '    %s\n' "$*"; }
success() { printf '  %s✓%s %s\n' "$C_GREEN" "$C_RESET" "$*"; }
skip()    { printf '  %s·%s %s%s%s\n' "$C_DIM" "$C_RESET" "$C_DIM" "$*" "$C_RESET"; }
warn()    { printf '  %s!%s %s\n' "$C_YELLOW" "$C_RESET" "$*" >&2; }
die()     { printf '  %s✗%s %s\n' "$C_RED" "$C_RESET" "$*" >&2; exit 1; }

have() { command -v "$1" >/dev/null 2>&1; }

# A python gcloud will accept: new enough, and with a working pyexpat. Homebrew's
# bottles can satisfy the first and fail the second, which surfaces much later as
# an unrelated-looking crash, so both are checked together.
python_usable() {
  [ -n "${1:-}" ] && [ -x "$1" ] || return 1
  "$1" - <<'PY' >/dev/null 2>&1
import sys, pyexpat, xml.etree.ElementTree
sys.exit(0 if sys.version_info >= (3, 12) else 1)
PY
}

# confirm "Question?" [default]   default is "y" or "n" (default "n")
confirm() {
  local prompt="$1" default="${2:-n}" reply hint
  if [ "$default" = "y" ]; then hint="[Y/n]"; else hint="[y/N]"; fi
  printf '    %s %s ' "$prompt" "$hint" >&2
  read -r reply || reply=""
  [ -z "$reply" ] && reply="$default"
  case "$reply" in [yY]*) return 0 ;; *) return 1 ;; esac
}

# Which machine is this? "work" (carwow) or "personal". Cached in
# ~/.dotfiles-profile so every script agrees, overridable with $DOTFILES_PROFILE.
dotfiles_profile() {
  if [ -n "${DOTFILES_PROFILE:-}" ]; then
    printf '%s\n' "$DOTFILES_PROFILE"
  elif [ -f "$PROFILE_FILE" ]; then
    tr -d '[:space:]' < "$PROFILE_FILE"
    printf '\n'
  fi
}

# Ask for the profile once and remember it. Prints the profile on stdout.
ensure_profile() {
  local current
  current="$(dotfiles_profile)"
  if [ -n "$current" ]; then
    printf '%s\n' "$current"
    return 0
  fi

  printf '    Is this a carwow work machine? [Y/n] ' >&2
  local reply
  read -r reply || reply=""
  case "${reply:-y}" in
    [nN]*) current="personal" ;;
    *)     current="work" ;;
  esac

  printf '%s\n' "$current" > "$PROFILE_FILE"
  printf '%s\n' "$current"
}

is_work_machine() { [ "$(dotfiles_profile)" = "work" ]; }

# Stow packages that apply to this machine.
dotfiles_packages() {
  printf 'zsh\ngit\nghostty\n'
  if is_work_machine; then printf 'carwow\n'; fi
}
