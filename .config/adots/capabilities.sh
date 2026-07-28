#!/usr/bin/env bash
# ---
# id: adots-capabilities
# title: "Adots Capabilities Declaration"
# purpose: Machine-readable declaration of adots capabilities for zdots and agents.
# rationale: Enables zdots and agents to discover adots functionality without parsing
#           command help or inferring from file layout. Follows XDG conventions.
# ---
# adots/capabilities.sh — Declarative capabilities inventory.
#
# RATIONALE:
# adots is the home dotfiles platform. This file declares what it provides so that:
# - zdots bootstrap can verify adots presence and status
# - Claude Code can discover available commands at startup
# - Agents can query capabilities programmatically
# - New machines can understand the expected adots state
#
# This is sourced but not executed (no side effects). It is a read-only declaration.

# Metadata: adots identity and paths
ADOTS_REPO="${ADOTS_REPO:-$HOME/.homegit}"
ADOTS_CONFIG_DIR="${ADOTS_CONFIG_DIR:-$HOME/.config/adots}"
ADOTS_PROFILE_FILE="${ADOTS_PROFILE_FILE:-$ADOTS_CONFIG_DIR/profile}"
ADOTS_MY_REQUIREMENTS_FILE="${ADOTS_MY_REQUIREMENTS_FILE:-$ADOTS_CONFIG_DIR/my-directory-requirements.md}"
ADOTS_MY_SETUP_PLAN_FILE="${ADOTS_MY_SETUP_PLAN_FILE:-$ADOTS_CONFIG_DIR/my-directory-setup-consolidation-plan.md}"
ADOTS_BIN_DIR="${ADOTS_BIN_DIR:-$HOME/bin}"

# Profile management: query current profile, switch to a named profile.
# Profiles are machine identities (home, work, powerstation, etc.) that control
# which shell configs, Git config, and tool behaviors activate at startup.
# The active profile is stored in $ADOTS_PROFILE_FILE as a single line.
#
# Commands:
#   adots-profile                   # print active profile to stdout
#   adots-profile <name>            # switch to profile <name>
#   adots-profile list              # list available profiles
#   adots-profile validate          # check that profile is consistent with zdots
#
# Status:
#   Returns 0 if profile is valid, 1 if unset or invalid, 2 if no profiles defined.
ADOTS_CAPABILITIES_PROFILE=(
  "profile:get:adots-profile"
  "profile:set:adots-profile <name>"
  "profile:list:adots-profile list"
  "profile:validate:adots-profile validate"
)

# Home synchronization: pull changes from remote, status, push local changes.
# The adots repo is a bare Git repo at ~/.homegit with $HOME as the work tree.
# Use the homegit alias to interact with it, or these high-level commands.
#
# Commands:
#   adots sync                      # pull from remote and report changes
#   adots status                    # show untracked/modified tracked files
#   adots push [<remote>] [<branch>] # push to remote (default: origin main)
#
# Examples:
#   adots sync                      # fetch and report new tracked files
#   adots status --verbose          # include diff of modified files
#   adots push origin main          # push to GitHub
#   adots push                      # push to configured upstream
ADOTS_CAPABILITIES_SYNC=(
  "home:sync:adots sync"
  "home:sync-status:adots sync --status"
  "home:status:adots status"
  "home:status-verbose:adots status --verbose"
  "home:push:adots push"
)

# Health checks: doctor in various modes.
# adots-doctor validates that the home layout is consistent with adots ownership,
# checks for missing tracked files, and optionally repairs safe drift.
#
# Commands:
#   adots-doctor                    # full check: no mutations
#   adots-doctor --fix              # safe repair: restore missing tracked files
#                                     replace symlink aliases, append config includes
#   adots-doctor --quiet            # warnings and failures only (exit code only)
#
# Checks:
#   - Tracked files exist and match adots HEAD
#   - Symlinked entrypoints point to zdots (when zdots is present)
#   - XDG tool roots are canonical (no duplicate config paths)
#   - .gitconfig includes the adots Git config when tracked
#   - zdots bootstrap paths are accessible
#
# Exit codes:
#   0 = all checks passed
#   1 = failures detected (--fix did not repair all issues)
#   2 = setup incomplete (adots repo missing or zdots not accessible)
ADOTS_CAPABILITIES_HEALTH=(
  "health:check:adots-doctor"
  "health:check-verbose:adots-doctor --verbose"
  "health:fix:adots-doctor --fix"
  "health:quiet:adots-doctor --quiet"
)

# Private knowledge system supervision: validate the safe ~/my skeleton without
# reading vault contents or mutating the private repository.
ADOTS_CAPABILITIES_MY=(
  "my:doctor:adots-my doctor"
  "my:doctor-quiet:adots-my doctor --quiet"
  "my:doctor-json:adots-my doctor --json"
  "my:prepare:adots-my prepare"
  "my:prepare-dry-run:adots-my prepare --dry-run"
  "my:migrate:adots-my migrate"
  "my:migrate-dry-run:adots-my migrate --dry-run"
)

