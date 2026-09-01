# Security Policy

This is a personal configuration repository, maintained by one person, best-effort.

## Reporting a vulnerability

Please **do not open a public issue** for security-sensitive reports.

Use GitHub's private vulnerability reporting:
**[Report a vulnerability](https://github.com/just3ws/adots/security/advisories/new)**
(Security tab → "Report a vulnerability").

Expect an acknowledgement within a week. There is no bug bounty.

## Scope

In scope: anything in this repository that could expose secrets, execute
untrusted code, or weaken the home directory it configures — for example a `bin/`
script that mishandles credentials, a workflow that leaks `GITHUB_TOKEN`, or a
default that disables a protection.

Out of scope: third-party tools this repo installs or wraps (report those
upstream), and the security of a machine that has deviated from the documented
setup.

## What this repo already does

- **No secrets committed.** This repo tracks config files only — never
  `.gitconfig` credentials, `.netrc`, host auth, or tool caches (see the
  "What Not To Track" list in the README). GitHub secret scanning + push
  protection are on.
- Managed as a **bare repository** (`~/.homegit`, work tree `$HOME`) with
  `status.showUntrackedFiles=no`, so files enter the tracked set only by
  explicit `add` — never a bulk sweep.
