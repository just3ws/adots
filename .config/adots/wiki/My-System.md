# The `~/my` System

`~/my` is the **Cerebral Control Plane** — a private, local-first knowledge and
context system. It is its **own** Git repository (remote
`github.com/just3ws/my`, **private**), deliberately separate from adots: adots
must not track it, and it must not live inside the adots bare repo. adots only
**supervises its structure** through `adots-my`.

## What it is — and is not

| | |
|---|---|
| Repo | separate work tree at `~/my`, origin `github.com/just3ws/my` (private) |
| Owner of structure | `adots-my` (validate/scaffold only — never touches content) |
| Contract version | `my.structure.v1` |
| Relationship to adots | adots **does not** track `~/my`; `~/my` **does not** use `~/.homegit` |
| Publishing | nothing publishes by default; the public vault is **approval-gated** |

`adots-my` is a **structural supervisor**. By contract it validates paths and
repository boundaries only — it must not crawl vault contents, build indexes, run
`git add`, clone, pull, or publish. Content is yours; adots guards the skeleton.

## The skeleton (`my.structure.v1`)

```
~/my/
  .archive/                  legacy roots parked here by `migrate`
  config/sources.yml         the source registry (what exists, visibility, publish policy)
  docs/                      system docs
  docs/migrations/           structural migration notes (my.structure.migration.v1, …)
  context-engine/            local Rails service — system intelligence + context API
  knowledge/
    inbox/  lessons/  methodologies/  references/
  vaults/
    personal/                private Obsidian vault (publish: never)
    public/                  public-safe vault (planned; publish: approval_required)
```

## Source registry — `config/sources.yml`

The registry declares each source's visibility and publish policy. Defaults are
fail-safe: **`publish: never`** for private sources, **`approval_required`** for
the public-candidate vault (which ships as `active: planned`).

| Source | Visibility | Publish |
|---|---|---|
| `my.context_engine` | internal | never |
| `my.vault.personal` | private | never |
| `my.vault.public` | public_safe | approval_required (planned) |

## Initialize on a new machine

`~/my` is **not** part of the [zdots](https://github.com/just3ws/zdots/wiki)
cold-start bootstrap (it's private, with no
public clone). Set it up explicitly:

```bash
# 1. Clone the private repo to the canonical path
git clone https://github.com/just3ws/my.git ~/my

# 2. Scaffold any missing skeleton (preview first — prepare defaults to --dry-run)
adots-my prepare              # dry-run: shows what it would create
adots-my prepare --apply      # create the skeleton + config/sources.yml

# 3. Verify the contract
adots-my doctor               # expect: pass (public vault may warn = deferred)
```

If you have no remote yet, create `~/my` as its own repo first
(`git init ~/my && git -C ~/my remote add origin git@github.com:just3ws/my.git`),
then `adots-my prepare --apply`. The doctor fails loudly if `~/my` is accidentally
a plain directory, points at the wrong remote, or is captured by the adots bare
repo.

## Manage day to day

```bash
adots-my doctor               # read-only contract check (use --json for agents)
adots-my doctor --quiet       # failures/warnings only
adots-my prepare --apply      # (re)create any missing skeleton dirs/files
adots-my migrate --apply      # move legacy roots into ~/my/.archive (+ migration note)
```

- **doctor** mutates nothing — safe to run anytime, and it's the gate to run
  before trusting the system. Checks: separate work tree, correct remote, not
  adots-tracked, registry present, context-engine + private vault + archive
  exist, public-vault deferral.
- **prepare** / **migrate** default to `--dry-run`; pass `--apply` to write.
  Choose one of `--dry-run`/`--apply`, never both.
- **migrate** parks legacy top-level roots (`backlog`, `lessons`,
  `methodologies`, `standards`, `transcripts`, `adrs`, `_archive`) under
  `.archive/`, preserving relative paths, and refuses to overwrite an existing
  archive entry.

## Why the hard boundaries

The doctor **fails** rather than guessing when boundaries blur, because the cost
of confusion is high: if adots tracked `~/my`, private content could leak into
the public adots history; if `~/my` used `~/.homegit`, the two repos would
fight over `$HOME`. Keeping them separate — and letting `adots-my` enforce that
separation read-first — is what makes the private plane safe to automate against.

See [Architecture](Architecture.md) for where `~/my` sits in the ecosystem and
[Daily Operations](Daily-Operations.md) for the `adots-my` summary row.
