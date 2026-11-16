# Command output

Command output here is condensed to save tokens, keeping every signal and
dropping costly noise. Treat it as the complete result: run commands
normally, and batch related commands into one call to avoid extra turns.
Truncated results state their recovery path in their own output. Re-run a
command as `rtk bypass <cmd>` only when its result is unusable: empty when
output was clearly expected, contradicting its exit code, or garbled.

## Write commands the hook can rewrite

The `rtk hook claude` PreToolUse hook rewrites a Bash call only when it can
parse every part of it. One construct it can't parse sends the whole call
through raw. Measured on 2026-11-16: 58% of calls went through raw, mostly
because of how they were written.

- **Raw (avoid):**
  - `$(...)` anywhere in the call, e.g. `B=$(git branch --show-current); …`
  - shell function definitions, e.g. `G() { git --git-dir=… "$@"; }`
  - `zsh -lc '…'` / `bash -c '…'` wrappers
  - heredocs, e.g. `python3 - <<'PY'`
  - `sed -n` to read a file (use the Read tool)
- **Rewritten (prefer):**
  - plain `git -C <dir> …`, and `git --git-dir="$HOME/.homegit" --work-tree="$HOME" …`
    for adots, written out in full
  - `gh`, `grep`/`rg`, `ls`, `find`, `curl`, `make`, `go test`, `psql`, `jq`
  - `cd <dir> && cmd; cmd2` chains and simple pipes
- **When a call needs `$(...)`, a function or a wrapper,** e.g. the
  branch check before a push, keep that call small. Run the verbose read-only
  commands (log, diff, status, PR views, searches) as separate plain calls.
- **File edits** go through the Edit/Write tools, not heredoc scripts.
- **Check coverage:** look at the `hook_decisions` table in
  `~/Library/Application Support/rtk/history.db` (`defer` = sent through raw).
  `rtk discover` over-counts misses, because it reads the original command
  from the transcript, including calls the hook did rewrite.
