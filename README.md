# L.L.O.Y.D.
### Logical Learning & Optimization Yield Director

> *The configuration layer that turns Claude Code into a persistent, opinionated, always-improving co-pilot.*

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

> **Customize these values before you start:**
> - `YOUR_USERNAME` — your OS username (e.g. `lucas` on Windows, `lucasreydman` on Mac)
> - `YOUR_GITHUB_USERNAME` — your GitHub handle (e.g. `lucasreydman`)
> - `YOUR_DEV_FOLDER` — where your code projects live (e.g. `C:\Users\YOUR_USERNAME\dev` on Windows, `~/dev` on Mac/Linux)
> - `YOUR_OBSIDIAN_VAULT` — path to your Obsidian vault (e.g. `C:\Users\YOUR_USERNAME\Documents\Obsidian\MyVault`)

### 0. Fork this repo first

Go to [github.com/lucasreydman/lloyd](https://github.com/lucasreydman/lloyd) and click **Fork**. This gives you your own copy to customize and sync across machines.

### 1. Clone your fork into `~/.claude`

**Windows (Git Bash / WSL):**
```bash
cd ~/.claude
git init
git remote add origin https://github.com/YOUR_GITHUB_USERNAME/lloyd.git
git fetch origin
git checkout -b main --track origin/main
```

**Mac / Linux:**
```bash
cd ~/.claude
git init
git remote add origin https://github.com/YOUR_GITHUB_USERNAME/lloyd.git
git fetch origin
git checkout -b main --track origin/main
```

If `main` already exists locally:
```bash
git reset --hard origin/main
```

### 2. Install dependencies

**yt-dlp** (required for YouTube in last30days):

*Windows:*
```bash
winget install yt-dlp.yt-dlp
```
*Mac:*
```bash
brew install yt-dlp
```
*Linux:*
```bash
pip install yt-dlp
```

**Ruflo** (multi-agent orchestration, requires Node.js 20+):
```bash
npm install -g ruflo@latest --omit=optional
```

### 3. Create `~/.bashrc` with API keys

**Windows (`~/.bashrc`):**
```bash
export PYTHONUTF8=1
export PATH="$PATH:/c/Users/YOUR_USERNAME/AppData/Local/Microsoft/WinGet/Links"

# API Keys & Tokens
export GITHUB_PERSONAL_ACCESS_TOKEN=""   # github.com → Settings → Developer settings → PAT (scopes: repo, read:org, read:user)
export BRAVE_API_KEY=""                  # api.search.brave.com — Brave Search free tier (1000 queries/mo)
export XAI_API_KEY=""                    # console.x.ai — X search (~$0.01-0.05 per research run, $5 in free credits/mo)
```

**Mac / Linux (`~/.zshrc` or `~/.bashrc`):**
```bash
# API Keys & Tokens
export GITHUB_PERSONAL_ACCESS_TOKEN=""
export BRAVE_API_KEY=""
export XAI_API_KEY=""
```

> Replace `YOUR_USERNAME` with your OS username.

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
source ~/.bashrc   # or source ~/.zshrc on Mac
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
- **context-mode** — switches Claude's context handling mode per session

---

## Skills
- **superpowers** — full workflow framework: TDD, git worktrees, planning, debugging, code review
- **last30days** — multi-platform research engine (YouTube, HN, Polymarket, Brave web search; X/Twitter with XAI_API_KEY)
- **59 skills** across marketing/growth, design, documents, and dev tools — see `skills/` directory or run `/lloyd` for the full grouped reference

## Agents
Pre-built subagent role definitions in `agents/`, wired into CLAUDE.md:
- **code-reader** — read-only codebase exploration
- **verifier** — runs tests, builds, linting after implementation
- **searcher** — web research and documentation lookup

---

## Graphify — Knowledge Graph + Obsidian Visualization

Graphify turns your projects and Obsidian vault into a persistent knowledge graph. Claude reads `GRAPH_REPORT.md` and runs focused `graphify query` calls before raw file searches — dramatically reducing token usage per session. The graphs are also exported as wikilinked Obsidian notes, visible as a node cluster in Obsidian's Graph View and Canvas.

### What it does

- **Per-project graphs** — every project folder gets its own `graphify-out/GRAPH_REPORT.md` and `graph.json`
- **Master cross-project graph** — a `knowledge/` folder with junction/symlinks combines all projects into one graph
- **Obsidian visualization** — all graphs exported as `.md` notes + `graph.canvas` into your Obsidian vault
- **Auto-pull hook** — PreToolUse hook fires on every Glob/Grep, directing Claude to read the graph before scanning raw files

### Paths (replace with your own)

| Purpose | Windows | Mac / Linux |
|---------|---------|-------------|
| Dev projects | `C:\Users\YOUR_USERNAME\dev\` | `~/dev/` |
| Master graph | `YOUR_DEV_FOLDER\knowledge\graphify-out\` | `~/dev/knowledge/graphify-out/` |
| Obsidian vault | `C:\Users\YOUR_USERNAME\Documents\Obsidian\YourVault` | `~/Documents/Obsidian/YourVault` |
| Obsidian visualization | `YOUR_OBSIDIAN_VAULT\graphify-vault\` | `~/Documents/Obsidian/YourVault/graphify-vault/` |

### Install on a new machine

```bash
pip install graphifyy
python -m graphify install          # registers /graphify skill in ~/.claude
python -m graphify claude install   # adds CLAUDE.md section + PreToolUse hook
```

### Graph a project (first time)

Graphify is built and updated via the `/graphify` Claude Code skill — **not** the raw CLI. The CLI does not support a path argument.

1. Create a `.graphifyignore` in your project root (copy from any existing graphified project, or use this baseline):
   ```
   node_modules/
   dist/
   build/
   .next/
   coverage/
   .git/
   *.log
   *.png *.jpg *.jpeg *.gif *.mp4 *.zip
   graphify-out/
   ```

2. In Claude Code, run:
   ```
   /graphify YOUR_DEV_FOLDER/your-project
   ```
   Or navigate to the project folder first and run `/graphify` with no arguments.

Claude will run the full pipeline (detect → AST extraction → semantic extraction → build → cluster) and output `graphify-out/GRAPH_REPORT.md` and `graphify-out/graph.json`.

> **Windows note:** Always prefix `graphify query` with `PYTHONUTF8=1` — output contains Unicode characters (λ, →) that Windows' default cp1252 encoding can't handle. On Mac/Linux this is not needed, but it's harmless to include.

### Update an existing graph

In Claude Code:
```
/graphify YOUR_DEV_FOLDER/your-project --update    # incremental — only re-extracts changed files
/graphify YOUR_DEV_FOLDER/your-project             # full rebuild
```

### Query the graph (low-token)

```bash
PYTHONUTF8=1 python -m graphify query "your question" \
  --graph "YOUR_DEV_FOLDER/your-project/graphify-out/graph.json" \
  --budget 1500

# Cross-project question:
PYTHONUTF8=1 python -m graphify query "your question" \
  --graph "YOUR_DEV_FOLDER/knowledge/graphify-out/graph.json" \
  --budget 2000
```

### Set up the master cross-project graph

**Windows (PowerShell):**
```powershell
mkdir "C:\Users\YOUR_USERNAME\dev\knowledge"

# Add junction points for each project:
New-Item -ItemType Junction -Path "C:\Users\YOUR_USERNAME\dev\knowledge\your-project" -Target "C:\Users\YOUR_USERNAME\dev\your-project"
# Repeat for each project

# Add .graphifyignore (same baseline as per-project, also exclude graphify-out/)
# Then build via Claude Code skill (not CLI):
```

**Mac / Linux:**
```bash
mkdir ~/dev/knowledge

# Add symlinks for each project:
ln -s ~/dev/your-project ~/dev/knowledge/your-project
# Repeat for each project

# Add .graphifyignore
```

Then in Claude Code, run `/graphify YOUR_DEV_FOLDER/knowledge` to build the master graph.

### Export to Obsidian (generate the visual cluster)

Run this Python snippet to export all graphs as wikilinked notes into your Obsidian vault.

> **Customize before running:** Replace `YOUR_OBSIDIAN_VAULT`, `YOUR_DEV_FOLDER`, and `YOUR_PROJECTS` with your actual paths and project folder names.

```python
import json
from collections import defaultdict
from networkx.readwrite import json_graph
from graphify.export import to_obsidian, to_canvas
from pathlib import Path

def export(graph_path, out_dir):
    data = json.loads(Path(graph_path).read_text(encoding='utf-8'))
    G = json_graph.node_link_graph(data, edges='links')
    communities = defaultdict(list)
    for nid, attrs in G.nodes(data=True):
        communities[int(attrs.get('community', 0))].append(nid)
    n = to_obsidian(G, dict(communities), str(out_dir))
    to_canvas(G, dict(communities), str(Path(out_dir) / 'graph.canvas'))
    print(f'{Path(out_dir).name}: {n} notes')

# --- CUSTOMIZE THESE ---
DEV_FOLDER = r"C:\Users\YOUR_USERNAME\dev"          # Windows: r"C:\Users\...", Mac/Linux: "/Users/.../dev"
VAULT = r"C:\Users\YOUR_USERNAME\Documents\Obsidian\YourVault\graphify-vault"

YOUR_PROJECTS = [
    "your-project-1",
    "your-project-2",
    # add all your project folder names here
]
# -----------------------

for p in YOUR_PROJECTS:
    export(rf"{DEV_FOLDER}\{p}\graphify-out\graph.json", rf"{VAULT}\{p}")

# Export master cross-project graph
export(rf"{DEV_FOLDER}\knowledge\graphify-out\graph.json", rf"{VAULT}\_master")
```

**To see the cluster in Obsidian:**
- Open your vault → navigate to `graphify-vault/`
- Open any `graph.canvas` for the interactive community layout
- Use Obsidian's **Graph View** (sidebar) to see the full wikilink cluster — filter by folder to zoom into one project
- `graphify-vault/_master/graph.canvas` shows all projects combined

### Low-token rules for Claude

1. Read `graphify-out/GRAPH_REPORT.md` before touching any project
2. Use `graphify query` for specific questions — never grep raw files first
3. Never dump `graph.json` into context
4. Open raw files only when graph summaries are insufficient
5. Use `--update` not full rebuild unless the project changed significantly
6. For cross-project questions, use the master graph at `knowledge/graphify-out/`

### Workflow docs

- `docs/graphify-obsidian-workflow.md` — Obsidian vault setup
- `docs/dev-graphify-workflow.md` — dev projects, master graph, adding new projects

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
- Per-project memory paths encode the full project path (e.g., `C--Users-YOUR_USERNAME-dev-your-project`). Both machines should use the same username and project root for memory to auto-resolve across devices.
- `~/.bashrc` and `~/.config/last30days/.env` are intentionally NOT committed — add API keys manually on each machine.
- `plugins/known_marketplaces.json` is gitignored — it's auto-generated with machine-specific paths and regenerates automatically.
- The CLAUDE.md graphify section and `.claude/settings.json` hook will contain your machine-specific paths after running `python -m graphify claude install`. Update these manually if your paths differ between machines.
