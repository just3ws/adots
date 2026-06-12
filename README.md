# adots
The alpha layer for home directory configurations.

adots is a bare Git repository at `~/.homegit` with `$HOME` as its work tree.
Use the `homegit` alias instead of plain `git` when working with it:

```bash
alias homegit='/usr/bin/git --git-dir=$HOME/.homegit/ --work-tree=$HOME'
```

This keeps Git metadata out of the home directory while letting tracked files
live at their normal paths and actively service the system.

## Architecture: The Modular Ecosystem

Two kinds of repos:

**Platforms** — complex, tested, independently deployable:
- **zdots** (`~/.config/zsh`): The shell platform. OTel observability, AI stack, local services, tests. Drives the full bootstrap — start here on a new machine.
- **vdots** (`~/.config/nvim`): Neovim config, LSP setup, plugin manager. Its own velocity.

**Dotfiles** — config files tracked as a unit by this repo (adots):
- **adots** (`~`): Root-level configs (`.zshenv`, `.gitconfig`, `.ackrc`, `.tmux.conf`, etc.) and `~/.config/` entries (git config, bat, btop, lazygit, gh-dash). The dotfiles monorepo.
- tdots is folded into adots: tool-specific XDG config lives here unless another repo owns it.
- **my** (`~/my`): The "Cerebral Control Plane." Local-only — no remote by design.

## Bootstrap

**Cold start on a new machine:**

```bash
git clone https://github.com/just3ws/zdots.git ~/.config/zsh
~/.config/zsh/bin/bootstrap
```

zdots bootstrap handles everything: Homebrew, this repo (adots), vdots, Ruby, the AI stack, local services, and database init. adots is cloned and restored automatically as part of that process.

adots treats zdots as a closed system. It may check that zdots exists and report
missing pieces, but it does not install Homebrew packages, mutate zdots files, or
replace zdots bootstrap logic.

adots also curates XDG layout. If a tool can live under `~/.config`, that path is
the canonical home. Legacy roots are only acceptable as compatibility aliases
while the doctor migrates state back to the canonical XDG location.
Colima is the concrete example: `~/.config/colima` is the canonical root and
`~/.colima` should be moved out of the way. If the tree cannot be made
unambiguous, `adots-doctor` fails rather than guessing.

Shell entrypoints are zdots-owned symlinks when zdots is present:

- `~/.bash_profile -> ~/.config/zsh/bash_profile`
- `~/.bashrc -> ~/.config/zsh/bashrc`
- `~/.zshenv -> ~/.config/zsh/.zshenv`

**Work machine restore:**

```bash
git clone --bare https://github.com/just3ws/adots.git ~/.homegit
git --git-dir=$HOME/.homegit --work-tree=$HOME restore --source=HEAD -- README.md bootstrap.sh bin/adots-doctor .gitconfig .config/git/config .zshenv .bashrc .bash_profile .profile
~/bin/adots-doctor
```

Review the doctor output before restoring the full tracked set. On managed
machines, inspect `.gitconfig`, shell entrypoints, and tool configs before
overwriting employer-managed files.

## Daily Workflow

Treat `homegit` like a normal Git repo command:

```bash
homegit status
homegit diff
homegit add .psqlrc .config/git/config
homegit commit -m "Update home config"
homegit push
```

Pull GitHub changes onto this machine:

```bash
homegit pull --rebase
```

Restore one tracked file from `HEAD`:

```bash
homegit restore .psqlrc
```

List everything adots tracks:

```bash
homegit ls-files
```

Show untracked files when auditing new candidates:

```bash
homegit status --untracked-files=all
```

The repo is configured with `status.showUntrackedFiles=no`, so normal status
does not flood the terminal with the entire home directory. Add new files
explicitly when they belong in the home blanket.

## Tracked Files

Root-level home files:

```text
.ackrc
.bash_profile
.bashrc
.curlrc
.editorconfig
.gemrc
.gitconfig
.gitignore_global
.hushlogin
.ideavimrc
.inputrc
.mise.toml
.profile
.psqlrc
.ripgreprc
.tmux.conf
.yarnrc
.zshenv
README.md
bootstrap.sh
bin/adots-doctor
```

Tracked `~/.config` files:

```text
.config/atuin/config.toml
.config/bat/config
.config/btop/btop.conf
.config/fd/ignore
.config/gh-dash/config.yml
.config/git/config
.config/lazygit/config.yml
.config/mise/config.toml
```

## File Notes

- `.psqlrc` comments must use SQL-style `--` comments. Shell-style `#`
  comments caused psql syntax errors.
- `.config/git/config` is the active Git config for this machine.
- `.config/mise/config.toml` is the canonical user-level mise config owned by
  adots. It may define home-level tool policy and safe postinstall hooks.
- `.mise.toml` is intentionally a guard file with no `[tools]` pins. Do not use
  `latest` there; zdots owns runtime pin automation and keeps concrete versions
  in lockstep.
- `~/.config/*` tool config is part of adots unless it is explicitly owned by
  another repo. That is the home blanket and the XDG curator layer.

## Mise Boundary

zdots owns:

- installing `mise` via Homebrew
- shell activation and mise shims on `PATH`
- repo-local runtime pins in `~/.config/zsh/mise.toml`
- `mise install` during bootstrap/update
- helper scripts that reconcile runtime support packages

adots owns:

- `~/.config/mise/config.toml` as the restored user-level mise policy
- guardrails that prevent home config from overriding zdots with floating
  runtime versions
- safe postinstall hooks that call zdots helpers when they exist

Ruby support gems are installed by `~/.config/zsh/bin/zdots-ruby-default-gems`
from the zdots-managed list at `~/.config/zsh/etc/mise/default-gems`. This keeps
the package list near the platform that needs it while letting adots ensure new
mise Ruby installs get the expected editor and runtime support.

## Health Checks

Run:

```bash
~/bin/adots-doctor
~/bin/adots-doctor --fix
~/bootstrap.sh --fix
```

The doctor is non-mutating by default. It checks whether adots, zdots, vdots,
key commands, symlinked entrypoints, and mise ownership look sane. Missing or
incorrect zdots-backed paths are reported as work for zdots unless you pass
`--fix`, which repairs only the safe cases and uses backups for replaced files.

## What Not To Track

Do not add secrets, histories, caches, generated files, host auth, or vendored
dependencies. Examples:

```text
.DS_Store
.psql_history
.viminfo
.claude.json
.aider.model.metadata.json
.config/gh/hosts.yml
.config/fabric/.env
.config/aider/caches/
.config/opencode/node_modules/
```
