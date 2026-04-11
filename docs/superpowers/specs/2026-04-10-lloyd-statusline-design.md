# L.L.O.Y.D. Status Line — Design Spec

**Date:** 2026-04-10  
**Status:** Implemented

## Goal

Upgrade the Claude Code status line from a plain text readout to a visually branded, color-coded, information-dense bar that reflects L.L.O.Y.D.'s identity and provides real session context at a glance.

## Output Format

```
◈ L·L·O·Y·D  ⟩  .claude (main)  ⟩  sonnet-4-6  ⟩  ████████░░ 78%  ⟩  ◆ Bash  ⟩  12 calls  ⟩  34m
```

Fields (left to right):
1. **Brand** — `◈ L·L·O·Y·D` in bold magenta
2. **Location** — `folder (branch)` in bold blue, branch dim white
3. **Model** — shortened name (strip "claude-" prefix) in dim cyan
4. **Context bar** — 10-char `█░` bar + percentage, color-coded by threshold
5. **Active tool** — glyph + tool name in bold cyan (from state file)
6. **Tool calls** — running count in white (from state file)
7. **Elapsed** — time since session start in white (from state file)

Fields that have no data are omitted automatically.

## Color Scheme

| Element | ANSI | Meaning |
|---------|------|---------|
| `◈ L·L·O·Y·D` | bold magenta | Brand identity |
| `folder (branch)` | bold blue / dim white | Location |
| `model` | dim cyan | Capability tier |
| Context bar 0–59% | green | Healthy |
| Context bar 60–84% | yellow | Getting full |
| Context bar 85–100% | bold red | Near limit |
| Active tool | bold cyan | What Claude is doing |
| Counters | white | Session metrics |
| `⟩` separators | dim white | Visual flow |

## Tool Glyphs

| Tool | Glyph |
|------|-------|
| Bash | ◆ |
| Read | ⊞ |
| Grep / Glob | ⌕ |
| Write | ⊕ |
| Edit | ⊗ |
| Agent | ↗ |
| WebSearch / WebFetch | ⊛ |
| Other | ⊙ |

## State File Architecture

**Path:** `~/.claude/statusline-state.json` (gitignored, auto-created)

```json
{
  "session_start": 1712765432,
  "active_tool": "Bash",
  "tool_calls": 12
}
```

- **Persists across terminals** — elapsed time and call count survive new windows
- **Auto-resets after 5 hours** — detected in both hook and statusline script
- **Atomic writes** — temp file + `mv` to avoid partial reads

## Hook Architecture

Two global hooks in `settings.json`:

| Hook | Matcher | Script | Action |
|------|---------|--------|--------|
| PreToolUse | `.*` | `hooks/pre-tool-use.sh` | Set `active_tool`, increment `tool_calls`, init `session_start` |
| PostToolUse | `.*` | `hooks/post-tool-use.sh` | Clear `active_tool` |

These are global (in `~/.claude/settings.json`) so they run in every project.  
The graphify hooks remain in `.claude/settings.json` (project-level for `~/.claude`) and are unaffected.

## Files

| File | Purpose |
|------|---------|
| `statusline-command.sh` | Main status line renderer (rewritten) |
| `hooks/pre-tool-use.sh` | PreToolUse hook — updates state file |
| `hooks/post-tool-use.sh` | PostToolUse hook — clears active tool |
| `statusline-state.json` | Runtime state (gitignored) |

## Decisions

- **No session usage / weekly limit tracking** — server-side only, not accessible without API. Keeping the bar trustworthy.
- **5-hour auto-reset** — approximates Claude Pro's usage window; resets call count and elapsed time cleanly.
- **Single-line output** — Claude Code's statusLine renders one line; no multi-line support.
- **Model name shortening** — strip "claude-" prefix + lowercase to save space.
