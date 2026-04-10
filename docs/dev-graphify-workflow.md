# Dev Projects — Graphify Workflow

All projects in `C:\Users\lucas\dev` are graphified. Read `GRAPH_REPORT.md` first, query the graph, only open raw files as last resort.

## Project Root

```
C:\Users\lucas\dev\
  bvp-betting\           graphify-out\ ✓
  csci3172\              graphify-out\ ✓
  cv\                    graphify-out\ ✓
  fantasy-draft-lottery-simulator\  graphify-out\ ✓
  mlb-cfr\               graphify-out\ ✓
  nba-dynasty-rankings\  graphify-out\ ✓
  pride-stem-combined\   graphify-out\ ✓
  tpdl-lottery\          graphify-out\ ✓
  valentine\             graphify-out\ ✓
  what-do-i-need-on-my-final\  graphify-out\ ✓
  yrfi\                  graphify-out\ ✓
  knowledge\             graphify-out\ ✓  ← master cross-project graph (826n 1491e)
```

`knowledge\` contains Windows junction points to all 11 project folders. No file copies.

## Per-Project Commands

```bash
# Read the graph before touching any project
cat "C:\Users\lucas\dev\<project>\graphify-out\GRAPH_REPORT.md"

# Incremental update after code changes
cd "C:\Users\lucas\dev\<project>"
PYTHONUTF8=1 python -m graphify . --update --no-viz

# Full rebuild
PYTHONUTF8=1 python -m graphify . --no-viz

# Focused query
PYTHONUTF8=1 python -m graphify query "your question" \
  --graph "C:\Users\lucas\dev\<project>\graphify-out\graph.json" \
  --budget 1500
```

> **Windows note:** Always set `PYTHONUTF8=1` before running `graphify query` — the output contains Unicode characters that Windows' default cp1252 encoding can't handle.

## Master Graph (Cross-Project)

```bash
# Read master graph report
cat "C:\Users\lucas\dev\knowledge\graphify-out\GRAPH_REPORT.md"

# Query across all projects
PYTHONUTF8=1 python -m graphify query "your question" \
  --graph "C:\Users\lucas\dev\knowledge\graphify-out\graph.json" \
  --budget 2000

# Rebuild master graph after updating individual projects
cd "C:\Users\lucas\dev\knowledge"
PYTHONUTF8=1 python -m graphify . --update --no-viz
```

## Low-Token Rules

1. **Read `GRAPH_REPORT.md` first** — god nodes + community structure in one file.
2. **Use `graphify query` for specific questions** — BFS/DFS over the graph, not recursive file reads.
3. **Never dump `graph.json` into context** — it's a data file for programmatic traversal only.
4. **Open raw files only when graph summaries are insufficient.**
5. **Use `--update` not full rebuild** — only re-extracts changed files.
6. **Use `--budget 1500`** — caps query output at ~1500 tokens.
7. **Use the master graph for cross-project questions** — don't open multiple per-project graphs.

## Obsidian Visualization

All graphs are exported as Obsidian note sets into:
```
C:\Users\lucas\Documents\Obsidian\SecondBrain\graphify-vault\
  INDEX.md              ← start here
  _master\              ← 863-node cross-project graph
  bvp-betting\
  csci3172\
  ... (one folder per project)
```

Open `graphify-vault/` as a vault in Obsidian (or keep it inside SecondBrain). Use:
- **Graph view** — filter by folder to see one project's cluster
- **Canvas** — open any `graph.canvas` for the structured community layout
- **Search** — every node is a searchable `.md` note

### Rebuild Obsidian export after updating a graph

```bash
python - << 'EOF'
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
    communities = dict(communities)
    n = to_obsidian(G, communities, str(out_dir))
    to_canvas(G, communities, str(Path(out_dir) / 'graph.canvas'))
    print(f'{out_dir}: {n} notes')

VAULT = r"C:\Users\lucas\Documents\Obsidian\SecondBrain\graphify-vault"

# Re-export one project
export(r"C:\Users\lucas\dev\yrfi\graphify-out\graph.json", rf"{VAULT}\yrfi")

# Re-export master
export(r"C:\Users\lucas\dev\knowledge\graphify-out\graph.json", rf"{VAULT}\_master")
EOF
```

## Adding a New Project

```bash
# 1. Create .graphifyignore
cp "C:\Users\lucas\dev\bvp-betting\.graphifyignore" "C:\Users\lucas\dev\<new-project>\"

# 2. Build graph
cd "C:\Users\lucas\dev\<new-project>"
PYTHONUTF8=1 python -m graphify . --no-viz

# 3. Add junction to knowledge/
powershell -Command "New-Item -ItemType Junction -Path 'C:\Users\lucas\dev\knowledge\<new-project>' -Target 'C:\Users\lucas\dev\<new-project>'"

# 4. Rebuild master graph
cd "C:\Users\lucas\dev\knowledge"
PYTHONUTF8=1 python -m graphify . --update --no-viz
```
