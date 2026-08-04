# Handoffs

Session-to-session handoff log, shared across every agent/tool working on this machine (Claude Code, Codex CLI, Gemini CLI, Antigravity). One file per session close, named by date.

**Local-only — never commit.** Handoff files routinely carry work-tenant content. Do not `git add` them, ever.

### How that is enforced (corrected 2026-08-04)

This section previously said the files "are gitignored (`.gitignore`); only this README … is tracked." **Both halves were wrong.** Verified:

- There is **no `.gitignore`** in this directory, and `git check-ignore` on a handoff file reports **"not ignored."**
- This README is tracked in **none** of the four repos (adots `~/.homegit`, zdots, `my`, vdots) — `git ls-files | grep -i handoff` returns nothing in all four.

The actual protection is that adots is configured **`status.showUntrackedFiles = no`**, so untracked files never surface in `git status` and cannot be picked up by a bulk `git add`. It is an **explicit-add model, not an ignore rule.**

That is genuinely safe for the normal path, with three caveats worth knowing:

1. **Don't use `git check-ignore` as your safety check** — it will tell you a handoff is *not* ignored, which is true and yet not the whole picture.
2. **An explicit `git add .config/adots/handoffs/<file>.md` would succeed.** Nothing blocks it. The protection is against accident, not intent.
3. **If `status.showUntrackedFiles` is ever changed, the net disappears** and every handoff becomes visible to a bulk add at once.

Optional hardening, not yet applied: adding a `.gitignore` here containing `*.md` plus `!README.md` would make the original description true and give defence in depth. Left as a decision rather than a unilateral change to shared config.

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
