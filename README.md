# dotfiles

macOS setup, from scratch to working, in one command.

```bash
git clone https://github.com/bebbs/dotfiles.git ~/dev/bebbs/dotfiles
cd ~/dev/bebbs/dotfiles
bin/setup
```

`bin/setup` asks once whether this is a carwow machine, then runs four
idempotent steps. Re-run it any time; re-run a single step with
`bin/setup <step>`.

| Step | What it does |
| --- | --- |
| `bin/homebrew` | Xcode command line tools, Homebrew, everything in the Brewfiles |
| `bin/zsh` | oh-my-zsh and its plugins, sets zsh as the login shell |
| `bin/secrets` | interactive wizard for API tokens |
| `bin/link` | symlinks the config into `$HOME` with stow |

## Layout

```
bin/                scripts — the only place scripts live
  lib/common.sh     shared output helpers, profile detection
Brewfile            packages for every machine
Brewfile.work       carwow-only packages
secrets.manifest    which secrets exist and where to get them
git/                → ~/.gitconfig, ~/.gitignore_global
zsh/                → ~/.zshrc, ~/.aliases, ~/.secrets
carwow/             → ~/.zshrc.work, ~/.aliases.work   (work machines only)
```

Each top-level directory other than `bin/` is a stow package. `bin/link` names
the packages explicitly rather than globbing `*/`, so `bin/` is never symlinked
into `$HOME`.

## Work vs personal

The answer to "is this a carwow machine?" is cached in `~/.dotfiles-profile`.
On a work machine the `carwow` stow package and `Brewfile.work` are applied; on
a personal machine they are skipped entirely, so carwow aliases, telemetry
config and tokens simply do not exist there.

To change your mind: `rm ~/.dotfiles-profile && bin/setup`.

## Secrets

No secret is ever committed. `zsh/.secrets` is gitignored and generated.

```bash
bin/secrets            # fill in anything missing
bin/secrets --check    # what is set, what is not
bin/secrets --all      # rotate everything
bin/secrets GITHUB_TOKEN
```

The wizard prints where to get each token and what scopes it needs, takes the
value without echoing it, checks it against an expected format, and writes
`zsh/.secrets` at mode 600. That file is symlinked to `~/.secrets` and sourced
by `.zshrc`.

**The list of secrets lives in `secrets.manifest`, not in the script.** To add
one, append a record:

```
name: SOME_TOKEN
scope: carwow            # or: core
label: What it is, in one line
url: https://where.to/get/it
pattern: ^[a-f0-9]{32}$  # optional; a mismatch warns, it does not block
help: First instruction.
help: Second instruction.
---
```

Then reference `$SOME_TOKEN` from `zsh/.zshrc` or `carwow/.zshrc.work`. Nothing
else needs changing.

Secrets are stored as plaintext in a mode-600 file, which is the tradeoff for a
fast shell startup and zero dependencies. If that stops being acceptable, the
place to change it is `write_secrets`/`value_of` in `bin/secrets` — the rest of
the wizard is storage-agnostic.

## Other useful commands

```bash
bin/link --dry-run     # show what would be symlinked
bin/link --unlink      # remove the symlinks
brew bundle cleanup --file=Brewfile   # list installed packages not in the Brewfile
```
