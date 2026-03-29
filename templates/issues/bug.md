# Bug Fix Issue Template

Use for: bug fixes, error corrections, crash resolutions, incorrect behavior.

**Default labels**: `bug`
**Common companion labels**: `priority: *`

```markdown
## Summary
Fix {what is broken} — {observable symptom}.

**Source**: `{path/to/planning-document.md}` — {Phase/Priority name}
**Risk**: {LOW|MEDIUM|HIGH} — {explanation of fix scope}

## Problem
{Describe the bug: what happens vs what should happen}

## Root Cause
{Brief analysis of why this bug exists, if known}

## Tasks
- [ ] {step 1 — reproduce/confirm the bug}
- [ ] {step 2 — implement fix}
- [ ] {step 3 — add test to prevent regression}
- [ ] {step 4 — verify fix}

## Files Affected
| Action | File | Notes |
|---|---|---|
| EDIT | `{path}` | {what changes} |

## Acceptance Criteria
- [ ] Bug no longer reproduces
- [ ] Regression test added
- [ ] Build + test + lint pass
- [ ] No side effects in related features

## Dependencies
{#issue-number if blocked, or "None"}
```
