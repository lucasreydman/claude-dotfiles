# claude-dotfiles

Syncs `~/.claude` config across machines — skills, CLAUDE.md, settings, and per-project memory.

## What's synced
- `CLAUDE.md` — global Claude instructions
- `settings.json` — Claude Code config
- `skills/` — custom skills
- `plugins/installed_plugins.json`, `plugins/known_marketplaces.json`, `plugins/marketplaces/`
- `projects/*/memory/` — per-project memory

## What's NOT synced
- `.credentials.json` (auth tokens)
- `history.jsonl`, `cache/`, `sessions/`, and other ephemeral files

## Setup on a new machine

```bash
cd ~/.claude
git init
git remote add origin https://github.com/lucasreydman/claude-dotfiles.git
git fetch origin
git checkout -b main --track origin/main
```

If `main` branch already exists locally:
```bash
git reset --hard origin/main
```

## Day-to-day

```bash
# After changing skills/config:
git add -p && git commit -m "update skills" && git push

# On other machine:
git pull --rebase
```

## Notes
- Per-project memory paths encode the full project path (e.g., `C--Users-lucas-dev`). Both machines should use the same username and project root (`C:\Users\lucas\dev`) for memory to auto-resolve.
