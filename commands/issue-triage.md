# Triage Open Issues

Scan open issues, analyze backlog health, re-evaluate priorities, assess UX impact, and produce a PM-level triage report with actionable recommendations.

Arguments: $ARGUMENTS (optional flags: `--repo owner/repo`, `--apply`, `--scope labels|priorities|stale|duplicates|epics|ux|all`, `--since 30d`)

## Steps

### 1. Detect Repository

- If `--repo` flag provided, use that
- Otherwise run `gh repo view --json nameWithOwner -q .nameWithOwner`
- Confirm: "Will analyze issues in `owner/repo`."

### 2. Configure Scope

Parse flags:
- `--scope all` (default): Run every analysis category
- `--scope labels,priorities`: Only run specified categories
- `--since 30d`: Only analyze issues updated in the last N days (useful for large backlogs)
- `--apply`: Enable interactive mode to apply suggested changes after review

Available scopes: `labels`, `priorities`, `stale`, `duplicates`, `oversized`, `epics`, `ux`, `health`, `all`

### 3. Run Analysis

Launch the `issue-analyst` agent to:
1. Fetch all open issues and repository context (labels, milestones, projects)
2. Analyze each issue across all selected categories
3. Compute aggregate metrics (composition, age, assignment, coverage, UX health)
4. Generate prioritized recommendations

### 4. Present Triage Report

Display the full report using the template from `issue-triage` skill's `references/triage-report.md`:

1. **Backlog Composition** — bugs vs features vs refactoring vs unlabeled, with decision tips
2. **Issue Age Distribution** — how old is the backlog, with decision tips
3. **Assignment & Ownership** — who owns what, overloaded assignees
4. **Milestone & Epic Coverage** — how many issues are planned vs orphaned
5. **UX Health Score** — critical UX issues, impact assessment, score
6. **Findings** — detailed tables for each category (missing labels, priority changes, stale, duplicates, oversized, epic suggestions, orphans)
7. **Recommended Actions** — top 5-10 prioritized actions the PM should take

### 5. Offer Actions (if --apply or user requests)

For each finding category, offer batch actions with individual confirmation:

```
## Apply Changes?

### Missing Labels (N issues)
Apply suggested labels? [y/N]

### Priority Re-evaluation (N issues)
Apply suggested priority changes? [y/N]

### Stale Issues (N issues)
Close stale issues (one by one with confirmation)? [y/N]

### Duplicates (N groups)
Close duplicates (one by one with confirmation)? [y/N]

### Oversized Issues (N issues)
Create split issues? [y/N]

### Suggested Epics (N groups)
Create projects? (will run /plan-epic --link-only for each) [y/N]
```

**Each action requires confirmation. Never batch-apply without explicit approval.**

### 6. Execute Approved Actions

For approved actions:
- **Labels/priorities**: `gh issue edit N --add-label "label"` or `gh issue edit N --remove-label "old" --add-label "new"`
- **Closures**: Add comment with reason, then `gh issue close N`
- **Splits**: Launch `github-planner` agent to create new issues
- **Epics**: Suggest running `/plan-epic --link-only #N1 #N2 #N3` (or execute if confirmed)

### 7. Final Summary

If actions were applied:
```
## Triage Complete

- Labels updated: N issues
- Priorities changed: N issues
- Issues closed: N
- Issues split: N (M new issues created)
- Epics created: N

Remaining action items (not applied): N
```

### 8. Evaluate Learnings

If this session produced decisions or patterns worth remembering, save them using whatever knowledge tools are available.
