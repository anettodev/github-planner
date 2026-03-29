# Refactoring Issue Template

Use for: code restructuring, SoC fixes, moving files to proper layers, consolidating duplicates, framework/dependency migrations, API version upgrades, splitting oversized files, extracting subviews.

**Default labels**: `refactor`
**Common companion labels**: `architecture`, `infrastructure`, `breaking-change`, `priority: *`

```markdown
## Summary
{1-3 sentence description of what this refactoring/migration achieves}

**Source**: `{path/to/planning-document.md}` — {Phase/Priority name}
**Risk**: {LOW|MEDIUM|HIGH} — {brief risk explanation}

## Background
{Why this change is needed — 2-3 sentences. Optional for simple refactors.}

## Proposed Split
{Optional — include only for file decomposition tasks}

| New File | Responsibility | Est. Lines |
|---|---|---|
| `{FileName}.swift` | Main container / coordinator | ~{N} |
| `{ExtractedName1}.swift` | {responsibility} | ~{N} |

## Tasks
- [ ] {concrete step 1}
- [ ] {concrete step 2}
- [ ] {concrete step N}

## Files Affected
| Action | File | Notes |
|---|---|---|
| MOVE | `{old/path.swift}` → `{new/path.swift}` | |
| EDIT | `{path/to/file.swift}` | {what changes} |
| DELETE | `{path/to/file.swift}` | |
| CREATE | `{path/to/new-file.swift}` | |

## Rollback Plan
{How to revert if something goes wrong. Optional for low-risk changes.}

## Impact
{What existing behavior changes for developers or users. Optional for low-risk changes.}

## Alternatives Considered
{Other approaches evaluated and why this one was chosen. Optional for straightforward changes.}

## Acceptance Criteria
- [ ] Build passes (`make build`)
- [ ] Tests pass (`make test`)
- [ ] Linter passes (`make lint`)
- [ ] No new SwiftLint warnings introduced
- [ ] {feature-specific criterion}

## Dependencies
{#issue-number if blocked, or "None"}
```
