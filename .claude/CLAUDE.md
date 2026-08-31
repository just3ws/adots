@~/.config/adots/claude-profile.md

## Cross-tool handoffs

Read the most recent file in `~/.config/adots/handoffs/` at the start of a session before assuming context is missing. Before ending a session, or when running low on context, write or append today's handoff file there — see `~/.config/adots/handoffs/README.md` for the format. This log is shared with Codex CLI, Gemini CLI, and Antigravity. **Handoff files are local-only — never commit them** (they routinely carry work-tenant content).

**Per-repo cold-start state — the reliable channel.** "Read the newest handoff file" fails often: another tool's session close bumps a different file to the top, and it's opt-in. So each repo carries a `CURRENT FOCUS` block at the **top of its `AGENTS.md`** (one canonical copy — `CLAUDE.md` / `GEMINI.md` in the repo just point to it, since each tool loads a different always-on file). The block holds: what's in flight, live task/issue IDs one line each, what's blocked on the human, and the **exact path** to that repo's deep handoff in `~/.config/adots/handoffs/`. **Closing a session = rewrite that repo's `AGENTS.md` CURRENT FOCUS block and commit it — step one, before the wrap-up summary.** Reference implementation: `wwworkremote/core` (`docs/agents/session-handoff.md` is the full resume + close procedure). If a repo doesn't have the block yet, add it (block in `AGENTS.md`, pointer in the rest) or ask the human.

How that is actually enforced (verified 2026-08-04 — the earlier "they are gitignored; only the README is tracked" was wrong on both counts): there is **no `.gitignore`** in `handoffs/`, and the README is tracked in **none** of the four repos. Protection comes from adots being configured `status.showUntrackedFiles = no`, so untracked files never appear in `git status` and cannot be swept up by a bulk add — an explicit-add model, not an ignore rule. Practical consequences: (1) don't rely on `git check-ignore` to tell you a handoff is safe — it will say "not ignored"; (2) never `git add` a handoff path explicitly, since nothing would stop you; (3) if that config is ever changed, the safety net is gone.

@RTK.md
