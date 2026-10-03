#!/usr/bin/env bash
# beforeShellExecution (git commit) : interdit de committer sur main/master.
# Créer une branche feature avant de committer.
set -euo pipefail

input=$(cat)
cmd=$(jq -r '.command // .tool_input.command // empty' <<<"$input")

grep -qE '(^|[;&|[:space:]])git commit\b' <<<"$cmd" || { echo '{ "permission": "allow" }'; exit 0; }
grep -qE -- '--dry-run' <<<"$cmd" && { echo '{ "permission": "allow" }'; exit 0; }

root=$(git rev-parse --show-toplevel 2>/dev/null || pwd)
cd "$root" || exit 0

branch=$(git branch --show-current 2>/dev/null || true)
# Detached HEAD : laisser passer (cas rare / CI locale)
[ -z "$branch" ] && { echo '{ "permission": "allow" }'; exit 0; }

case "$branch" in
  main|master)
    reason="Commit interdit sur la branche « ${branch} ». Créer une autre branche d'abord, par ex. : git switch -c feat/ma-feature"
    jq -n --arg reason "$reason" '{
      "permission": "deny",
      "user_message": $reason,
      "agent_message": $reason
    }'
    exit 0
    ;;
esac

echo '{ "permission": "allow" }'
exit 0
