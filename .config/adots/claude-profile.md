## Who I am
Mike Hall — software engineer, platform builder. I run a personal OS called **zdots**:
a modular Zsh control plane with services, a knowledge layer, observability, and a full
CLI ecosystem across four repos.

## The platform (memorize this)
| Repo | Role | Git |
|---|---|---|
| zdots (`~/.config/zsh`) | kernel: services, CLI, knowledge | normal git |
| adots (`~/.homegit`) | home-dir config — **BARE REPO**, work-tree `$HOME` | `GIT_DIR=~/.homegit GIT_WORK_TREE=$HOME git` |
| my (`~/my`) | private vault + context-engine | normal git |
| vdots (`~/.config/nvim`) | nvim config | normal git |

adots has **no `.git` in `~/.config/adots/`** — that's just config files. Never call
adots untracked because of a missing `.git`.

## Non-negotiable rules
- **PHI-adjacent machine.** Claude Code is a cloud tool — it bypasses the local
  scrubber. Never read `.zdots.secrets`, `.env`, keys, or anything PHI-shaped into
  prompts.
- **Local AI first.** `ZDOTS_AI_MODE=local`. Use `ai-query` / `zaider` / `zdots-ask`
  for inference that stays on-box.
- **zdots is not yours to fix.** File `zdots-issue`, don't patch infrastructure
  unilaterally. Exception: `zclaude` sessions are operator-authorized to maintain zdots.
- **Schrute Test before every irreversible action.** Would an idiot do that? If yes, stop.
- **Kevin's Law always.** Few word do trick. Code first, prose only when code isn't enough.

## Working style
- Ponytail mode default: shortest diff that works, stdlib before abstraction, YAGNI.
- `bin/secret-scan` before any commit touching `$HOME`.
- `rtk` proxy for high-output commands (`rtk git diff`, `rtk docker logs`).
- Check `zdots-ctx query` / `zdots-ctx hydrate` before claiming missing context.
- `/platform-sync` to verify all four repos before pushing anything.

## RTK (Rust Token Killer)

Token-optimized CLI proxy (60–90% savings). The Claude Code hook rewrites
simple commands automatically (`git status` → `rtk git status`); inside
loops/pipelines prefix `rtk` manually. Meta commands are always direct:

```bash
rtk gain              # savings analytics (--history for per-command)
rtk discover          # scan CC history for missed opportunities
rtk proxy <cmd>       # raw passthrough (debugging)
```

If `rtk gain` errors, the wrong rtk is installed (reachingforthejack/rtk
name collision) — `which rtk` to verify.
