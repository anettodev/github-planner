# GitHub Planner

MCS techpack for GitHub project management. Creates issues from planning documents, organizes epics as GitHub Projects (v2), and triages backlogs with PM-level insights on priority, UX impact, and project health.

## Install

```bash
mcs pack add anettodev/github-planner
mcs sync
```

During setup you'll be prompted for:

| Prompt | Description | Default |
|---|---|---|
| `GITHUB_REPO` | Target repository (`owner/repo`) | Current repo |
| `LABEL_PREFIX` | Prefix for auto-created labels | _(none)_ |
| `DEFAULT_ASSIGNEE` | Default issue assignee | _(none)_ |

### Prerequisites

- [GitHub CLI](https://cli.github.com/) (`gh`) — authenticated with `repo` and `project` scopes
- [jq](https://jqlang.github.io/jq/) — used by the session hook

Both are installed automatically via Homebrew if missing.

## Commands

### `/plan-preview <path>` — Preview issues (dry run)

```
/plan-preview path/to/plan.md
```

Shows every issue that would be created — title, labels, milestone, risk, body preview — without touching GitHub. Flags problems in your document (vague tasks, oversized checklists, missing file paths).

### `/plan-issues <path>` — Create issues

```
/plan-issues path/to/plan.md
```

Parses the document, presents the full plan for approval, then creates:
1. **Labels** — auto-created with a standard color scheme if they don't exist
2. **Milestones** — one per phase or priority group
3. **Issues** — created in execution order with dependency references

| Flag | Description |
|---|---|
| `--repo owner/repo` | Override target repository |
| `--dry-run` | Same as `/plan-preview` |

### `/plan-epic <path>` — Create project board

```
/plan-epic path/to/plan.md
```

Creates a GitHub Project (v2) from a planning document with custom fields:
- **Priority**: Critical, High, Medium, Low
- **Phase**: Extracted from document sections
- **Status**: Backlog, Todo, In Progress, In Review, Done

Links all issues to the project and sets field values. Creates missing issues automatically.

| Flag | Description |
|---|---|
| `--repo owner/repo` | Override target repository |
| `--link-only #1 #2 #3` | Link existing issues to a project (no document needed) |
| `--project-number N` | Link to an existing project instead of creating new |

### `/issue-triage` — Backlog triage and health check

```
/issue-triage
```

Scans all open issues and produces a PM-level triage report:

- **Backlog composition** — bugs vs features vs refactoring, with decision tips
- **Priority re-evaluation** — flags mismatches (low-priority crashes, stale high-priority items)
- **UX impact assessment** — scores issues by user-facing impact, suggests UX health sprints
- **Staleness detection** — flags issues with no activity (30/60/120+ days)
- **Duplicate detection** — groups similar issues by title and labels
- **Oversized issues** — flags items with 8+ checklist items, suggests splits
- **Epic suggestions** — identifies natural groupings for project boards
- **Project health dashboard** — composition, age distribution, assignment coverage, UX score
- **Recommended actions** — prioritized list of what the PM should do next

Read-only by default. Use `--apply` to interactively approve and execute suggestions.

| Flag | Description |
|---|---|
| `--repo owner/repo` | Override target repository |
| `--apply` | Enable interactive mode to apply suggestions |
| `--scope labels,priorities,...` | Limit analysis to specific categories |
| `--since 30d` | Only analyze issues updated in the last N days |

## Typical workflow

```
/plan-preview plan.md          # 1. Review what would be created
/plan-issues plan.md           # 2. Create the issues
/plan-epic plan.md             # 3. Organize into a project board
/issue-triage                  # 4. Periodic backlog health check
```

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
  agents/
    github-planner.md              # Creates issues via gh CLI
    github-project-manager.md      # Creates/configures GitHub Projects v2
    issue-analyst.md               # Analyzes issues for triage (read-only)
  commands/
    plan-issues.md                 # /plan-issues command
    plan-preview.md                # /plan-preview command
    plan-epic.md                   # /plan-epic command
    issue-triage.md                # /issue-triage command
  skills/
    plan-to-issues/                # Task extraction and label mapping
    epic-to-project/               # Project structure and custom fields
    issue-triage/                  # Triage rules and PM dashboard
  templates/
    instructions.md                # CLAUDE.local.md instructions
    issues/                        # Issue body templates (4 types)
    projects/                      # Project description template
  hooks/
    gh-auth-check.sh               # Session hook — verifies gh auth on start
    gh-auth-check-doctor.sh        # Doctor check script
  config/settings.json             # Permission allowlist for gh commands
  techpack.yaml                    # Pack manifest
```

## License

MIT
