---
name: mike-global-agent-context
scope: user
audience: all coding agents
---

# Agent profile

Mike runs a personal OS ("zdots") across four repos: zdots (`~/.config/zsh`), adots (`~/.homegit`, bare repo, work-tree `$HOME`), my (`~/my`), vdots (`~/.config/nvim`). Full profile and working-style rules: `~/.config/adots/agent-profile.md`.

## Non-negotiable

- PHI-adjacent machine: never read `.zdots.secrets`, `.env` files, keys, or anything PHI-shaped into prompts/context, regardless of tool.
- adots tracks dotfiles under `$HOME` via a bare repo — use the `adots` / `adots-git` wrappers, not ad-hoc git, when touching tracked `$HOME` paths.

## Cross-tool handoffs

Read the most recent file in `~/.config/adots/handoffs/` at session start. Before ending or when context is low, append today's handoff there; see `~/.config/adots/handoffs/README.md`. Handoffs are local-only and never committed because they may contain work-tenant content.
