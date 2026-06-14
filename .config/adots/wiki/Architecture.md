# Architecture

adots is the **dotfiles** half of a modular ecosystem. Two kinds of repos make
up the personal OS, and adots knows the difference.

## Platforms vs. Dotfiles

**Platforms** — complex, tested, independently deployable, each with its own
lifecycle and velocity:

- **zdots** (`~/.config/zsh`) — the shell platform. OTel observability, the AI
  stack, local services, a test suite. Drives the full bootstrap; the starting
  point on a new machine.
- **vdots** (`~/.config/nvim`) — the Neovim platform. LSP, plugin manager.

**Dotfiles** — config files tracked as a unit, not deployed software:

- **adots** (`~`) — root-level configs and `~/.config/` entries, versioned as a
  monorepo. tdots (tool-specific XDG config) is folded into adots unless another
  repo owns the tool.
- **my** (`~/my`) — the private Cerebral Control Plane. Local-only by design,
  with no remote.

## The bare-repo design

adots is a **bare** Git repository at `~/.homegit` with `$HOME` as the work tree.
This keeps a `.git/` directory out of `$HOME` (so `$HOME` isn't itself a noisy
repo) while tracked files stay at their canonical paths and actively service the
running system. All interaction goes through the `homegit` alias or the
`adots-git` wrapper rather than plain `git`.

## adots treats zdots as a closed system

adots may **check** that zdots exists and report missing pieces, but it does not
install Homebrew packages, mutate zdots files, or replace zdots bootstrap logic.
The boundary is deliberate: zdots owns the platform; adots owns the home layout.

Shell entrypoints are zdots-owned symlinks when zdots is present:

- `~/.bash_profile -> ~/.config/zsh/bash_profile`
- `~/.bashrc -> ~/.config/zsh/bashrc`
- `~/.zshenv -> ~/.config/zsh/.zshenv`

## Capability declaration

`~/.config/adots/capabilities.sh` is a machine-readable inventory of what adots
provides, so zdots and agents can discover adots functionality without parsing
command help or inferring from file layout. It follows XDG conventions and is the
peer counterpart to zdots's own capability surface.
