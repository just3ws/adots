# Safe `~/my` Directory Requirements

`adots` may help a machine discover, validate, and bootstrap a `~/my`
directory, but `adots` must not own the private knowledge stored inside `~/my`.

## Boundary

`adots` is the home dotfiles layer.

`~/my` is the private knowledge and local system-intelligence layer.

`zdots` is the platform/runtime layer that exposes service health, command
contracts, local AI, observability, and the `my` database.

The safe relationship is:

```text
adots -> discovers and validates path conventions
zdots -> provides platform services and machine-readable runtime facts
~/my  -> owns private/public knowledge sources and local HTML cockpit
```

The setup consolidation plan lives at
`~/.config/adots/my-directory-setup-consolidation-plan.md`. That plan defines how
`zdots` should delegate `~/my` preparation to `adots` without moving private
knowledge into either repository.

Model `~/my` structure like a private Rails application: `adots-my doctor` is the
read-only migration-status check, future prepare commands are generators, and
future consolidation work is handled as explicit structural migrations.

## Non-Negotiable Safety Rules

- `adots` must never track raw files under `~/my`.
- `adots` must never track Obsidian vault content from `~/my/vaults/**`.
- `adots` must never track generated indexes, rendered HTML, embeddings, DB dumps, or caches from `~/my`.
- `adots` must never publish, sync, or inspect private vault content as part of normal dotfile sync.
- `adots` may track only stable pointers, conventions, and validation rules for `~/my`.
- If a file contains personal reflection, private history, private notes, or unpublished source material, it belongs in `~/my`, not `adots`.
- If a file configures shells, tools, profiles, or machine-level conventions, it may belong in `adots`.
- If uncertain, consolidate into the closest responsible active system; use archive only for inactive unmapped material.

## Required `~/my` Shape

A healthy `~/my` directory should support these active roots:

```text
~/my/
├── .archive/                 inactive unmapped material, original paths preserved
├── config/                   source registry and local policy
├── context-engine/           local my.localhost cockpit and context API
├── docs/                     structure and operating contracts
├── knowledge/                curated lessons, methodologies, references
└── vaults/
    ├── personal/             private Obsidian vault, never published raw
    └── public/               planned public-safe Obsidian vault, approval gated
```

The older `~/my/_archive` may exist as legacy preserved content, but new archive
moves should target `~/my/.archive` while preserving original relative paths.

## Public Website Relationship

`~/github.com/just3ws/just3ws.github.io` remains the public website repository
and must stay compatible with GitHub Pages so `just3ws.com` continues to serve.

`~/my` may manage that repository through metadata, source registries, publish
queues, and explicit approved exports. It must not absorb the repository into
`~/my`, and raw private vault content must not become a direct input to that
public site.

## Local Browser Requirement

The stable local cockpit name is `my.localhost`.

The cockpit should expose:

- health from `capabilities --json`
- runtime/service guidance from `agent-guide --json`
- context-engine status
- vault/source inventory
- publish readiness
- archive/consolidation candidates
- navigation to related local systems

Prefer `.localhost` names for loopback-only services. Use `.local` names only
when the zdots/adots local proxy configuration explicitly owns them.

## Source Registry Requirement

`~/my/config/sources.yml` is the source-of-truth registry for managed sources.

It should identify:

- private vaults
- public-safe vaults
- context-engine
- external GitHub Pages repositories
- GitHub wiki clones
- archive policy
- visibility and publish rules

`adots` may validate that this file exists, but it must not infer privacy or
publish behavior by crawling `~/my`.

## Archive And Consolidation Requirement

When migrating `~/my`, prefer consolidation over sprawl.

- If content clearly belongs to an active root, move it to that root.
- If content needs reshaping but has a responsible root, move it there with a migration note.
- If content is inactive and has no responsible root, move it to `.archive`.
- Archive moves preserve the original relative path under `~/my/.archive`.
- Bulk moves require a clean inventory and should not run while active repos or vaults are dirty.

## Bootstrap Requirements For adots

`adots` may provide a structural supervision check for `~/my` only if it follows
these rules:

- Check whether `~/my` exists.
- Check whether `~/my/.git` exists and is a separate Git repository.
- Check whether `~/my` is backed by `github.com/just3ws/my`.
- Check whether `~/my/config/sources.yml` exists.
- Check whether `~/my/context-engine` exists.
- Check whether `~/my/vaults/personal` exists.
- Check whether `~/my/.archive` exists.
- Prefer `adots-my doctor` as the canonical read-only validator.
- Warn, do not mutate, when any required path is missing.
- Never run `git add` against `~/my` from the adots work tree.
- Never clone or pull `~/my` unless the operator explicitly requested that action.
- Never copy personal vault content into adots-managed paths.

## Validation Commands

Recommended read-only checks:

```bash
adots-my doctor
test -d "$HOME/my"
test -d "$HOME/my/.git"
test -f "$HOME/my/config/sources.yml"
test -d "$HOME/my/context-engine"
test -d "$HOME/my/vaults/personal"
test -d "$HOME/my/.archive"
```

Optional platform checks:

```bash
capabilities --json
agent-guide --json
curl -fsS http://my.localhost/health || curl -fsS http://my.localhost:7010/health
```

## What adots May Track

Acceptable adots-tracked artifacts:

- this requirements document
- shell aliases that point to `~/my`
- profile-level environment variables such as `MY_HOME=$HOME/my`
- read-only validation scripts
- documentation that explains the boundary

Unacceptable adots-tracked artifacts:

- `~/my/**`
- `~/my/vaults/**`
- `~/my/.archive/**`
- rendered private HTML
- database backups
- embeddings
- generated search indexes
- private transcripts
- public website repository contents

## Acceptance Criteria

A machine is safe to operate with `~/my` when:

- adots can report the expected `~/my` paths without tracking their contents
- zdots can report runtime facts through `capabilities --json` and `agent-guide --json`
- `~/my/config/sources.yml` declares private, public-safe, and external sources
- `my.localhost` can render the local cockpit
- public publishing requires explicit approval
- private vault content remains out of adots, zdots, and public repositories
