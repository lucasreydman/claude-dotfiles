# Model Routing — Design Spec

**Date:** 2026-04-10  
**Status:** Implemented

## Goal

Automatically use the right Claude model for each task type — Opus for hard reasoning, Sonnet for implementation, Haiku for mechanical tasks — without manual `/model` switching. Saves quota, reduces latency, and reserves heavy models for decisions where they actually matter.

## Why This Matters

- **Haiku** is ~20x cheaper and significantly faster than Opus. Using it for file reads and test runs burns almost no quota.
- **Opus** produces meaningfully better output on complex reasoning tasks, but wastes that capability on mechanical work.
- **Sonnet** is the right default for interactive implementation — best balance of speed and capability.

## What Was Changed

### Agent frontmatter

| Agent | Model | Reason |
|-------|-------|--------|
| `agents/code-reader.md` | `haiku` | Pure file retrieval — no judgment needed |
| `agents/verifier.md` | `haiku` | Mechanical pass/fail checking |
| `agents/searcher.md` | `sonnet` | Web research requires synthesis and judgment |

### CLAUDE.md — `## Model Routing` section

Added explicit routing rules covering:
- Named agent dispatch (frontmatter locks model automatically)
- Ad-hoc Agent tool dispatch (explicit `model:` parameter rules)
- Hard rule: never use Opus when Sonnet suffices; never use Haiku for user-visible output

## Tier Reference

| Tier | Model | When |
|------|-------|------|
| Heavy | Opus | Architecture, spec review, hard debugging, high-stakes reasoning |
| Standard | Sonnet | Implementation, features, research synthesis, main session |
| Light | Haiku | File reads, test runs, linting, grep, mechanical verification |

## What Claude Cannot Do Automatically

- Switch the **main session** model mid-conversation (requires `/model` command from user)
- Change `effortLevel` at runtime

The main session stays on Sonnet (via `effortLevel: "medium"`). All automatic routing applies to **subagents** dispatched via the Agent tool.

## Files Changed

| File | Change |
|------|--------|
| `agents/code-reader.md` | Added `model: haiku` |
| `agents/verifier.md` | Added `model: haiku` |
| `agents/searcher.md` | Added `model: sonnet` |
| `CLAUDE.md` | Added `## Model Routing` section with tier table and dispatch rules |
| `README.md` | Added Agents section with model tier documentation |
