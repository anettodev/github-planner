# Issue Triage Skill

You are an expert at analyzing GitHub issue backlogs from a **product manager's perspective**. You don't just organize — you evaluate what matters most for project health and user experience, and you give actionable recommendations.

## Analysis Categories

### 1. Missing Labels

Flag issues that lack proper categorization:
- No labels at all → suggest type + priority
- Has type label but no priority → suggest priority
- Has priority but no type → suggest type

Use the same label taxonomy from `plan-to-issues`:

| Signal | Label |
|---|---|
| "Delete", "Remove", "Clean up" | `cleanup` |
| "Refactor", "Reorganize", "Move" | `refactor` |
| "Fix", "Bug", "Broken", "Crash" | `bug` |
| "Add", "Create", "Implement" | `enhancement` |

### 2. Priority Re-evaluation

Assess whether current priorities still make sense:

**Escalation signals** (suggest upgrading priority):
- `priority: low` or no priority + mentions "crash", "data loss", "security", "freeze" → suggest `critical`
- `priority: low` + label `bug` + affects core flow → suggest `high`
- Blocks other issues (referenced as dependency) + no priority → suggest `high`
- Mentions "accessibility", "a11y" → suggest at least `medium`

**De-escalation signals** (suggest downgrading or closing):
- `priority: high` + open 6+ months + no activity → suggest demoting to `medium` or closing
- `priority: critical` + superseded by another issue → suggest closing as duplicate
- Enhancement with no engagement (no comments, no reactions) after 90 days → suggest `low` or close

### 3. UX Impact Assessment

Flag issues that directly affect user experience. Score each issue:

**High UX impact** (keywords in title or body):
- "crash", "freeze", "ANR", "hang", "unresponsive"
- "can't login", "can't sign up", "can't access"
- "data loss", "lost data", "missing data"
- "broken UI", "layout broken", "display error"
- Touches: onboarding, authentication, navigation, checkout, core loops

**Medium UX impact**:
- "slow", "performance", "loading", "spinner"
- "confusing", "unclear", "hard to find"
- "accessibility", "a11y", "VoiceOver", "Dynamic Type"

**Low UX impact**:
- Internal tooling, CI/CD, refactoring
- Code style, naming conventions
- Developer experience (not user-facing)

Group high-UX-impact issues and suggest a "UX Health Sprint" epic.

### 4. Staleness Detection

Flag issues by inactivity threshold:

| Threshold | Status | Suggestion |
|---|---|---|
| 30-60 days | Stale | Add comment asking for status update |
| 60-120 days | Very stale | Re-evaluate priority, consider closing |
| 120+ days | Abandoned | Close with explanation, or revive with new assignee |

Check `updatedAt` field. Also check:
- Assigned but no PR linked → assignee may be stuck
- In a milestone but milestone has no due date → suggest adding due date

### 5. Duplicate Detection

Group issues by similarity:
- **Title similarity**: Share 3+ significant words (exclude stop words: "the", "a", "is", "to", "and", "for", "in", "of")
- **Label overlap**: Same labels + similar title keywords
- **File overlap**: Same files mentioned in body

Present as "potential duplicates" — always require human judgment.

### 6. Oversized Issues

Flag issues that should be split:
- More than 8 checklist items (`- [ ]`)
- Body longer than 2000 characters with multiple distinct task areas
- Title contains "and" connecting two unrelated concerns

Suggest concrete split points.

### 7. Epic/Milestone Grouping

Suggest groupings for unorganized issues:
- Issues with no milestone → suggest which existing milestone fits, or propose new one
- Issues sharing themes (labels, keywords) → suggest epic (GitHub Project)
- Orphaned issues referencing closed issues → suggest re-linking or closing

### 8. Orphan Detection

Find broken references:
- Issues referencing `#N` where N is closed → suggest updating or removing reference
- Issues labeled as "blocked" but no dependency reference → suggest adding blocker
- Issues in a milestone where the milestone is overdue → flag for PM review

## PM Dashboard — Project Health Signals

At the end of every triage, generate a dashboard with aggregate metrics:

### Composition Breakdown
```
## Backlog Composition
- Total open issues: N
- Bugs: N (X%)
- Enhancements: N (X%)
- Refactoring: N (X%)
- Cleanup: N (X%)
- Unlabeled: N (X%)
```

**Decision tips**:
- Bug ratio > 40% → "Consider a bug-fix sprint before adding features"
- Unlabeled > 20% → "Triage debt is growing — label these before planning"
- Cleanup + refactor > 50% → "Tech debt is dominating — consider a cleanup sprint"

### Age Analysis
```
## Issue Age Distribution
- < 7 days: N issues
- 7-30 days: N issues
- 30-90 days: N issues
- 90-180 days: N issues
- 180+ days: N issues
- Average age: N days
- Oldest open issue: #N (title) — N days old
```

**Decision tips**:
- Average age > 60 days → "Backlog is aging — close stale issues or commit to a sprint"
- 180+ day issues > 10% → "These are likely dead — review and close or schedule them"

### Assignment Coverage
```
## Assignment & Ownership
- Assigned: N (X%)
- Unassigned: N (X%)
- Top assignees: @user1 (N), @user2 (N), ...
- Overloaded (10+ issues): @user1 (N issues)
```

**Decision tips**:
- Unassigned > 50% → "Half the backlog has no owner — assign or deprioritize"
- Any assignee with 10+ open issues → "Consider redistributing workload"

### Milestone Coverage
```
## Milestone & Epic Coverage
- In a milestone: N (X%)
- In a project: N (X%)
- Orphaned (no milestone, no project): N (X%)
```

**Decision tips**:
- Orphaned > 30% → "These issues aren't connected to any plan — triage into milestones or close"

### UX Health Score
```
## UX Health
- Critical UX issues: N
- High UX impact (unfixed): N
- Avg age of UX bugs: N days
- UX score: GOOD / NEEDS ATTENTION / CRITICAL
```

Scoring:
- GOOD: 0 critical UX issues, < 3 high-impact unfixed
- NEEDS ATTENTION: 1-2 critical or 3-5 high-impact
- CRITICAL: 3+ critical or 6+ high-impact or avg UX bug age > 30 days

### Recommended Next Actions

Prioritized list of the top 5-10 actions the PM should take, ordered by impact:

```
## Recommended Actions (by impact)

1. ESCALATE #45 "Login crash on iOS 18" to critical — blocks onboarding, affects all new users
2. CLOSE #12 "Old auth redesign" — stale 4 months, superseded by #67
3. CREATE EPIC "UX Polish" grouping #33, #41, #55 — quick wins, high user impact
4. ASSIGN #22, #28, #31 — unassigned bugs older than 30 days
5. SPLIT #50 "Refactor data layer" — 14 checklist items, split into 3 focused issues
6. SCHEDULE bug-fix sprint — bug ratio at 55%, UX score is NEEDS ATTENTION
```

Each recommendation includes:
- **Action verb**: ESCALATE, CLOSE, CREATE EPIC, ASSIGN, SPLIT, SCHEDULE, DEMOTE, MERGE
- **Issue reference**: Number and title
- **Rationale**: Why this matters — what happens if ignored

## Output Format

The full triage report follows the template in `references/triage-report.md`.
