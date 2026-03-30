# Create Epic from Planning Document

Create a GitHub Project (v2) from a planning document, link issues, and configure custom fields (Priority, Phase, Status).

Arguments: $ARGUMENTS (required — path to planning document OR `--link-only #1 #2 #3`, optional flags: `--repo owner/repo`, `--project-number N`)

## Steps

### 1. Parse Arguments

- If `--link-only` is present, skip document parsing (step 3). Collect issue numbers from arguments.
- If `--project-number N` is present, link to an existing project instead of creating a new one.
- Otherwise, the first argument is the path to the planning document.

### 2. Detect Repository

- If `--repo` flag provided, use that
- Otherwise run `gh repo view --json nameWithOwner -q .nameWithOwner`
- Confirm with user before proceeding: "Will create project in `owner/repo`. Continue?"

### 3. Extract Epic Structure

Use the `epic-to-project` skill to parse the document:
- Extract project title and description
- Identify phases → custom field options
- Identify priority levels for each item
- Determine which items map to existing issues vs. need creation

### 4. Resolve Issues

For each item in the epic:
- Search for existing issues: `gh issue list --search "KEY_WORDS" --state open --limit 5 --json number,title`
- If a match exists, use that issue number
- If no match, flag as "needs creation"

For `--link-only` mode, verify each issue number exists:
```bash
gh issue view N --json number,title,labels,milestone
```
Map existing labels and milestones to field values.

### 5. Check for Existing Project

If `--project-number` is provided, verify it exists. Otherwise:
```bash
gh project list --owner OWNER --format json
```
If a project with the same title exists, ask: "Project 'TITLE' already exists (#N). Use it or create new?"

### 6. Present Plan for Approval

Show the full plan before creating anything:

```
Will create project "Epic: Auth Overhaul" in owner/repo:

Custom fields:
  - Priority: Critical, High, Medium, Low
  - Phase: Phase 1, Phase 2, Phase 3
  - Status: Todo, In Progress, In Review, Done

Milestones:
  - Phase 1 → reuse existing #2
  - Phase 2 → create new
  - Phase 3 → create new

| # | Issue | Title                    | Priority | Phase   | Milestone | Status |
|---|-------|--------------------------|----------|---------|-----------|--------|
| 1 | #45   | Remove dead files        | Critical | Phase 1 | Phase 1   | Todo   |
| 2 | #46   | Update Project.swift     | High     | Phase 2 | Phase 2   | Todo   |
| 3 | NEW   | Add caching layer        | Medium   | Phase 3 | Phase 3   | Todo   |

Issues to create first: 1
Issues to link: 2
Milestones to create: 2 · to reuse: 1

Proceed? (yes/no)
```

**DO NOT create the project until user confirms.**

### 7. Create Missing Issues

If there are items that need creation:
- Use the `plan-to-issues` skill knowledge and launch the `github-planner` agent to create them
- Capture the new issue numbers for linking

### 8. Create Project and Configure

Launch the `github-project-manager` agent to:
1. Create the project (or use existing)
2. Add custom fields
3. Link all issues
4. Set field values on each item

### 9. Report

Output the project URL and final summary:

```
Project created: "Epic: Auth Overhaul" (#5)
URL: https://github.com/orgs/owner/projects/5

N issues linked, M custom fields configured.
```

### 10. Evaluate Learnings

If this session produced decisions or patterns worth remembering, save them using whatever knowledge tools are available.
