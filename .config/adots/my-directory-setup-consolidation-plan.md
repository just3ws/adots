# `~/my` Setup Consolidation Plan

This plan makes `adots` the structural supervisor for `~/my` setup while keeping
`~/my` content private and keeping `zdots` focused on runtime services.

## Principle

`zdots` may depend on `~/my`, but it should not be the system that decides how a
home directory is structurally supervised for `~/my`.

Think about `~/my` like a private Rails application:

- `adots-my doctor` is the `db:migrate:status` equivalent for structure.
- Future `adots-my prepare` should behave like a Rails generator: idempotent,
  explicit, template-oriented, and safe to re-run.
- `adots-my migrate` should behave like a Rails migration: versioned,
  archive-preserving, and explicit about every moved legacy root.
- Future `~/my` consolidation should behave like migrations: versioned,
  reviewable, reversible through `.archive`, and never implicit.
- `zdots` is a runtime dependency, not the generator that owns the app schema.

The stable split is:

```text
adots -> supervises and validates home-directory conventions
zdots -> runs platform services and reports machine-readable runtime facts
~/my  -> owns private/public knowledge, vaults, source registry, and cockpit code
```

This keeps private knowledge out of dotfiles while giving new machines a clear
bootstrap path.

## Current Problem

The `~/my` setup concern is spread across several systems:

- `adots` knows the home-directory shape and shell/profile conventions.
- `zdots` knows service health, nginx/proxy behavior, databases, and agent facts.
- `~/my` knows vaults, source registries, archives, and the local cockpit.
- Public repositories and wiki clones have their own GitHub Pages or wiki rules.

When `zdots` manages too much of `~/my`, setup logic drifts toward runtime code
and risks private/public boundary leaks. When `adots` manages too much, private
knowledge risks entering the dotfiles repository. The fix is a narrow handoff:
`adots` supervises the safe shell and directory contract; `zdots` consumes that
contract and manages only runtime integrations.

## Target Ownership

`adots` supervises:

- stable path conventions such as `MY_HOME=$HOME/my`
- read-only checks for required `~/my` roots
- validation that `~/my` is its own private `github.com/just3ws/my` checkout
- shell aliases or helpers that navigate to `~/my`
- documentation for private/public boundaries
- future dry-run-first preparation of empty directory skeletons and template files

`zdots` owns:

- local service orchestration
- `capabilities --json`
- `agent-guide --json`
- local proxy and TLS facts for names such as `my.localhost`
- Postgres, Redis, embeddings, or other runtime dependencies
- health and observability surfaces used by the `~/my` cockpit

`~/my` owns:

- private and public-safe vaults
- `config/sources.yml`
- `context-engine`
- living documentation and operating notes
- `.archive` migration staging
- export queues or publishing metadata

Public repositories own:

- GitHub Pages-compatible source trees
- repository wikis cloned as sibling `.wiki` repositories where possible
- public documentation that has passed explicit approval

## Migration Phases

### Phase 0: Inventory

Build a read-only inventory of current `~/my` setup behavior:

- paths expected by `zdots`
- paths expected by `~/my/context-engine`
- shell aliases, environment variables, and docs already present in `adots`
- public repositories and wiki clones that `~/my` should reference but not absorb
- stale or unmapped files that should move under `~/my/.archive`

No file moves happen in this phase.

### Phase 1: adots Declarations

Track the safe setup contract in `adots`:

- `my-directory-requirements.md`
- this setup consolidation plan
- capability metadata that points agents and `zdots` to those files

This phase is complete when `adots_check_status` fails if either document is
missing.

### Phase 2: adots Validator

Add a read-only validator, either as a dedicated `adots-my doctor` command or as
an extension to `adots-doctor`. This is the structural equivalent of
`rails db:migrate:status`; it reports whether the private `~/my` checkout
matches the expected contract without changing it.

Current command:

```bash
adots-my doctor
adots-my doctor --json
adots-my prepare --dry-run
adots-my migrate --dry-run
```

