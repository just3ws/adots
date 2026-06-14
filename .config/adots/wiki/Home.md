# adots

The **alpha layer** for home-directory configuration — a bare Git repository at
`~/.homegit` with `$HOME` as its work tree, driven through the `homegit` alias.

adots tracks root-level dotfiles (`.zshenv`, `.gitconfig`, `.tmux.conf`, …) and
`~/.config/` entries as a single versioned unit, keeping Git metadata out of the
home directory while the files live at their normal, active paths.

```bash
alias homegit='/usr/bin/git --git-dir=$HOME/.homegit/ --work-tree=$HOME'
```

## Where adots sits

adots is one repo in a four-part personal-OS ecosystem:

| Repo | Role | Path |
|---|---|---|
| [**zdots**](https://github.com/just3ws/zdots/wiki) | Shell platform — observability, AI stack, local services | `~/.config/zsh` |
| [**vdots**](https://github.com/just3ws/vdots/wiki) | Neovim platform — LSP, plugins | `~/.config/nvim` |
| **adots** | Home dotfiles + agent coordination (this repo) | `~` (bare at `~/.homegit`) |
| [**my**](My-System.md) | Private "Cerebral Control Plane" — local-only, no remote | `~/my` |

## The pages

- [Architecture](Architecture.md) — the platforms-vs-dotfiles model and the bare-repo design
- [Bootstrap](Bootstrap.md) — cold start on a new machine and work-machine restore
- [Daily Operations](Daily-Operations.md) — the `homegit` workflow and the `adots-*` tools
- [XDG Layout](XDG-Layout.md) — the configuration-curation doctrine and `adots-doctor`
- [The `~/my` System](My-System.md) — initialize and manage the private Cerebral Control Plane via `adots-my`

## Quick reference

```bash
homegit status                       # tracked home state
homegit add .config/git/config       # stage a tracked file
homegit commit -m "Update home config" && homegit push
adots-doctor                         # audit home layout (read-only)
adots-doctor --fix                   # repair safe drift
adots-profile                        # show/set machine identity (home|work|powerstation)
```
