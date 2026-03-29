# GitHub Planner

MCS techpack that turns planning documents into GitHub Issues — with labels, milestones, checklists, and dependency tracking.

Feed it a refactoring plan, migration spec, epic, or tech debt inventory. It extracts every task, maps priorities and phases, and creates issues in the right order so `#N` references resolve correctly.

## Install

```bash
mcs install github-planner
```

During setup you'll be prompted for:

| Prompt | Description | Default |
|---|---|---|
| `GITHUB_REPO` | Target repository (`owner/repo`) | Current repo |
| `LABEL_PREFIX` | Prefix for auto-created labels | _(none)_ |
| `DEFAULT_ASSIGNEE` | Default issue assignee | _(none)_ |

### Prerequisites

- [GitHub CLI](https://cli.github.com/) (`gh`) — authenticated with `repo` scope
- [jq](https://jqlang.github.io/jq/) — used by the session hook

Both are installed automatically via Homebrew if missing.

## Usage

### Preview first (dry run)

```
/plan-preview path/to/plan.md
```

Shows every issue that would be created — title, labels, milestone, risk, body preview — without touching GitHub. Also flags issues in your document (vague tasks, oversized checklists, missing file paths).

### Create issues

```
/plan-issues path/to/plan.md
```

Parses the document, presents the full plan for approval, then creates everything:

1. **Labels** — auto-created with a standard color scheme if they don't exist
2. **Milestones** — one per phase or priority group
3. **Issues** — created in execution order with dependency references

You'll always be asked to confirm before anything is created.

#### Flags

| Flag | Description |
|---|---|
| `--repo owner/repo` | Override target repository |
| `--dry-run` | Same as `/plan-preview` |

## Supported document types

- Refactoring plans (phased, prioritized)
- Migration plans
- Epic documents with stories/tasks
- Architecture decision records (ADRs)
- Sprint planning documents
- Technical debt inventories
- Any structured markdown with tasks, phases, or action items

## How it works

### Task extraction

Each phase, priority item, or numbered task becomes a GitHub Issue. Sub-steps become checklists. Dependencies between phases become issue cross-references.

### Label mapping

| Document signal | Label |
|---|---|
| "Delete", "Remove", "Clean up" | `cleanup` |
| "Refactor", "Reorganize", "Move" | `refactor` |
| "Fix", "Bug", "Broken" | `bug` |
| "Add", "Create", "Implement" | `enhancement` |
| "CRITICAL", "Priority 1" | `priority: critical` |
| "HIGH", "Priority 2" | `priority: high` |
| "MEDIUM", "Priority 3-4" | `priority: medium` |
| "LOW", "Priority 5-6" | `priority: low` |
| Architecture, patterns | `architecture` |
| Config, build, CI/CD | `infrastructure` |
| Breaking changes | `breaking-change` |
| Tests | `testing` |
| Docs | `documentation` |

### Issue templates

Issues are generated from structured templates based on task type:

| Template | Used for |
|---|---|
| `refactoring.md` | Restructuring, migrations, file splits, consolidations |
| `cleanup.md` | Dead code removal, deprecated files, unused dependencies |
| `bug.md` | Bug fixes, error corrections, crash resolutions |
| `feature.md` | New features, enhancements, new capabilities |

Each template includes Summary, Tasks (checklist), Files Affected, Acceptance Criteria, Dependencies, and Risk assessment.

## What's included

```
github-planner/
  agents/github-planner.md    # Agent that creates issues via gh CLI
  commands/
    plan-issues.md             # /plan-issues command
    plan-preview.md            # /plan-preview command
  skills/plan-to-issues/       # Task extraction and label mapping logic
  templates/issues/            # Issue body templates (4 types)
  templates/instructions.md    # CLAUDE.local.md instructions
  hooks/gh-auth-check.sh       # Session hook — verifies gh auth on start
  config/settings.json         # Permission allowlist for gh commands
  techpack.yaml                # Techpack manifest
```

## License

MIT
