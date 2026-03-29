## GitHub Planner

You have the **github-planner** techpack installed for document-to-issue automation.

### Commands
- `/plan-issues <path>` — Parse a planning document and create GitHub Issues
- `/plan-preview <path>` — Preview issues without creating them (dry run)

### Configuration
- **Repository**: `__GITHUB_REPO__`
- **Label prefix**: `__LABEL_PREFIX__`
- **Default assignee**: `__DEFAULT_ASSIGNEE__`

### When to Use
- After creating refactoring plans, migration plans, or epic documents
- When converting technical debt inventories into trackable issues
- To batch-create issues from structured markdown with phases/priorities

### Rules
- Always run `/plan-preview` first to review before creating
- Never create duplicate issues — check existing issues before creating
- Labels are auto-created if they don't exist (with standard color scheme)
- Milestones are created per document phase/priority group
- Issues are created in execution order so dependency references (#N) resolve correctly

### GitHub Auth
- Uses `gh` CLI authentication (keyring-based)
- Required scopes: `repo` (read/write issues, labels, milestones)
- Verify with: `gh auth status`