The validator should check:

- `~/my` exists
- `~/my/.git` exists and is a separate repository
- `~/my` origin points to `github.com/just3ws/my`
- `~/my/config/sources.yml` exists
- `~/my/context-engine` exists
- `~/my/vaults/personal` exists
- `~/my/vaults/public` exists or is explicitly deferred
- `~/my/.archive` exists

The validator must not crawl vault contents, generate indexes, run `git add`, or
mutate files.

### Phase 3: adots Prepare

Add an explicit prepare command after the validator is stable.

Recommended shape:

```bash
adots-my prepare --dry-run
adots-my prepare --apply
```

`--dry-run` reports missing directories and files.

`--apply` may create only empty directories and approved template files. It must
not clone the private `~/my` repository, pull remote content, copy vault data, or
publish anything unless a later explicit flag is added for that exact action.

Private repository recovery should remain an explicit operator decision.

Generator rule: if `adots-my prepare` ever writes files, every write must be
idempotent, previewable in `--dry-run`, and explain which structure contract it
is bringing the machine toward.

Migration rule: if existing `~/my` content must move, the operation belongs in a
separate versioned migration plan that preserves original relative paths under
`~/my/.archive` before any active tree cleanup is considered complete.

The current migration path is `adots-my migrate`, which is responsible for
moving legacy root-level directories like `backlog/`, `lessons/`, and
`standards/` into `~/my/.archive/` with a note under `docs/migrations/`.

### Phase 4: zdots Delegation

Update `zdots` bootstrap and service checks to treat adots as the source of
truth for home preparation.

`zdots` may:

- read adots capability metadata
- call or recommend the adots validator
- fail fast when required `~/my` structure is absent
- expose runtime health to the `~/my` cockpit

`zdots` should not:

- define the canonical `~/my` directory layout
- create private vault directories without going through the adots setup path
- inspect private vault content
- track or publish private `~/my` material

### Phase 5: Integration Validation

A machine is ready when all of these are true:

```bash
adots-my doctor
adots_check_status
capabilities --json
agent-guide --json
test -f "$HOME/my/config/sources.yml"
curl -fsS http://my.localhost/health
```

If `my.localhost` uses TLS through the local proxy, the equivalent HTTPS health
check may replace the HTTP check.

## Archive And Consolidation Rule

When uncertain, consolidate into the closest responsible active system. Use
`~/my/.archive` only for inactive or unmapped material.

Archive moves must preserve relative paths:

```text
~/my/old/path/file.md -> ~/my/.archive/old/path/file.md
```

This preserves migration history without allowing sprawl to keep growing in the
active tree.

## Non-Goals

`adots` does not own:

- private `~/my` repository contents
- Obsidian vault content
- public website repositories
- GitHub wiki content
- rendered private HTML
- embeddings, indexes, caches, or database dumps
- runtime service supervision

`zdots` does not own:

- private/public knowledge classification
- Obsidian vault structure
- `~/my` repository history
- adots home-directory policy

## Acceptance Criteria

- A clean machine can use adots to understand and prepare the `~/my` skeleton
  without private content.
- `zdots` can consume the adots setup contract instead of hard-coding the
  `~/my` layout.
- `~/my/config/sources.yml` remains the source registry for vaults, public
  repositories, wiki clones, and archive policy.
- `my.localhost` can expose health, stability, capabilities, and navigation once
  the runtime layer is available.
- No adots-tracked file contains raw `~/my` content.
- Public publishing remains explicit and approval-gated.

## Open Decisions

- Command name: `adots-my` versus `adots prepare my`.
- Whether private repo clone support is manual-only or allowed through a future
  explicit `--clone-private-my` flag.
- Whether `~/my/vaults/public` should be created by default or deferred until a
  public-safe publishing flow exists.
- Whether wiki clones should be normalized under `$HOME/github.com/<org>/<repo>.wiki`
  before `~/my/config/sources.yml` treats them as managed sources.
