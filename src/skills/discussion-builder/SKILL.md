# Discussion Builder Skill

You are an expert at creating structured GitHub Discussions from user input or planning documents. You interview the user, select the right template, and produce well-structured content for the `discussion-manager` agent to publish.

## Discussion Types

| Type | Slug | When to use |
|---|---|---|
| Decision (RFC) | `decision` | Team needs to choose between approaches |
| Design Proposal | `design` | Proposing architecture or technical approach |
| Sprint Retro | `retro` | End-of-sprint/phase reflection |
| Post-mortem | `postmortem` | Something went wrong, document lessons |
| Distribution Analysis | `distribution` | Analyze any distribution channel (App Store, Google Play, web, TestFlight, enterprise) |
| Evaluation / Analysis | `analysis` | Evaluate an SDK, tool, vendor, platform, or process |

## Type Detection

When a document path is provided, infer the type from content signals:

| Signal | Type |
|---|---|
| "options", "alternatives", "trade-off", "should we", "choose" | `decision` |
| "proposal", "architecture", "design", "approach", "RFC" | `design` |
| "retro", "went well", "improve", "action items", "sprint" | `retro` |
| "incident", "root cause", "timeline", "outage", "broke" | `postmortem` |
| "ratings", "reviews", "store", "downloads", "feedback", "crash rate" | `distribution` |
| "SDK", "library", "dependency", "evaluate", "compare", "assessment", "vendor", "tool" | `analysis` |

If ambiguous, ask the user.

## Interview Questions (interactive mode)

When no document is provided, ask targeted questions based on the selected type.

### Decision (RFC)
1. What needs to be decided? (title)
2. What's the context? (why does this need a decision now?)
3. What options are you considering? (at least 2)
4. What are the constraints? (time, tech, team, cost)
5. Which issues are related? (issue numbers)
6. Who should weigh in? (GitHub usernames)
7. When does this need to be decided by? (deadline)

### Design Proposal
1. What are you proposing? (title)
2. What problem does this solve?
3. How does it work? (high-level approach)
4. What alternatives did you consider?
5. What's the impact on existing code?
6. Which issues does this relate to?

### Sprint Retro
1. Which sprint/phase? (title)
2. What went well? (list)
3. What didn't go well? (list)
4. What should we change? (action items)
5. Shoutouts? (optional)

### Post-mortem
1. What happened? (title)
2. Timeline of events
3. What was the impact? (users affected, duration)
4. Root cause
5. What failed in our process?
6. Preventive actions (what we'll change)

### Distribution Analysis
1. Which channel? (user types freely: "App Store", "Google Play", "Web", "TestFlight", etc.)
2. What period? (date range)
3. Key metrics? (rating, downloads, crash rate, etc.)
4. Top user complaints or feedback themes
5. Notable reviews (positive and negative)
6. Action items

### Evaluation / Analysis
1. What are you evaluating? (SDK, tool, vendor, platform, process, etc.)
2. What problem does it solve?
3. Alternatives considered
4. License / terms / cost
5. Maintenance or support status
6. Integration or adoption complexity (low/medium/high)
7. Risk assessment
8. Recommendation (adopt, trial, hold, reject)

## Template Selection

Select the matching template from `references/` based on the type slug:
- `decision` → `references/decision.md`
- `design` → `references/design-proposal.md`
- `retro` → `references/sprint-retro.md`
- `postmortem` → `references/post-mortem.md`
- `distribution` → `references/distribution-analysis.md`
- `analysis` → `references/analysis.md`

## GitHub Discussion Category Mapping

Map each type to a Discussion category. If the category doesn't exist, suggest creating it:

| Type | Suggested Category |
|---|---|
| `decision` | Decisions |
| `design` | Ideas |
| `retro` | General |
| `postmortem` | General |
| `distribution` | General |
| `analysis` | Ideas |

Note: GitHub Discussions categories must already exist — they can't be created via API. If the ideal category doesn't exist, use the closest match and suggest the user creates it in repo settings.

## Label Attachment

GitHub Discussions support labels. After creating a discussion, attach labels as follows:

1. Run `gh label list` to get existing labels
2. Auto-attach matching labels if they exist
3. For any suggested label that doesn't exist, propose creating it (name + color) and wait for user approval before creating

### Default label mapping per type

| Type | Auto-attach if exists | Suggest creating if not |
|---|---|---|
| `design` | `enhancement`, `architecture` | `design` (#0075ca) |
| `decision` | `architecture` | `decision` (#e4e669) |
| `retro` | — | `retro` (#f9d0c4) |
| `postmortem` | — | `postmortem` (#b60205) |
| `distribution` | — | `distribution` (#0e8a16) |
| `analysis` | — | `analysis` (#5319e7) |

Use the GraphQL `addLabelsToLabelable` mutation to attach labels to discussions (REST label endpoints only work for issues).

```bash
gh api graphql -f query='mutation {
  addLabelsToLabelable(input: {
    labelableId: "DISCUSSION_NODE_ID"
    labelIds: ["LABEL_NODE_ID"]
  }) {
    labelable { labels(first:5) { nodes { name } } }
  }
}'
```

## Manifest Integration

After creating a Discussion, the agent updates `docs/github-planner/KNOWLEDGE.md`:
- Adds a row to the matching section
- Creates the section if it doesn't exist
- If the file exceeds 20 KB, archives resolved/old entries to `docs/github-planner/archive/KNOWLEDGE-{YEAR}.md`

## Output Format

Produce a structured object for the agent:

```json
{
  "type": "decision",
  "title": "Where should CountryPhoneCode live?",
  "category": "Decisions",
  "body": "## Context\n...\n## Options\n...",
  "labels": ["decision", "architecture"],
  "relatedIssues": [73],
  "manifestEntry": {
    "section": "Decisions",
    "topic": "CountryPhoneCode location",
    "status": "Open",
    "owner": "@anettodev"
  }
}
```
