# Daily Operations

Treat `homegit` like a normal Git command — it just targets the adots bare repo
with `$HOME` as the work tree.

## The homegit workflow

```bash
homegit status                       # what changed in tracked home files
homegit diff                         # review before staging
homegit add .psqlrc .config/git/config
homegit commit -m "Update home config"
homegit push                         # publish to just3ws/adots
homegit pull                         # pull changes onto this machine
```

Stage explicitly. Because the work tree is all of `$HOME`, never `homegit add .`
blindly — name the files you mean.

## The adots tools

| Command | Purpose |
|---|---|
| `adots` | High-level home synchronization for the adots bare repo |
| `adots-git` | Run git against the adots bare repo (home work-tree) — the wrapper behind `homegit` |
| `adots-doctor` | Enforce the home layout without mutating by default (`--fix` to repair safe drift) |
| `adots-profile` | Manage the active machine profile (home, work, powerstation) |
| `adots-my` | Structural supervisor for the private `~/my` system |

## Machine profiles

A profile is a machine identity (`home`, `work`, `powerstation`) stored as a
single value. It lets adots and zdots adjust behavior per machine — for example,
enforcing PHI-safe defaults on a work box.

```bash
adots-profile            # show the active profile
adots-profile set work   # switch identity
```

## Relationship to the private `~/my` system

`adots-my` is the structural supervisor for `~/my`, the local-only Cerebral
Control Plane. adots provides the scaffolding and health checks; `~/my` keeps its
own contents private (no remote by design).