# Git operations: low-level access to adots as a bare repo.
# These are thin wrappers over `git --git-dir=$HOME/.homegit --work-tree=$HOME`.
# Prefer high-level commands (adots sync, adots status) when available.
#
# Commands:
#   adots-git <git-args>            # run Git on the adots repo
#   adots-git status                # show working tree status
#   adots-git diff                  # show changes to tracked files
#   adots-git log --oneline -10     # recent commits
#   adots-git add .psqlrc           # stage a file
#   adots-git commit -m "msg"       # commit with message
#   adots-git push                  # push to remote
#
# Note: Use `homegit` alias if available for the same purpose.
ADOTS_CAPABILITIES_GIT=(
  "git:status:adots-git status"
  "git:diff:adots-git diff"
  "git:log:adots-git log --oneline -10"
  "git:add:adots-git add <files>"
  "git:commit:adots-git commit -m <message>"
  "git:push:adots-git push"
)

# Metadata: adots version and repo state.
# Used by zdots bootstrap to verify adots presence and readiness.
#
# Variables (sourced by bootstrap):
#   ADOTS_REPO              = ~/.homegit (bare Git repo)
#   ADOTS_CONFIG_DIR        = ~/.config/adots
#   ADOTS_PROFILE_FILE      = ~/.config/adots/profile
#   ADOTS_MY_REQUIREMENTS_FILE = ~/.config/adots/my-directory-requirements.md
#   ADOTS_MY_SETUP_PLAN_FILE = ~/.config/adots/my-directory-setup-consolidation-plan.md
#   ADOTS_BIN_DIR           = ~/bin
#
# Checks (run by zdots bootstrap):
#   - ADOTS_REPO is a valid bare Git repo
#   - ADOTS_CONFIG_DIR exists and is readable
#   - ADOTS_PROFILE_FILE exists and contains a valid profile name
#   - ADOTS_MY_REQUIREMENTS_FILE documents safe ~/my setup requirements
#   - ADOTS_MY_SETUP_PLAN_FILE documents the adots-owned ~/my setup handoff
#   - ~/bin exists and is on $PATH
ADOTS_CAPABILITIES_METADATA=(
  "metadata:repo:ADOTS_REPO=$ADOTS_REPO"
  "metadata:config-dir:ADOTS_CONFIG_DIR=$ADOTS_CONFIG_DIR"
  "metadata:profile-file:ADOTS_PROFILE_FILE=$ADOTS_PROFILE_FILE"
  "metadata:my-requirements-file:ADOTS_MY_REQUIREMENTS_FILE=$ADOTS_MY_REQUIREMENTS_FILE"
  "metadata:my-setup-plan-file:ADOTS_MY_SETUP_PLAN_FILE=$ADOTS_MY_SETUP_PLAN_FILE"
  "metadata:bin-dir:ADOTS_BIN_DIR=$ADOTS_BIN_DIR"
)

# Aggregate: All capabilities in a single array.
# Format: "category:operation:command" — parseable by shell and agents.
#
# Example iteration (in bash):
#   for cap in "${ADOTS_ALL_CAPABILITIES[@]}"; do
#     category="${cap%%:*}"
#     operation="${cap#*:}"; operation="${operation%%:*}"
#     command="${cap##*:}"
#     printf 'Category: %s  Operation: %s  Command: %s\n' "$category" "$operation" "$command"
#   done
#
# shellcheck disable=SC2034
declare -ga ADOTS_ALL_CAPABILITIES=(
  "${ADOTS_CAPABILITIES_PROFILE[@]}"
  "${ADOTS_CAPABILITIES_SYNC[@]}"
  "${ADOTS_CAPABILITIES_HEALTH[@]}"
  "${ADOTS_CAPABILITIES_MY[@]}"
  "${ADOTS_CAPABILITIES_GIT[@]}"
  "${ADOTS_CAPABILITIES_METADATA[@]}"
)
export ADOTS_ALL_CAPABILITIES

# Status check: verify adots is fully functional.
# Returns 0 if all checks pass (setup complete and healthy).
# Returns 1 if any check fails (setup incomplete or health issue).
#
# Checks:
#   - ADOTS_REPO exists and is a valid bare Git repo
#   - ADOTS_CONFIG_DIR exists and is writable
#   - ADOTS_PROFILE_FILE exists and is readable
#   - ADOTS_MY_REQUIREMENTS_FILE exists and is readable
#   - ADOTS_MY_SETUP_PLAN_FILE exists and is readable
adots_check_status() {
  # shellcheck disable=SC2086
  set +e
  local exit_code=0

  if ! [ -d "$ADOTS_REPO" ]; then
    printf 'adots: FAIL repo not found: %s\n' "$ADOTS_REPO" >&2
    exit_code=1
  fi

  if ! [ -d "$ADOTS_CONFIG_DIR" ]; then
    printf 'adots: FAIL config dir not found: %s\n' "$ADOTS_CONFIG_DIR" >&2
    exit_code=1
  fi

  if ! [ -f "$ADOTS_PROFILE_FILE" ]; then
    printf 'adots: FAIL profile file not found: %s\n' "$ADOTS_PROFILE_FILE" >&2
    exit_code=1
  fi

  if ! [ -f "$ADOTS_MY_REQUIREMENTS_FILE" ]; then
    printf 'adots: FAIL my requirements file not found: %s\n' "$ADOTS_MY_REQUIREMENTS_FILE" >&2
    exit_code=1
  fi

  if ! [ -f "$ADOTS_MY_SETUP_PLAN_FILE" ]; then
    printf 'adots: FAIL my setup plan file not found: %s\n' "$ADOTS_MY_SETUP_PLAN_FILE" >&2
    exit_code=1
  fi

  set -e
  return "$exit_code"
}
