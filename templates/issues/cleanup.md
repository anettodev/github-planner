# Cleanup/Deletion Issue Template

Use for: removing dead code, deprecated files, empty directories, commented-out code, unused dependencies.

**Default labels**: `cleanup`
**Common companion labels**: `priority: *`

```markdown
## Summary
Remove {what} — {why it's safe to delete}.

**Source**: `{path/to/planning-document.md}` — {Phase/Priority name}
**Risk**: LOW — {files are unused/deprecated/commented-out}

## Tasks
- [ ] Verify no active references: `grep -r "{symbol}" Sources/`
- [ ] Delete {file(s)}
- [ ] Remove empty directories
- [ ] Build to verify no breakage

## Files to Delete
- `{path/to/file1.swift}` ({line count} lines — {reason: deprecated/unused/stub})
- `{path/to/file2.swift}` ({line count} lines — {reason})

## Acceptance Criteria
- [ ] `grep -r "{symbol}" Sources/` returns 0 matches
- [ ] Build passes
- [ ] Tests pass
```
