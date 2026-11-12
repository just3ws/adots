---
name: platform-operator-profile
scope: all platform repositories
audience: human and coding agents
---

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
- **Sensitive-data-adjacent machine.** Never read `.zdots.secrets`, `.env`, keys,
  or PHI-shaped content into prompts or tool context.
- **Local AI first.** `ZDOTS_AI_MODE=local`. Use `ai-query` / `zaider` / `zdots-ask`
  for inference that stays on-box.
- **zdots is coordinated infrastructure.** Make changes only when the operator
  requests them; otherwise file `zdots-issue` and work at the task level.
- **Schrute Test before every irreversible action.** Would an idiot do that? If yes, stop.
- **Kevin's Law always.** Few word do trick. Code first, prose only when code isn't enough.
- **Work vs Open-Source Delineation.** On work machines, keep personal platform repos (`zdots`, `adots`, `vdots`) strictly delineated from corporate repos. Platform commits must never carry corporate emails (`@company.com`), tenant secrets, or internal identifiers. Corporate repos must never carry `mike@just3ws.com`. Scoped automatically via `~/.config/git/config`. Verify with `git config user.email` before committing. Keep tweaks minimal on work hardware.
- **Work Computer Bootstrap & Safe AI Agent Integration.** When bootstrapping or migrating the platform onto a new or pre-configured work computer, always follow `~/.config/zsh/docs/work-migration-playbook.md` (and `docs/work-profile.md`; use `docs/bootstrap-playbook.md` only for a clean-slate OS install). Configure `~/.config/zsh/.zdots.local` with `ZDOTS_CONTEXT=work` (and `ZDOTS_POSTGRES_VERSION=17` if applicable) **before** running `bin/bootstrap`, run Phase 1 audit-before-action setup log ingestion and pause on the Reconciliation Matrix for operator approval, perform non-destructive selective `adots` restore (never clobbering corporate `~/.ssh`, 1Password, or `~/.config/mise/config.toml`), scaffold `~/my` exclusively via `adots-my prepare --apply` (never cloning the personal `~/my` vault), and emit the Phase 10 Upstream Reconciliation & Delta Report.

## Working style
- Ponytail mode default: shortest diff that works, stdlib before abstraction, YAGNI.
- `bin/secret-scan` before any commit touching `$HOME`.
- `rtk` proxy for high-output commands (`rtk git diff`, `rtk docker logs`).
- Check `zdots-ctx query` / `zdots-ctx hydrate` before claiming missing context.
- `/platform-sync` to verify all four repos before pushing anything.

## RTK (Rust Token Killer)

Token-optimized CLI proxy. Prefix high-output commands with `rtk`, especially
inside scripts, loops, and pipelines. Meta commands are always direct:

```bash
rtk gain              # savings analytics (--history for per-command)
rtk proxy <cmd>       # raw passthrough (debugging)
```

If `rtk gain` errors, the wrong rtk is installed (reachingforthejack/rtk
name collision) — `which rtk` to verify.

## Panoramic View Labs (PVL) Platform Identity

- **Panoramic View**: The technique / investigation method (4D system cartography).
- **Panoramic View Labs (PVL)**: The initiative name and umbrella (spoken "Pavel").
- **Pavel**: The Panoramic View specialist agent.
- **zdots**: The root local platform and runtime for all PVL capabilities.

## Tooling Philosophy: Ack For Life

Andy Lester created `ack`, attended Mike's first user-group meeting in Crystal Lake, IL, and presented at SCMC (Software Craftsmanship McHenry County):
- **Archived talks & interviews** (on `https://just3ws.localhost`):
  - *Enough C To Get Started In F/OSS* (SCMC, 2011-07-20, Parts 1 & 2: `vimeo-26657739`, `vimeo-26669252`)
  - *Open Source And Project Maintenance: Mike Hall Interviews Andy Lester* (ChicagoWebConf 2012: `/interviews/andy-lester-chicagowebconf-2012/`)
  - Full archive at `https://just3ws.localhost/scmc/`
- **Reach for `ack` first**: `ack`, `fack` (fuzzy ack via fzf + bat), `acke` (ack into quickfix), `:Ack` in Neovim.
- **Maintain good configurations for modern tools**: Keep ripgrep, Telescope, and modern tools sharp as first-class fallbacks.


