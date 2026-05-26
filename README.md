# adots
The alpha layer for home directory configurations.

## Architecture: The Modular Ecosystem

Two kinds of repos:

**Platforms** — complex, tested, independently deployable:
- **zdots** (`~/.config/zsh`): The shell platform. OTel observability, AI stack, local services, tests. Drives the full bootstrap — start here on a new machine.
- **vdots** (`~/.config/nvim`): Neovim config, LSP setup, plugin manager. Its own velocity.

**Dotfiles** — config files tracked as a unit by this repo (adots):
- **adots** (`~`): Root-level configs (`.zshenv`, `.gitconfig`, `.ackrc`, `.tmux.conf`, etc.) and `~/.config/` entries (git config, bat, btop, lazygit, gh-dash). The dotfiles monorepo.
- **my** (`~/my`): The "Cerebral Control Plane." Local-only — no remote by design.

## Bootstrap

**Cold start on a new machine:**

```bash
git clone https://github.com/just3ws/zdots.git ~/.config/zsh
~/.config/zsh/bin/bootstrap
```

zdots bootstrap handles everything: Homebrew, this repo (adots), vdots, Ruby, the AI stack, local services, and database init. adots is cloned and restored automatically as part of that process.
