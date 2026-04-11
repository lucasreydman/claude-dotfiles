#!/usr/bin/env bash
# PostToolUse hook — clear active tool from L.L.O.Y.D. status line state

STATE="$HOME/.claude/statusline-state.json"
[ -f "$STATE" ] || exit 0

tmp=$(mktemp 2>/dev/null) || tmp="/tmp/lloyd-state-$$.tmp"
jq '.active_tool = ""' "$STATE" > "$tmp" 2>/dev/null \
  && mv "$tmp" "$STATE" 2>/dev/null || true
