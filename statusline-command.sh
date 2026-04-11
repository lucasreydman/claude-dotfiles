#!/usr/bin/env bash
input=$(cat)

# Extract fields
cwd=$(echo "$input" | jq -r '.workspace.current_dir // .cwd // ""')
model=$(echo "$input" | jq -r '.model.display_name // ""')
used_pct=$(echo "$input" | jq -r '.context_window.used_percentage // empty')

# Folder: just the basename
folder=$(basename "$cwd")

# Git branch (skip optional locks)
branch=""
if git -C "$cwd" rev-parse --git-dir > /dev/null 2>&1; then
  branch=$(git -C "$cwd" -c core.fsmonitor=false symbolic-ref --short HEAD 2>/dev/null || git -C "$cwd" -c core.fsmonitor=false rev-parse --short HEAD 2>/dev/null)
fi

# Context progress bar (10 chars wide)
bar=""
if [ -n "$used_pct" ]; then
  filled=$(printf "%.0f" "$(echo "$used_pct * 10 / 100" | bc -l 2>/dev/null || echo 0)")
  filled=${filled:-0}
  empty=$((10 - filled))
  bar_filled=$(printf '%0.s#' $(seq 1 $filled 2>/dev/null) 2>/dev/null || true)
  bar_empty=$(printf '%0.s-' $(seq 1 $empty 2>/dev/null) 2>/dev/null || true)
  bar_pct=$(printf "%.0f" "$used_pct")
  bar="[${bar_filled}${bar_empty}] ${bar_pct}%"
fi

# Build output parts
parts=()

# Folder
parts+=("$folder")

# Branch
if [ -n "$branch" ]; then
  parts+=("($branch)")
fi

# Model
if [ -n "$model" ]; then
  parts+=("$model")
fi

# Context bar
if [ -n "$bar" ]; then
  parts+=("$bar")
fi

# Join with separator
printf '%s' "${parts[0]}"
for part in "${parts[@]:1}"; do
  printf ' | %s' "$part"
done
printf '\n'
