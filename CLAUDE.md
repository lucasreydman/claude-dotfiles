## Workflow Orchestration

### 1. Plan Mode Default
- Enter plan mode for ANY non-trivial task (3+ steps or architectural decisions)
- If something goes sideways, STOP and re-plan immediately
- Write detailed specs upfront to reduce ambiguity

### 2. Subagent Strategy
- Use subagents liberally to keep main context window clean
- Offload research, exploration, and parallel analysis to subagents
- One task per subagent for focused execution

### 3. Self-Improvement Loop
- After ANY correction: update tasks/lessons.md with the pattern
- Write rules that prevent the same mistake
- Review lessons at session start for relevant project

### 4. Verification Before Done
- Never mark a task complete without proving it works
- Ask yourself: "Would a staff engineer approve this?"
- Run tests, check logs, demonstrate correctness

### 5. Demand Elegance (Balanced)
- For non-trivial changes: pause and ask "is there a more elegant way?"
- Skip for simple, obvious fixes — don't over-engineer

### 6. Autonomous Bug Fixing
- When given a bug report: just fix it. No hand-holding.
- Point at logs, errors, failing tests — then resolve them

### 7. Pre-built Agent Roles
When dispatching subagents, use these from `agents/`:
- **agents/code-reader.md** — read-only exploration, before implementation
- **agents/verifier.md** — runs tests/builds/linting, after implementation
- **agents/searcher.md** — web research and docs lookup

Pass file path + role to the Agent tool. Not skills — do not use the Skill tool.

## Task Management

1. **Plan First**: Write plan to tasks/todo.md with checkable items
2. **Verify Plan**: Check in before starting implementation
3. **Track Progress**: Mark items complete as you go
4. **Explain Changes**: High-level summary at each step
5. **Capture Lessons**: Update tasks/lessons.md after corrections

## Core Principles

- **Simplicity First**: Make every change as simple as possible. Impact minimal code.
- **No Laziness**: Find root causes. No temporary fixes. Senior developer standards.
- **Minimal Impact**: Only touch what's necessary. No side effects with new bugs.

## Skills

All 59 skills are listed in the system prompt. Run `/lloyd` for the full grouped reference.
Before answering in any specialist domain (marketing, design, docs, dev tools), invoke the relevant skill — generic answers are worse than skill-guided ones.

## graphify — Knowledge Graph

All dev projects and the Obsidian vault are graphified. Use the graph before searching raw files.

### Knowledge sources (in priority order)

| Scope | GRAPH_REPORT.md | graph.json | Obsidian canvas |
|-------|----------------|------------|-----------------|
| Current project | `<project>/graphify-out/GRAPH_REPORT.md` | `<project>/graphify-out/graph.json` | `SecondBrain/graphify-vault/<project>/graph.canvas` |
| Cross-project | `C:\Users\lucas\dev\knowledge\graphify-out\GRAPH_REPORT.md` | `...\knowledge\graphify-out\graph.json` | `SecondBrain/graphify-vault/_master/graph.canvas` |
| Obsidian vault | `C:\Users\lucas\Documents\Obsidian\SecondBrain\graphify-out\GRAPH_REPORT.md` | — | — |

### Rules
- **Before exploring any codebase**: read `graphify-out/GRAPH_REPORT.md` in that project first
- **Cross-project questions**: read `C:\Users\lucas\dev\knowledge\graphify-out\GRAPH_REPORT.md`
- **Focused queries** (prefer over raw grep): `PYTHONUTF8=1 python -m graphify query "<question>" --graph <path>/graph.json --budget 1500`
- **Never dump graph.json into context** — use `graphify query` for traversal
- **After code changes**: `PYTHONUTF8=1 python -m graphify . --update --no-viz` in the project dir
- **Projects with graphs**: bvp-betting, csci3172, cv, fantasy-draft-lottery-simulator, mlb-cfr, nba-dynasty-rankings, pride-stem-combined, tpdl-lottery, valentine, what-do-i-need-on-my-final, yrfi
