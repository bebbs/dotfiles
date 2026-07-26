# dotfiles

macOS setup, from scratch to working, in one command.

```bash
git clone https://github.com/bebbs/dotfiles.git ~/dev/bebbs/dotfiles
cd ~/dev/bebbs/dotfiles
bin/setup
```

`bin/setup` asks once whether this is a carwow machine, then runs six
idempotent steps. Re-run it any time; re-run a single step with
`bin/setup <step>`.

| Step | What it does |
| --- | --- |
| `bin/homebrew` | Xcode command line tools, Homebrew, everything in the Brewfiles |
| `bin/mise` | language runtimes and pinned CLIs (node, ruby, go, bun, gh, …) |
| `bin/gcloud` | Google Cloud CLI, from Google's tarball (work machines only) |
| `bin/zsh` | oh-my-zsh and its plugins, sets zsh as the login shell |
| `bin/secrets` | interactive wizard for API tokens |
| `bin/link` | symlinks the config into `$HOME` with stow |

Anything Homebrew cannot install cleanly gets its own step rather than being
left as a manual instruction — `bin/gcloud` is the pattern to copy.

## Layout

```
bin/                scripts — the only place scripts live
  lib/common.sh     shared output helpers, profile detection
Brewfile            packages for every machine
Brewfile.work       carwow-only packages
secrets.manifest    which secrets exist and where to get them
git/                → ~/.gitconfig, ~/.gitignore_global
zsh/                → ~/.zshrc, ~/.aliases, ~/.secrets
ghostty/            → ~/.config/ghostty/config
mise/               → ~/.config/mise/config.toml
carwow/             → ~/.zshrc.work, ~/.aliases.work,
                      ~/.config/mise/conf.d/work.toml   (work machines only)
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

## Runtimes

`mise` owns every language runtime on the machine — node, ruby, go and bun —
plus the CLIs worth pinning a version of.

Versions are declared in `mise/.config/mise/config.toml`, pinned to a major so
patches arrive on their own and a major bump is a deliberate commit. carwow-only
tools (`awscli`, `circleci`, `yarn`, `heroku`) sit in
`carwow/.config/mise/conf.d/work.toml`, which mise merges over the core config —
and which only exists on a work machine.

```bash
bin/mise               # install everything the config declares
bin/mise --prune       # remove the managers mise replaced (asks before each)
mise ls                # what is installed
mise ls --missing      # declared but not installed
```

`.ruby-version`, `.nvmrc` and `.node-version` are honoured, so a project resolves
without needing a `mise.toml` of its own. If it pins a version that is not
installed, mise warns and `mise install` in that directory fixes it.

**The carwow apps are unaffected.** `quotes_site`, `dealers_site`, `flatmin`,
`deals_service` and friends run a containerised Ruby through `carwow run` and
pin no version files, so there is nothing for mise to attach to.

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

## Checking a machine

`bin/verify` answers "is this machine set up the way the repo says it should be?"
It changes nothing, runs every check even after one fails, and exits non-zero if
any did — so it is safe to hand to an agent or a CI job.

```bash
bin/verify
```

It covers the profile, every package's symlinks, both Brewfiles, the mise
runtimes (declared vs installed, and whether a replaced manager is still lying
around), the secrets file (permissions, git status, completeness), interactive
shell health, the commands the config expects on PATH, the gcloud SDK and its
pinned interpreter, and Ghostty. Failures come with the command that fixes them.

## Other useful commands

```bash
bin/link --dry-run     # show what would be symlinked
bin/link --unlink      # remove the symlinks
bin/secrets --check    # which secrets are set
bin/mise --prune       # remove a superseded runtime manager
bin/homebrew --cleanup # list installed packages no Brewfile declares
```

Use `bin/homebrew --cleanup` rather than `brew bundle cleanup --file=Brewfile`.
`brew bundle` reads one Brewfile at a time, so on a work machine the raw command
sees nothing in `Brewfile.work` and offers to uninstall all of it — OrbStack
included. `bin/homebrew --cleanup` passes both files for the current profile.
