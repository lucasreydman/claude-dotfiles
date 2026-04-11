#!/usr/bin/env bash
# PreToolUse hook — update L.L.O.Y.D. status line state
# Tracks: active tool, running tool-call count, session start time

STATE="$HOME/.claude/statusline-state.json"
input=$(cat)
tool=$(printf '%s' "$input" | jq -r '.tool_name // ""' 2>/dev/null || echo "")
now=$(date +%s)

# Read current state
current_start=0
current_calls=0
if [ -f "$STATE" ]; then
  current_start=$(jq -r '.session_start // 0' "$STATE" 2>/dev/null || echo 0)
  current_calls=$(jq -r '.tool_calls // 0' "$STATE" 2>/dev/null || echo 0)
fi

# Init or reset session if > 5 hours old
age=$(( now - current_start ))
if [ "$current_start" -eq 0 ] || [ "$age" -gt 18000 ]; then
  current_start=$now
  current_calls=0
fi

new_calls=$(( current_calls + 1 ))

# Atomic write via temp file
tmp=$(mktemp 2>/dev/null) || tmp="/tmp/lloyd-state-$$.tmp"
jq -n \
  --argjson start "$current_start" \
  --arg tool "$tool" \
  --argjson calls "$new_calls" \
  '{session_start: $start, active_tool: $tool, tool_calls: $calls}' \
  > "$tmp" 2>/dev/null && mv "$tmp" "$STATE" 2>/dev/null || true
