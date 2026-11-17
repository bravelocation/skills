#!/usr/bin/env bash

# Codex PreToolUse hook: keep raw xcodebuild build/test output out of context.
# Adapted from Antoine van der Lee's article:
# https://www.avanderlee.com/ai-development/agent-hooks-claude-code-cursor-codex/
# Fail open if the event payload cannot be inspected.

if ! command -v jq >/dev/null 2>&1; then
  exit 0
fi

input=$(cat) || exit 0
command=$(jq -er '.tool_input.command | strings' <<<"$input" 2>/dev/null) || exit 0

if [[ "$command" == *xcodebuild* \
  && "$command" =~ (^|[[:space:]])(build|test)([[:space:]]|$) \
  && "$command" != *xcsift* ]]; then
  cat >&2 <<EOF
Raw xcodebuild build/test command blocked to keep build output concise.
Rerun it through xcsift:
set -o pipefail; $command 2>&1 | xcsift -f toon -w
EOF
  exit 2
fi

exit 0
