# claude-dotfiles

Syncs `~/.claude` config across machines — skills, CLAUDE.md, settings, MCP servers, plugins, and per-project memory.

## What's synced
- `CLAUDE.md` — global Claude instructions and workflow rules
- `settings.json` — permissions, MCP servers, plugins, update channel
- `skills/` — custom skills (including full last30days research skill)
- `plugins/installed_plugins.json`, `plugins/known_marketplaces.json`
- `projects/*/memory/` — per-project memory files

## What's NOT synced
- `.credentials.json` (auth tokens)
- `history.jsonl`, `cache/`, `sessions/`, `plans/`, `todos/` and other ephemeral files
- `plugins/blocklist.json`, `plugins/install-counts-cache.json`

## Setup on a new machine

### 1. Clone the repo
```bash
cd ~/.claude
git init
git remote add origin https://github.com/lucasreydman/claude-dotfiles.git
git fetch origin
git checkout -b main --track origin/main
```

If `main` already exists locally:
```bash
git reset --hard origin/main
```

### 2. Install dependencies
The `last30days` skill requires Python 3 and yt-dlp:
```bash
pip install yt-dlp
```

Ruflo (agent orchestration) requires Node.js 20+:
```bash
npm install -g ruflo@latest --omit=optional
```

### 3. Configure API keys for last30days skill
Create `~/.config/last30days/.env`:
```bash
mkdir -p ~/.config/last30days
touch ~/.config/last30days/.env
```

Add your keys:
```
XAI_API_KEY=...              # console.x.ai — X/Twitter search
BSKY_HANDLE=...              # your handle e.g. you.bsky.social
BSKY_APP_PASSWORD=...        # bsky.app → Settings → App Passwords
BRAVE_API_KEY=...            # api.search.brave.com — enhanced web search (optional)
```

### 4. Set GitHub token for GitHub MCP
Add to your shell profile or the `.env` file above:
```
GITHUB_PERSONAL_ACCESS_TOKEN=...  # github.com → Settings → Developer settings → PAT
```

### 5. Verify MCP servers
MCP servers are pre-configured in `settings.json` with the Windows `cmd /c` wrapper.
Run `/doctor` in Claude Code to confirm they're connected.

## MCP Servers (auto-configured)
Defined in `settings.json`, available in every project:
- **context7** — injects up-to-date library docs into your session
- **playwright** — browser automation and UI testing via natural language
- **github** — read repos, open issues, create PRs (requires `GITHUB_PERSONAL_ACCESS_TOKEN`)
- **ruflo** — multi-agent orchestration: spawn Claude swarms, coordinate parallel tasks, RAG memory (requires `npm install -g ruflo@latest --omit=optional`)

## Skills
- **superpowers** — full workflow framework: TDD, git worktrees, planning, debugging, code review
- **last30days** — multi-platform research engine (YouTube, HN, Polymarket, Brave web search; X/Twitter with XAI_API_KEY)
- 40+ other skills — see `skills/` directory

## Day-to-day

```bash
# After changing skills/config:
git add -p && git commit -m "update skills" && git push

# On other machine:
git pull --rebase
```

## Notes
- Per-project memory paths encode the full project path (e.g., `C--Users-lucas-dev`). Both machines should use the same username and project root for memory to auto-resolve.
- The `.env` file with API keys is intentionally NOT committed — add it manually on each machine.
- The GitHub PAT is stored in `~/.claude.json` (user-scoped MCP config) and referenced via env var in `settings.json`.
