#!/bin/bash
# gh-auth-check.sh — SessionStart hook
# Verifies GitHub CLI authentication and reports repo context.
# Outputs JSON format compatible with Claude Code hooks.

set -euo pipefail
trap 'exit 0' ERR

# Check prerequisites
command -v gh >/dev/null 2>&1 || exit 0
command -v jq >/dev/null 2>&1 || exit 0

main() {
    local context=""

    # === GitHub Auth ===
    if gh auth status &>/dev/null; then
        local account
        account=$(gh auth status 2>&1 | grep "Logged in" | awk '{print $NF}' | tr -d '()')
        context+="GitHub: authenticated as ${account}"
    else
        context+="GitHub: NOT authenticated — run: gh auth login"
        jq -n --arg ctx "$context" '{
            hookSpecificOutput: {
                hookEventName: "SessionStart",
                additionalContext: $ctx
            }
        }'
        return
    fi

    # === Repository Context ===
    if repo=$(gh repo view --json nameWithOwner -q .nameWithOwner 2>/dev/null); then
        context+="\nRepo: ${repo}"

        # Open issues count
        if issue_count=$(gh issue list --state open --limit 1 --json number 2>/dev/null | jq 'length'); then
            context+="\nOpen issues: ${issue_count}+"
        fi

        # Labels available
        if label_count=$(gh label list --limit 1 --json name 2>/dev/null | jq 'length'); then
            [ "$label_count" -eq 0 ] && context+="\nLabels: none (will be auto-created)"
        fi

        # Milestones
        if ms_count=$(gh api repos/${repo}/milestones --method GET -f state=open 2>/dev/null | jq 'length'); then
            context+="\nOpen milestones: ${ms_count}"
        fi

        # Projects
        local owner="${repo%%/*}"
        if proj_count=$(gh project list --owner "${owner}" --format json 2>/dev/null | jq '.projects | length'); then
            context+="\nOpen projects: ${proj_count}"
        fi
    else
        context+="\nRepo: not detected (not in a git repo or no remote)"
    fi

    # Output JSON
    jq -n --arg ctx "$context" '{
        hookSpecificOutput: {
            hookEventName: "SessionStart",
            additionalContext: $ctx
        }
    }'
}

main
