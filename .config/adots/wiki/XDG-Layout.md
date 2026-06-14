# XDG Layout

adots curates the home directory's configuration layout. If a tool can live under
`~/.config`, that path is its canonical home.

## The doctrine

- **`~/.config` is canonical.** Legacy roots (e.g. a tool's dotfile in `$HOME`)
  are acceptable only as compatibility aliases while the doctor migrates state
  back to the XDG location.
- **Fail rather than guess.** If the tree cannot be made unambiguous,
  `adots-doctor` fails instead of picking a path. Ambiguity is a bug to surface,
  not to paper over.

## The Colima example

Colima is the concrete case the doctrine was written against:

- `~/.config/colima` is the **canonical** root.
- `~/.colima` (the legacy root) should be moved out of the way.

If both exist and the layout is ambiguous, `adots-doctor` fails rather than
guessing which one is authoritative.

## Running the doctor

```bash
adots-doctor          # audit the home layout (read-only — no mutation)
adots-doctor --fix    # repair safe drift back to the canonical XDG paths
```

Always read the audit before `--fix`, especially on a managed work machine where
tool configs may be employer-owned. See [Bootstrap](Bootstrap.md) for the
restore order and [Architecture](Architecture.md) for why adots — not zdots —
owns the home layout.
