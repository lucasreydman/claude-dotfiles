# L.L.O.Y.D.
### Logical Learning & Optimization Yield Director

> *The configuration layer that turns my Claude Code into a persistent, opinionated, always-improving co-pilot.*

The name has two references, and both are intentional.

**The obvious one:** J.A.R.V.I.S. — Tony Stark's AI in Iron Man. Not just a tool, but an intelligence that knew his systems, anticipated his needs, and made him sharper. L.L.O.Y.D. is that layer for Claude Code.

**The better one:** Lloyd Lee — Ari Gold's assistant in HBO's *Entourage*. Stanford MBA. Overqualified by design. Absorbs chaos without breaking composure. The one person Ari genuinely cannot operate without. He pushes back when it matters, stays when others would quit, and by the end runs the TV division of a top Hollywood agency. He didn't get there through charm — he got there through patience, intelligence, and strategic endurance.

That's the model. Not a yes-machine. An operator who handles everything, gets better over time, and earns the trust session by session.

**L** — *Logical* — structured workflows: TDD, plan-first, subagent-driven execution, verification gates  
**L** — *Learning* — persistent memory across sessions, lessons captured after every correction  
**O** — *Optimization* — 60+ skills that replace generic answers with expert-guided ones  
**Y** — *Yield* — every session produces better output than the last, compounding over time  
**D** — *Director* — orchestrates agents, MCP servers, tools, and context to get things done  

---

> **`~/.claude` IS the repo.** Never clone this to `~/dev/` or any other directory. All git operations (`pull`, `push`, `commit`) happen directly inside `~/.claude`. That folder is both the live Claude config and the git working copy.

## What's synced
- `CLAUDE.md` — global instructions, workflow rules, and skills quick-reference
- `settings.json` — permissions, MCP servers, plugins, update channel
- `skills/` — 60+ skills: superpowers framework, last30days, marketing/growth, design, dev tools
- `agents/` — pre-built agent role definitions (code-reader, verifier, searcher)
- `plugins/installed_plugins.json`
- `projects/*/memory/` — per-project memory files

## What's NOT synced
- `.credentials.json` (auth tokens)
- `history.jsonl`, `cache/`, `sessions/`, `plans/`, `todos/` and other ephemeral files
- `plugins/blocklist.json`, `plugins/install-counts-cache.json`, `plugins/known_marketplaces.json`

---

## Setup on a new machine

### 1. Clone the repo
```bash
cd ~/.claude
git init
git remote add origin https://github.com/lucasreydman/lloyd.git
git fetch origin
git checkout -b main --track origin/main
```

If `main` already exists locally:
```bash
git reset --hard origin/main
```

### 2. Install dependencies

**yt-dlp** (required for YouTube in last30days):
```bash
winget install yt-dlp.yt-dlp
```

**Ruflo** (multi-agent orchestration, requires Node.js 20+):
```bash
npm install -g ruflo@latest --omit=optional
```

### 3. Create `~/.bashrc` with API keys

```bash
export PYTHONUTF8=1
export PATH="$PATH:/c/Users/YOUR_USERNAME/AppData/Local/Microsoft/WinGet/Links"

# API Keys & Tokens
export GITHUB_PERSONAL_ACCESS_TOKEN=""   # github.com → Settings → Developer settings → PAT (scopes: repo, read:org, read:user)
export BRAVE_API_KEY=""                  # api.search.brave.com — Brave Search free tier (1000 queries/mo)
export XAI_API_KEY=""                    # console.x.ai — X search (~$0.01-0.05 per research run, $5 in free credits/mo)
```

> Replace `YOUR_USERNAME` with your Windows username.

### 4. Create `~/.config/last30days/.env` with skill API keys

```bash
mkdir -p ~/.config/last30days
```

```
BRAVE_API_KEY=""
XAI_API_KEY=""
```

### 5. Activate keys in current session
```bash
source ~/.bashrc
```

### 6. Verify MCP servers
Run `/doctor` in Claude Code to confirm they're connected.

---

## last30days skill — working sources

The skill is configured to only hit sources that are confirmed working:

| Source | Requires | Notes |
|--------|----------|-------|
| X/Twitter | `XAI_API_KEY` + credits at console.x.ai | ~$0.01-0.05/run |
| YouTube | `yt-dlp` installed | Free, no key |
| Hacker News | Nothing | Free, always works |
| Polymarket | Nothing | Free, always works |
| Brave web search | `BRAVE_API_KEY` | Free tier: 1000 queries/mo |
| Claude WebSearch | Nothing | Built-in, runs after script |

---

## MCP Servers (auto-configured)

Defined in `settings.json`, available in every project:
- **context7** — injects up-to-date library docs into your session
- **playwright** — browser automation and UI testing via natural language
- **github** — read repos, open issues, create PRs (requires `GITHUB_PERSONAL_ACCESS_TOKEN`)
- **ruflo** — multi-agent orchestration: spawn Claude swarms, coordinate parallel tasks (requires `npm install -g ruflo@latest --omit=optional`)

---

## Skills
- **superpowers** — full workflow framework: TDD, git worktrees, planning, debugging, code review
- **last30days** — multi-platform research engine (YouTube, HN, Polymarket, Brave web search; X/Twitter with XAI_API_KEY)
- **60+ skills** across marketing/growth, design, documents, and dev tools — see `skills/` directory or the Skills Quick Reference in `CLAUDE.md`

## Agents
Pre-built subagent role definitions in `agents/`, wired into CLAUDE.md:
- **code-reader** — read-only codebase exploration
- **verifier** — runs tests, builds, linting after implementation
- **searcher** — web research and documentation lookup

---

## Day-to-day sync

```bash
# After changing skills/config:
git add -p && git commit -m "update" && git push

# On other machine:
git pull
source ~/.bashrc
```

## Notes
- Per-project memory paths encode the full project path (e.g., `C--Users-lucas-dev`). Both machines should use the same username and project root for memory to auto-resolve.
- `~/.bashrc` and `~/.config/last30days/.env` are intentionally NOT committed — add API keys manually on each machine.
- `plugins/known_marketplaces.json` is gitignored — it's auto-generated with machine-specific paths and regenerates automatically.
