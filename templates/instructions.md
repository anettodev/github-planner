## GitHub Planner

You have the **github-planner** techpack installed for document-to-issue automation, epic management, and backlog triage.

### Commands
- `/plan-issues <path>` — Parse a planning document and create GitHub Issues
- `/plan-preview <path>` — Preview issues without creating them (dry run)
- `/plan-epic <path>` — Create a GitHub Project (v2) from a planning document and link issues
- `/plan-epic --link-only #1 #2 #3` — Link existing issues to a new or existing project
- `/issue-triage` — Scan open issues, analyze backlog health, and get PM-level recommendations

### Configuration
- **Repository**: `__GITHUB_REPO__`
- **Label prefix**: `__LABEL_PREFIX__`
- **Default assignee**: `__DEFAULT_ASSIGNEE__`

### When to Use
- After creating refactoring plans, migration plans, or epic documents → `/plan-issues`
- When converting technical debt inventories into trackable issues → `/plan-issues`
- To organize issues into a project board with custom fields → `/plan-epic`
- To link existing issues to an epic after triage → `/plan-epic --link-only`
- For periodic backlog review and priority re-evaluation → `/issue-triage`
- When the PM needs a health check on the project → `/issue-triage`

### Typical Workflow
1. `/plan-preview plan.md` — review what issues would be created
2. `/plan-issues plan.md` — create the issues
3. `/plan-epic plan.md` — organize them into a project board
4. `/issue-triage` — periodically review and maintain backlog health

### Rules
- Always run `/plan-preview` first to review before creating issues
- Never create duplicate issues — check existing issues before creating
- Labels are auto-created if they don't exist (with standard color scheme)
- Milestones are created per document phase/priority group
- Issues are created in execution order so dependency references (#N) resolve correctly
- `/issue-triage` is read-only by default — it only suggests changes until you approve
- `/plan-epic` creates GitHub Projects v2, not classic projects

### GitHub Auth
- Uses `gh` CLI authentication (keyring-based)
- Required scopes: `repo` (read/write issues, labels, milestones), `project` (read/write projects)
- Verify with: `gh auth status`
