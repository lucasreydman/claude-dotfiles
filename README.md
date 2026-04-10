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

## Graphify — Knowledge Graph + Obsidian Visualization

Graphify turns every project and the Obsidian vault into a persistent knowledge graph. Claude reads `GRAPH_REPORT.md` and runs focused `graphify query` calls before raw file searches — dramatically reducing token usage per session. The graphs are also exported as wikilinked Obsidian notes, visible as a node cluster in Obsidian's Graph View and Canvas.

### What it does

- **Per-project graphs** — every folder in `C:\Users\lucas\dev` has its own `graphify-out\GRAPH_REPORT.md` and `graph.json`
- **Master cross-project graph** — `C:\Users\lucas\dev\knowledge\` (Windows junction points) combines all projects into one 826-node graph
- **Obsidian visualization** — all graphs exported as `.md` notes + `graph.canvas` into `SecondBrain\graphify-vault\`
- **Auto-pull hook** — PreToolUse hook fires on every Glob/Grep, directing Claude to read the graph before scanning raw files

### Paths (this machine)

| Purpose | Path |
|---------|------|
| Dev projects | `C:\Users\lucas\dev\` |
| Master graph | `C:\Users\lucas\dev\knowledge\graphify-out\` |
| Obsidian vault | `C:\Users\lucas\Documents\Obsidian\SecondBrain` |
| Obsidian visualization | `C:\Users\lucas\Documents\Obsidian\SecondBrain\graphify-vault\` |

### Install on a new machine

```bash
pip install graphifyy
python -m graphify install          # registers /graphify skill in ~/.claude
python -m graphify claude install   # adds CLAUDE.md section + PreToolUse hook
```

### Graph a project (first time)

```bash
cd "C:\Users\lucas\dev\<project>"

# Create .graphifyignore (copy from any existing project, or use this baseline):
# node_modules/ dist/ build/ .next/ coverage/ .git/ *.log *.png *.jpg *.jpeg *.gif *.mp4 *.zip graphify-out/

PYTHONUTF8=1 python -m graphify . --no-viz
```

Outputs: `graphify-out\GRAPH_REPORT.md` and `graphify-out\graph.json`.

> **Windows note:** Always prefix `graphify query` with `PYTHONUTF8=1` — output contains Unicode characters (λ, →) that Windows' default cp1252 encoding can't handle.

### Update an existing graph

```bash
cd "C:\Users\lucas\dev\<project>"
PYTHONUTF8=1 python -m graphify . --update --no-viz   # incremental — only re-extracts changed files
PYTHONUTF8=1 python -m graphify . --no-viz            # full rebuild
```

### Query the graph (low-token)

```bash
PYTHONUTF8=1 python -m graphify query "your question" \
  --graph "C:\Users\lucas\dev\<project>\graphify-out\graph.json" \
  --budget 1500

# Cross-project question:
PYTHONUTF8=1 python -m graphify query "your question" \
  --graph "C:\Users\lucas\dev\knowledge\graphify-out\graph.json" \
  --budget 2000
```

### Set up the master cross-project graph

```bash
mkdir "C:\Users\lucas\dev\knowledge"

# Add junction points for each project (PowerShell):
powershell -Command "New-Item -ItemType Junction -Path 'C:\Users\lucas\dev\knowledge\<project>' -Target 'C:\Users\lucas\dev\<project>'"

# Add .graphifyignore (same baseline as per-project, also exclude graphify-out/)
# Then build:
cd "C:\Users\lucas\dev\knowledge"
PYTHONUTF8=1 python -m graphify . --no-viz
```

### Export to Obsidian (generate the visual cluster)

Run this Python snippet to export all graphs as wikilinked notes into the SecondBrain vault:

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

VAULT = r"C:\Users\lucas\Documents\Obsidian\SecondBrain\graphify-vault"

projects = [
    "bvp-betting", "csci3172", "cv", "fantasy-draft-lottery-simulator",
    "mlb-cfr", "nba-dynasty-rankings", "pride-stem-combined", "tpdl-lottery",
    "valentine", "what-do-i-need-on-my-final", "yrfi"
]
for p in projects:
    export(rf"C:\Users\lucas\dev\{p}\graphify-out\graph.json", rf"{VAULT}\{p}")

export(r"C:\Users\lucas\dev\knowledge\graphify-out\graph.json", rf"{VAULT}\_master")
```

**To see the cluster in Obsidian:**
- Open the `SecondBrain` vault → navigate to `graphify-vault\`
- Open any `graph.canvas` for the interactive community layout
- Use Obsidian's **Graph View** (sidebar) to see the full wikilink cluster — filter by folder to zoom into one project
- `graphify-vault\_master\graph.canvas` shows all projects combined

### Low-token rules for Claude

1. Read `graphify-out\GRAPH_REPORT.md` before touching any project
2. Use `graphify query` for specific questions — never grep raw files first
3. Never dump `graph.json` into context
4. Open raw files only when graph summaries are insufficient
5. Use `--update` not full rebuild unless the project changed significantly
6. For cross-project questions, use the master graph at `knowledge\graphify-out\`

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
- Per-project memory paths encode the full project path (e.g., `C--Users-lucas-dev`). Both machines should use the same username and project root for memory to auto-resolve.
- `~/.bashrc` and `~/.config/last30days/.env` are intentionally NOT committed — add API keys manually on each machine.
- `plugins/known_marketplaces.json` is gitignored — it's auto-generated with machine-specific paths and regenerates automatically.
