# Preview Issues from Planning Document

Parse a planning document and show the issues that would be created, without creating anything. This is a safe, read-only operation.

Arguments: $ARGUMENTS (required — path to planning document, optional: `--repo owner/repo`)

## Steps

### 1. Load Document

- Read the file at the provided path
- Detect document type: refactoring plan, migration plan, epic, tech debt inventory, or generic task list

### 2. Extract Tasks

Use the `plan-to-issues` skill to parse the document:
- Identify each phase, priority item, or numbered task
- Map task signals to labels
- Group by phase/priority → milestones
- Track dependencies between items

### 3. Display Each Issue

For each extracted issue, show:

```
---
### Issue: {title}
**Labels**: `refactor`, `priority: high`
**Milestone**: Phase 2: Config Cleanup
**Risk**: MEDIUM — touches build configuration
**Depends on**: Issue "Delete Supabase files"

#### Body Preview:
> ## Summary
> Remove Supabase SPM package and all environment variable references...
>
> ## Tasks
> - [ ] Delete `.remote(url: "...supabase-swift.git"...)` from packages array
> - [ ] Remove NUTRIA_SUPABASE_URL build settings
> ...
>
> ## Files Affected
> | Action | File |
> |---|---|
> | EDIT | `Project.swift` |
---
```

### 4. Show Summary Stats

```
## Summary
- **Total issues**: N
- **By priority**: X critical, Y high, Z medium, W low
- **Milestones**: Phase 1 (N issues), Phase 2 (N), ...
- **Labels used**: cleanup (N), refactor (N), ...
- **Estimated duplicates**: N (will be skipped)

Ready to create? Run: /plan-issues <same-path>
```

### 5. Suggest Improvements

If the source document has issues that would produce poor GitHub Issues, flag them:
- Tasks that are too vague (no concrete steps)
- Tasks that are too large (> 8 checklist items → suggest splitting)
- Missing risk assessment
- Missing file paths
