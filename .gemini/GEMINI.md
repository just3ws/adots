# Agent profile

Mike runs a personal OS ("zdots") across four repos: zdots (`~/.config/zsh`), adots (`~/.homegit`, bare repo, work-tree `$HOME`), my (`~/my`), vdots (`~/.config/nvim`). Full profile and working-style rules: `~/.config/adots/claude-profile.md`.

## Non-negotiable

- PHI-adjacent machine: never read `.zdots.secrets`, `.env` files, keys, or anything PHI-shaped into prompts/context, regardless of tool.
- adots tracks dotfiles under `$HOME` via a bare repo — use the `adots` / `adots-git` wrappers, not ad-hoc git, when touching tracked `$HOME` paths.

## Cross-tool handoffs

Read the most recent file in `~/.config/adots/handoffs/` at the start of a session before assuming context is missing. Before ending a session, or when running low on context, write or append today's handoff file there — see `~/.config/adots/handoffs/README.md` for the format. Shared with Claude Code, Codex CLI, and Antigravity.
