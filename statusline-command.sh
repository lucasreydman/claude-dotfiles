#!/usr/bin/env bash
# L.L.O.Y.D. Status Line — Logical Learning & Optimization Yield Director
#
# Output: ◈ L·L·O·Y·D  ⟩  .claude (main)  ⟩  sonnet-4-6  ⟩  ████████░░ 78%  ⟩  ◆ Bash  ⟩  12 calls  ⟩  34m

STATE="$HOME/.claude/statusline-state.json"
input=$(cat)

# ── ANSI codes ───────────────────────────────────────────────────────────────
R=$'\033[0m'            # reset
MAGENTA=$'\033[1;35m'   # bold magenta  — L·L·O·Y·D brand
BLUE=$'\033[1;34m'      # bold blue     — folder / branch
CYAN_DIM=$'\033[2;36m'  # dim cyan      — model name
CYAN=$'\033[1;36m'      # bold cyan     — active tool
GREEN=$'\033[0;32m'     # green         — context < 60%
YELLOW=$'\033[0;33m'    # yellow        — context 60–84%
RED=$'\033[1;31m'       # bold red      — context ≥ 85%
WHITE=$'\033[0;37m'     # white         — counters
DIM=$'\033[2;37m'       # dim white     — separators / parens

SEP="${DIM} ⟩${R} "

# ── Parse stdin JSON ─────────────────────────────────────────────────────────
cwd=$(printf '%s' "$input"   | jq -r '.workspace.current_dir // .cwd // ""')
model=$(printf '%s' "$input" | jq -r '.model.display_name // ""')
used_pct=$(printf '%s' "$input" | jq -r '.context_window.used_percentage // empty')

# ── Parse state file ─────────────────────────────────────────────────────────
active_tool="" tool_calls=0 session_start=0
if [ -f "$STATE" ]; then
  active_tool=$(jq -r '.active_tool // ""'   "$STATE" 2>/dev/null || true)
  tool_calls=$(jq -r  '.tool_calls // 0'     "$STATE" 2>/dev/null || echo 0)
  session_start=$(jq -r '.session_start // 0' "$STATE" 2>/dev/null || echo 0)
fi

# ── Auto-reset if session > 5 hours ─────────────────────────────────────────
now=$(date +%s)
if [ "$session_start" -gt 0 ] 2>/dev/null; then
  age=$(( now - session_start ))
  if [ "$age" -gt 18000 ]; then
    session_start=0; tool_calls=0; active_tool=""
  fi
fi

# ── Derived values ────────────────────────────────────────────────────────────
folder=$(basename "$cwd")

branch=""
if [ -n "$cwd" ] && git -C "$cwd" rev-parse --git-dir >/dev/null 2>&1; then
  branch=$(git -C "$cwd" -c core.fsmonitor=false symbolic-ref --short HEAD 2>/dev/null \
        || git -C "$cwd" -c core.fsmonitor=false rev-parse --short HEAD 2>/dev/null || true)
fi

# Shorten model: "Claude Sonnet 4.6" → "sonnet-4.6", "claude-sonnet-4-6" → "sonnet-4-6"
short_model=""
if [ -n "$model" ]; then
  short_model=$(printf '%s' "$model" \
    | sed 's/^[Cc]laude[- ]//' \
    | tr '[:upper:]' '[:lower:]' \
    | tr ' ' '-')
fi

# Context bar (10 chars: █ filled, ░ empty)
bar=""
if [ -n "$used_pct" ]; then
  pct=$(printf "%.0f" "$used_pct" 2>/dev/null || echo 0)
  filled=$(( pct * 10 / 100 ))
  [ "$filled" -gt 10 ] && filled=10
  empty=$(( 10 - filled ))

  bar_filled="" bar_empty=""
  for ((i=0; i<filled; i++)); do bar_filled="${bar_filled}█"; done
  for ((i=0; i<empty;  i++)); do bar_empty="${bar_empty}░";  done

  if   [ "$pct" -ge 85 ]; then bar_color="$RED"
  elif [ "$pct" -ge 60 ]; then bar_color="$YELLOW"
  else                          bar_color="$GREEN"
  fi

  bar="${bar_color}${bar_filled}${bar_empty} ${pct}%${R}"
fi

# Active tool with glyph
tool_str=""
if [ -n "$active_tool" ]; then
  case "$active_tool" in
    Bash)              glyph="◆" ;;
    Read)              glyph="⊞" ;;
    Grep|Glob)         glyph="⌕" ;;
    Write)             glyph="⊕" ;;
    Edit)              glyph="⊗" ;;
    Agent)             glyph="↗" ;;
    WebSearch|WebFetch) glyph="⊛" ;;
    *)                 glyph="⊙" ;;
  esac
  tool_str="${CYAN}${glyph} ${active_tool}${R}"
fi

# Elapsed time since session start
elapsed=""
if [ "$session_start" -gt 0 ] 2>/dev/null; then
  secs=$(( now - session_start ))
  if [ "$secs" -ge 3600 ]; then
    elapsed="$(( secs / 3600 ))h$(( (secs % 3600) / 60 ))m"
  elif [ "$secs" -ge 60 ]; then
    elapsed="$(( secs / 60 ))m"
  else
    elapsed="${secs}s"
  fi
fi

# ── Assemble parts ────────────────────────────────────────────────────────────
parts=()

# Brand
parts+=("${MAGENTA}◈ L·L·O·Y·D${R}")

# Location: folder (branch)
loc="${BLUE}${folder}${R}"
[ -n "$branch" ] && loc="${loc} ${DIM}(${branch})${R}"
parts+=("$loc")

# Model (shortened)
[ -n "$short_model" ] && parts+=("${CYAN_DIM}${short_model}${R}")

# Context window bar
[ -n "$bar" ] && parts+=("$bar")

# Active tool
[ -n "$tool_str" ] && parts+=("$tool_str")

# Tool call count
[ "${tool_calls:-0}" -gt 0 ] && parts+=("${WHITE}${tool_calls} calls${R}")

# Elapsed time
[ -n "$elapsed" ] && parts+=("${WHITE}${elapsed}${R}")

# ── Output ────────────────────────────────────────────────────────────────────
printf '%s' "${parts[0]}"
for part in "${parts[@]:1}"; do
  printf '%s%s' "$SEP" "$part"
done
printf '\n'
