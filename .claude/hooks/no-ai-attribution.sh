#!/usr/bin/env sh
# PreToolUse(Bash) — refuse git commits and gh PR/issue writes that carry
# AI-tool attribution (~/.claude/CLAUDE.md "No AI attribution, anywhere").
# Same pattern as the zdots/adots/vdots .githooks/commit-msg hook.
# Wire it (user scope, ~/.claude/settings.json → hooks.PreToolUse):
#   {"matcher":"Bash","hooks":[{"type":"command","command":"\"$HOME/.claude/hooks/no-ai-attribution.sh\"","timeout":10}]}
pattern='^[[:space:]]*co-authored-by:.*(claude|anthropic|openai|chatgpt|codex|gemini|copilot|aider|cursor|gpt-[0-9]|noreply@anthropic\.com)|generated (with|by) \[?(claude|codex|gemini|copilot|aider|cursor|chatgpt|ai\b)|🤖|claude\.ai/code'
cmd=$(jq -r '.tool_input.command // empty')
[ -n "$cmd" ] || exit 0

# Only commands that publish authored text.
printf '%s\n' "$cmd" | grep -qE '(^|[;&|(`[:space:]])(git([[:space:]]+-[cC][[:space:]]+[^[:space:]]+)*[[:space:]]+(commit|tag|notes)|gh[[:space:]]+(pr|issue|release|api|gist))([[:space:]]|$)' || exit 0

# Message files passed by flag (-F/--file/--body-file/-t/--template).
files=$(printf '%s\n' "$cmd" | grep -oE '(-F|--file|--body-file|-t|--template)[[:space:]=]+[^[:space:];&|]+' |
  sed -E 's/^(-F|--file|--body-file|-t|--template)[[:space:]=]+//; s/^["'\'']//; s/["'\'']$//')

hits=$(printf '%s\n' "$cmd" | grep -v '^#' | grep -iE "$pattern")
for f in $files; do
  # shellcheck disable=SC2088 # matching a literal ~/ from the command text
  case "$f" in "~/"*) f="$HOME/${f#\~/}" ;; esac
  [ -f "$f" ] && hits="$hits$(grep -v '^#' "$f" | grep -iE "$pattern")"
done
[ -z "$hits" ] && exit 0

{
  echo "Blocked: AI attribution is not allowed in commits, PRs, issues or comments (~/.claude/CLAUDE.md: No AI attribution, anywhere)."
  echo "Remove these lines and retry:"
  printf '%s\n' "$hits" | sed 's/^/  /'
} >&2
exit 2
