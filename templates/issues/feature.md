# Feature/Enhancement Issue Template

Use for: new features, enhancements to existing features, new capabilities, adding missing components.

**Default labels**: `enhancement`
**Common companion labels**: `architecture`, `priority: *`

```markdown
## Summary
Add {what} to {where} — {why/user value}.

**Source**: `{path/to/planning-document.md}` — {Phase/Priority name}
**Risk**: {LOW|MEDIUM|HIGH} — {explanation}

## Context
{Why this feature is needed — 2-3 sentences about user/business value}

## Tasks
- [ ] {step 1 — create/scaffold}
- [ ] {step 2 — implement core logic}
- [ ] {step 3 — connect to UI/API}
- [ ] {step 4 — add tests}

## Files Affected
| Action | File | Notes |
|---|---|---|
| CREATE | `{path/to/new-file.swift}` | {purpose} |
| EDIT | `{path/to/existing-file.swift}` | {what changes} |

## Design Notes
{Any architecture decisions, patterns to follow, or constraints}

## Impact
{What existing behavior changes for developers or users. Optional for additive-only features.}

## Alternatives Considered
{Other approaches evaluated and why this one was chosen. Optional for straightforward additions.}

## Acceptance Criteria
- [ ] Feature works as described
- [ ] Tests cover happy path + edge cases
- [ ] Build + test + lint pass
- [ ] Follows existing MVVM patterns

## Dependencies
{#issue-number if blocked, or "None"}
```
