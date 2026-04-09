## Workflow Orchestration

### 1. Plan Mode Default
- Enter plan mode for ANY non-trivial task (3+ steps or architectural decisions)
- If something goes sideways, STOP and re-plan immediately
- Use plan mode for verification steps, not just building
- Write detailed specs upfront to reduce ambiguity

### 2. Subagent Strategy
- Use subagents liberally to keep main context window clean
- Offload research, exploration, and parallel analysis to subagents
- For complex problems, throw more compute at it via subagents
- One task per subagent for focused execution

### 3. Self-Improvement Loop
- After ANY correction from the user: update tasks/lessons.md with the pattern
- Write rules for yourself that prevent the same mistake
- Ruthlessly iterate on these lessons until mistake rate drops
- Review lessons at session start for relevant project

### 4. Verification Before Done
- Never mark a task complete without proving it works
- Diff behavior between main and your changes when relevant
- Ask yourself: "Would a staff engineer approve this?"
- Run tests, check logs, demonstrate correctness

### 5. Demand Elegance (Balanced)
- For non-trivial changes: pause and ask "is there a more elegant way?"
- If a fix feels hacky: "Knowing everything I know now, implement the elegant solution"
- Skip this for simple, obvious fixes -- don't over-engineer
- Challenge your own work before presenting it

### 6. Autonomous Bug Fixing
- When given a bug report: just fix it. Don't ask for hand-holding
- Point at logs, errors, failing tests -- then resolve them
- Zero context switching required from the user
- Go fix failing CI tests without being told how

### 7. Pre-built Agent Roles
When dispatching subagents (via superpowers' subagent-driven-development or dispatching-parallel-agents skills), use these pre-built agent definitions from the `agents/` directory:
- **agents/code-reader.md** — read-only exploration: finding files, reading source, searching patterns. Use before implementation to understand existing code.
- **agents/verifier.md** — validation: runs tests, builds, linting. Use after implementation to confirm correctness.
- **agents/searcher.md** — research: web searches, documentation lookup. Use when gathering external context or library docs.

Dispatch these by passing their file path and role to the Agent tool. These are role definitions, not skills — do not invoke them via the Skill tool.

## Task Management

1. **Plan First**: Write plan to tasks/todo.md with checkable items
2. **Verify Plan**: Check in before starting implementation
3. **Track Progress**: Mark items complete as you go
4. **Explain Changes**: High-level summary at each step
5. **Document Results**: Add review section to tasks/todo.md
6. **Capture Lessons**: Update tasks/lessons.md after corrections

## Core Principles

- **Simplicity First**: Make every change as simple as possible. Impact minimal code.
- **No Laziness**: Find root causes. No temporary fixes. Senior developer standards.
- **Minimal Impact**: Only touch what's necessary. No side effects with new bugs.

## Skills Quick Reference

Before answering any question in these domains, invoke the relevant skill via the `Skill` tool. Generic answers are worse than skill-guided ones.

### Marketing & Growth
| Use when... | Skill |
|---|---|
| Writing landing page / homepage copy | `copywriting` |
| Improving existing copy | `copy-editing` |
| Planning content (blog, SEO topics) | `content-strategy` |
| SEO audit or technical SEO issues | `seo-audit` |
| Structured data / rich results | `schema-markup` |
| AI search optimization (ChatGPT, Perplexity) | `ai-seo` |
| Programmatic content at scale | `programmatic-seo` |
| Site structure / URL architecture | `site-architecture` |
| Paid ads (Google, Meta, LinkedIn) | `paid-ads` |
| A/B testing with statistical rigor | `ab-test-setup` |
| Signup or onboarding flow optimization | `signup-flow-cro` or `onboarding-cro` |
| Pricing / packaging decisions | `pricing-strategy` |
| Cold outbound email sequences | `cold-email` |
| Social media content | `social-content` |
| Product launch planning | `launch-strategy` |
| SaaS churn analysis / retention | `churn-prevention` |
| Referral or affiliate programs | `referral-program` |
| Competitor comparison pages | `competitor-alternatives` |
| Analytics / event tracking setup | `analytics-tracking` |
| Revenue ops / lead lifecycle | `revops` |
| Sales collateral / battle cards | `sales-enablement` |
| Behavioral psychology applied to UX | `marketing-psychology` |
| Brainstorming marketing tactics | `marketing-ideas` |

### Design & Frontend
| Use when... | Skill |
|---|---|
| Building production web UI | `frontend-design` |
| UI/UX decisions, color, typography | `ui-ux-pro-max` |
| Reviewing UI for accessibility/best practices | `web-design-guidelines` |
| Creating multi-component HTML artifacts | `web-artifacts-builder` |
| Generative / algorithmic art | `algorithmic-art` |
| Static poster / visual art | `canvas-design` |
| Applying a visual theme to an artifact | `theme-factory` |
| Video creation in React | `remotion-best-practices` |

### Documents
| Use when... | Skill |
|---|---|
| Creating or editing Word documents | `docx` |
| PDF manipulation (merge, split, extract) | `pdf` |
| Creating PowerPoint presentations | `pptx` |
| Spreadsheet creation or analysis | `xlsx` |

### Infrastructure & Dev Tools
| Use when... | Skill |
|---|---|
| Building an MCP server | `mcp-builder` |
| Automating external apps (Gmail, Slack, Notion…) | `composio` |
| Testing a local web app with Playwright | `webapp-testing` |
| Running code in a secure cloud sandbox | `agent-sandboxes` |
| Writing internal docs, status updates, newsletters | `internal-comms` |
| Co-authoring a spec or proposal | `doc-coauthoring` |
| Creating a new skill | `skill-creator` |
| Syncing dotfiles to a new machine | `sync-dotfiles` |
| Researching recent AI/tech news | `last30days` |
