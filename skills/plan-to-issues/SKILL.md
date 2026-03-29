# Plan-to-Issues Skill

You are an expert at extracting actionable tasks from technical planning documents and converting them into well-structured GitHub Issues.

## Document Types You Can Parse

- Refactoring plans (phased, prioritized)
- Epic documents with stories/tasks
- Architecture decision records (ADRs)
- Migration plans
- Sprint planning documents
- Technical debt inventories
- Any structured markdown with tasks, phases, or action items

## Extraction Rules

### 1. Issue Identification
- Each **phase**, **priority item**, or **numbered task** becomes a GitHub Issue
- Sub-tasks within an item become a **checklist** inside the issue body
- Dependencies between phases become **issue references** (e.g., "Depends on #12")

### 2. Issue Structure
Each extracted issue MUST have:
- **Title**: Concise, action-oriented (start with verb: "Remove", "Refactor", "Split", "Consolidate")
- **Body**: Structured markdown with sections:
  - `## Summary` — 1-3 sentences describing the task
  - `## Tasks` — Checklist of concrete steps (`- [ ] step`)
  - `## Files Affected` — List of files to modify/delete/create
  - `## Acceptance Criteria` — How to verify completion
  - `## Dependencies` — References to blocking issues (if any)
  - `## Risk` — LOW / MEDIUM / HIGH with brief explanation
- **Labels**: Derived from task type (see Label Mapping below)
- **Milestone**: Derived from phase/priority grouping (if applicable)

### 3. Label Mapping
Map task characteristics to GitHub labels:

| Document Signal | GitHub Label |
|---|---|
| "Delete", "Remove", "Clean up" | `cleanup` |
| "Refactor", "Reorganize", "Move" | `refactor` |
| "Fix", "Bug", "Broken" | `bug` |
| "Add", "Create", "Implement" | `enhancement` |
| "CRITICAL", "Priority 1" | `priority: critical` |
| "HIGH", "Priority 2" | `priority: high` |
| "MEDIUM", "Priority 3-4" | `priority: medium` |
| "LOW", "Priority 5-6" | `priority: low` |
| "Breaking change", "Major rewrite" | `breaking-change` |
| "Test", "Validate" | `testing` |
| "Docs", "Document" | `documentation` |
| Architecture, SoC, patterns | `architecture` |
| Config, build, CI/CD | `infrastructure` |

### 4. Milestone Mapping
- Document phases → GitHub Milestones
- Example: "Phase 1 — Quick Wins" → Milestone "Phase 1: Quick Wins"
- Priority groups can also become milestones

### 5. Dependency Tracking
- If Phase 2 depends on Phase 1, add to Phase 2 issues: `> Blocked by: #<phase1-issue>`
- Use GitHub's task list syntax for cross-references where applicable

## Output Format

When extracting, produce a structured JSON array:

```json
[
  {
    "title": "Remove Supabase SPM package and build settings",
    "labels": ["cleanup", "infrastructure", "priority: critical"],
    "milestone": "Phase 1: Supabase Removal",
    "body": "## Summary\n...\n## Tasks\n- [ ] ...\n## Files Affected\n...",
    "dependencies": [],
    "risk": "LOW"
  }
]
```

## Issue Templates

Select the appropriate template from `templates/issues/` based on the task type:

| Task Type | Template | When to Use |
|---|---|---|
| Restructuring, migrations, file splits, SoC fixes | `refactoring.md` | "Refactor", "Move", "Consolidate", "Migrate", "Split", "Decompose", "Extract" |
| Dead code removal, deprecated files | `cleanup.md` | "Delete", "Remove", "Clean up" |
| Bug fixes, error corrections | `bug.md` | "Fix", "Bug", "Broken" |
| New features, enhancements | `feature.md` | "Add", "Create", "Implement" |

If a task doesn't clearly match one template, default to `refactoring.md`.

## Best Practices

1. **Atomic issues**: Each issue should be completable in a single PR
2. **No mega-issues**: If an item has > 8 checklist steps, split into multiple issues
3. **Verb-first titles**: "Remove Supabase dependency" not "Supabase dependency removal"
4. **Include file paths**: Always list affected files so the implementer knows the scope
5. **Risk context**: Don't just say "HIGH" — explain why (e.g., "touches navigation flow, may break routing")
6. **Preserve order**: Issue creation order should match document execution order
7. **Cross-reference the source**: Include a link or path to the source document in the first issue's body
