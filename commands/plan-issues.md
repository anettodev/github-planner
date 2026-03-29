# Create Issues from Planning Document

Parse a planning document and create GitHub Issues with labels, milestones, and dependency tracking.

Arguments: $ARGUMENTS (required — path to planning document, optional flags: `--repo owner/repo`, `--dry-run`)

## Steps

### 1. Load Document

- Read the file at the provided path
- Detect document type: refactoring plan, migration plan, epic, tech debt inventory, or generic task list
- If `--dry-run` is specified, switch to preview mode (same as `/plan-preview`)

### 2. Detect Repository

- If `--repo` flag provided, use that
- Otherwise run `gh repo view --json nameWithOwner -q .nameWithOwner`
- Confirm with user before proceeding: "Will create issues in `owner/repo`. Continue?"

### 3. Extract Tasks

Use the `plan-to-issues` skill to parse the document:
- Identify each phase, priority item, or numbered task → becomes an issue
- Identify sub-steps → become checklists within the issue body
- Map task signals to labels (see skill for label mapping table)
- Group by phase/priority → milestones
- Track dependencies between items

### 4. Check for Existing Issues

For each extracted task, search for potential duplicates:
```bash
gh issue list --search "KEY_WORDS" --state open --limit 5 --json number,title
```

If duplicates found, skip those tasks and report them.

### 5. Present Plan for Approval

Show the full plan before creating anything:

```
Will create N issues in owner/repo:

| # | Title                          | Labels                     | Milestone     |
|---|--------------------------------|----------------------------|---------------|
| 1 | Remove dead files              | cleanup, priority: critical | Phase 1       |
| 2 | Consolidate duplicates         | refactor, priority: high   | Phase 1       |
...

New labels to create: priority: critical, cleanup, ...
New milestones to create: Phase 1, Phase 2, ...

Proceed? (yes/no)
```

**DO NOT create issues until user confirms.**

### 6. Create Labels and Milestones

Create any missing labels and milestones before creating issues.

### 7. Create Issues

Launch the `github-planner` agent to create all issues in execution order.

### 8. Report

Output the final summary with issue numbers and URLs.

### 9. Evaluate Learnings

If this session produced decisions or patterns worth remembering, save them using whatever knowledge tools are available.
