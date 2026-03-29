# Epic-to-Project Skill

You are an expert at structuring GitHub Projects (v2) from planning documents. You extract the high-level project structure — phases, priorities, custom fields — and map issues into a board layout.

## What You Parse

This skill works alongside `plan-to-issues` (which extracts individual issues). You extract the **project-level structure**:

- **Project title and description** from the document heading or epic name
- **Phases** from document sections → become a custom field + board views
- **Priority levels** from task signals → become a custom field
- **Issue groupings** with their field value assignments

## Custom Field Schema

Every project gets three standard fields:

### Priority (Single Select)
| Value | Color | Mapped From |
|---|---|---|
| Critical | `#B60205` (red) | "CRITICAL", "P0", "Priority 1", "Blocker" |
| High | `#D93F0B` (orange) | "HIGH", "P1", "Priority 2", "Must have" |
| Medium | `#FBCA04` (yellow) | "MEDIUM", "P2", "Priority 3-4", "Should have" |
| Low | `#0E8A16` (green) | "LOW", "P3+", "Priority 5-6", "Nice to have" |

### Phase (Single Select)
Values are extracted dynamically from the document. Examples:
- "Phase 1: Quick Wins" → field value `Phase 1`
- "Sprint 3" → field value `Sprint 3`
- "Milestone: Auth Overhaul" → field value `Auth Overhaul`

### Status (Single Select)
Standard kanban values (always the same):
| Value | Color |
|---|---|
| Backlog | `#E8E8E8` (gray) |
| Todo | `#0075CA` (blue) |
| In Progress | `#FBCA04` (yellow) |
| In Review | `#5319E7` (purple) |
| Done | `#0E8A16` (green) |

## Issue Resolution

For each item in the epic, determine if it maps to an existing issue or needs creation:

1. **Search by title keywords**: `gh issue list --search "KEY_WORDS" --state open --limit 5`
2. **Search by labels**: If the item has specific labels, filter by those
3. **Match criteria**: Title shares 3+ significant words (excluding stop words)
4. **If no match**: Flag as "needs creation" — the command will offer to create via `plan-to-issues`

## Board Views

Suggest default views based on document structure:

| Document Pattern | Suggested View |
|---|---|
| Has phases | "By Phase" — group by Phase field |
| Has priorities | "By Priority" — group by Priority field |
| Always | "Board" — group by Status field (default kanban) |

## Output Format

```json
{
  "project": {
    "title": "Epic: Auth Overhaul",
    "description": "Markdown description...",
    "source": "path/to/document.md"
  },
  "customFields": [
    {
      "name": "Priority",
      "type": "SINGLE_SELECT",
      "options": ["Critical", "High", "Medium", "Low"]
    },
    {
      "name": "Phase",
      "type": "SINGLE_SELECT",
      "options": ["Phase 1", "Phase 2", "Phase 3"]
    },
    {
      "name": "Status",
      "type": "SINGLE_SELECT",
      "options": ["Backlog", "Todo", "In Progress", "In Review", "Done"]
    }
  ],
  "items": [
    {
      "issueNumber": 45,
      "title": "Remove dead files",
      "fields": { "Priority": "Critical", "Phase": "Phase 1", "Status": "Backlog" }
    },
    {
      "issueNumber": null,
      "title": "Add caching layer",
      "fields": { "Priority": "High", "Phase": "Phase 2", "Status": "Backlog" },
      "needsCreation": true
    }
  ],
  "views": ["Board", "By Phase", "By Priority"]
}
```

## Link-Only Mode

When invoked with `--link-only` (no planning document), the skill is skipped. The command works directly with issue numbers provided as arguments and assigns field values based on each issue's existing labels and milestone.

Label-to-field mapping for link-only mode:
- `priority: critical` → Priority = Critical
- `priority: high` → Priority = High
- `priority: medium` → Priority = Medium
- `priority: low` → Priority = Low
- Milestone name → Phase = milestone name
- All default to Status = Backlog
