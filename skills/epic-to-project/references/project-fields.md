# GitHub Projects v2 — Field Configuration Reference

## CLI Commands

### Create a project
```bash
gh project create --owner OWNER --title "TITLE" --format json
```
Returns: `{"number": N, "url": "...", "id": "..."}` — save the `number` for all subsequent commands.

### List existing projects
```bash
gh project list --owner OWNER --format json
```

### Add custom field
```bash
gh project field-create PROJECT_NUMBER --owner OWNER \
  --name "Priority" \
  --data-type SINGLE_SELECT \
  --single-select-options "Critical,High,Medium,Low"
```

### List existing fields
```bash
gh project field-list PROJECT_NUMBER --owner OWNER --format json
```

### Add issue to project
```bash
gh project item-add PROJECT_NUMBER --owner OWNER \
  --url "https://github.com/OWNER/REPO/issues/N"
```
Returns: the item ID needed for setting field values.

### List project items
```bash
gh project item-list PROJECT_NUMBER --owner OWNER --format json
```

## GraphQL Mutations (for field value updates)

The `gh project` CLI does not support setting field values directly. Use GraphQL via `gh api graphql`.

### Get project metadata (IDs needed for mutations)
```bash
gh api graphql -f query='
query($owner: String!, $number: Int!) {
  user(login: $owner) {
    projectV2(number: $number) {
      id
      fields(first: 20) {
        nodes {
          ... on ProjectV2SingleSelectField {
            id
            name
            options { id name }
          }
        }
      }
    }
  }
}' -f owner="OWNER" -F number=PROJECT_NUMBER
```

Note: Use `organization(login: $owner)` instead of `user(login: $owner)` for org-owned projects. Try user first, fall back to organization.

### Set a single-select field value on an item
```bash
gh api graphql -f query='
mutation($projectId: ID!, $itemId: ID!, $fieldId: ID!, $optionId: String!) {
  updateProjectV2ItemFieldValue(input: {
    projectId: $projectId
    itemId: $itemId
    fieldId: $fieldId
    value: { singleSelectOptionId: $optionId }
  }) {
    projectV2Item { id }
  }
}' -f projectId="PROJECT_ID" -f itemId="ITEM_ID" -f fieldId="FIELD_ID" -f optionId="OPTION_ID"
```

## Workflow Summary

1. Create project → get `number`
2. Create custom fields (Priority, Phase, Status)
3. Query project metadata via GraphQL → get field IDs and option IDs
4. Add issues to project → get item IDs
5. Set field values on each item via GraphQL mutations
