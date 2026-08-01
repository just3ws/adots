# Handoffs

Session-to-session handoff log, shared across every agent/tool working on this machine (Claude Code, Codex CLI, Gemini CLI, Antigravity). One file per session close, named by date.

**Local-only — never commit.** Handoff files routinely carry work-tenant content and are gitignored (`.gitignore`); only this README (and the pre-protocol 2026-06-23 exemplar) is tracked. Do not `git add` them or work around the ignore rule.

## File naming

`~/.config/adots/handoffs/YYYY-MM-DD.md` — if more than one handoff closes on the same date, append `-2`, `-3`, etc. (`2026-07-24-2.md`).

## Protocol

- **At the start of a session**: read the most recent file in this directory before assuming context is missing.
- **Before ending a session, or when running low on budget/tokens**: write or append today's file with what changed and what's still open, using the template below.

## Template

```
# Handoff — <date> (<tool>, session close)

## Session Summary
One or two sentences: what this session worked on.

## Changes
Per repo/project touched: commits made, files changed, still-uncommitted diffs.

## Open Threads
What's unfinished, and the next concrete step.

## Notes
Anything the next agent needs that isn't obvious from git state (decisions made, things deliberately left alone, gotchas hit).
```

Platform-maintenance sessions (work spanning the zdots/adots/my/vdots repos) may also include the fuller `Platform State at Session End` / `Accepted Noise` / `Suggested Skills` sections used in earlier handoffs (see `2026-06-23.md` for an example) — those are optional extras, not required from every tool.
