# Plan Release Feature

Add a `/plan-release` command to github-planner that automates versioning,
changelog generation, and GitHub Release publishing for MCS techpacks.

## Phase 1: Core Infrastructure

### Add version field to techpack.yaml

- Add `version` field to `techpack.yaml` (semver format, e.g. `"1.0.0"`)
- Update `validate_techpack.py` to validate version is present and semver-compliant
- Priority: critical
- Labels: enhancement, infrastructure

### Release notes template

- Create `src/skills/release-builder/references/release-notes.md`
- Sections: What's New, Bug Fixes, Breaking Changes, Installation, Full Changelog link
- Template uses placeholder tokens replaced at release time
- Priority: critical
- Labels: enhancement

### Release builder skill

- Create `src/skills/release-builder/SKILL.md`
- Define changelog generation rules: group merged PRs by label (enhancement → What's New, bug → Bug Fixes)
- Define version bump logic: patch (bug fixes only), minor (new features), major (breaking changes)
- Define breaking change detection: PRs/issues with `breaking-change` label
- Define installation snippet for release body (`mcs pack add anettodev/github-planner@vX.Y.Z`)
- Priority: critical
- Labels: enhancement

## Phase 2: Agent and Command

### Release manager agent

- Create `src/agents/release-manager.md`
- Responsibilities:
  - Read current version from `techpack.yaml`
  - Fetch merged PRs since last git tag via `gh pr list`
  - Fetch closed issues since last tag via `gh issue list`
  - Group by label into changelog sections
  - Bump version in `techpack.yaml`
  - Commit version bump with message `chore: bump version to vX.Y.Z`
  - Create git tag `vX.Y.Z`
  - Push tag
  - Run `gh release create` with generated notes and `techpack.yaml` as asset
- Priority: critical
- Labels: enhancement
- Depends on: release builder skill

### plan-release command

- Create `src/commands/plan-release.md`
- Flags:
  - `--version vX.Y.Z` — explicit version override
  - `--dry-run` — preview release notes without publishing
  - `--milestone NAME` — scope changelog to a specific milestone
  - `--draft` — create as draft release (do not publish)
- Flow:
  1. Detect current version from `techpack.yaml`
  2. Suggest next version based on merged PR labels
  3. Generate changelog from merged PRs and closed issues since last tag
  4. Show full release preview (version, notes, asset list)
  5. Wait for user confirmation before any write operation
  6. Bump version, commit, tag, push, create release
- Priority: critical
- Labels: enhancement
- Depends on: release manager agent, release builder skill

## Phase 3: Automation and Validation

### Wire release into techpack.yaml

- Add release-builder skill component to `techpack.yaml`
- Add release-manager agent component to `techpack.yaml`
- Add plan-release command component to `techpack.yaml`
- Add `version` field at top level with initial value `"1.0.0"`
- Priority: high
- Labels: infrastructure

### Release CI workflow

- Create `.github/workflows/release.yml`
- Trigger: on `push` of tags matching `v*.*.*`
- Steps:
  - Validate `techpack.yaml` using `validate_techpack.py`
  - Verify tag matches `version` field in `techpack.yaml`
  - Upload `techpack.yaml` as release asset if not already present
- Priority: high
- Labels: infrastructure, ci

### Update validate_techpack.py for semver

- Add semver validation to `validate_techpack.py` using regex
- Pattern: `^\d+\.\d+\.\d+$`
- Exit with error if `version` field is missing or malformed
- Priority: high
- Labels: enhancement

### Update README with release command docs

- Add `/plan-release` to the Quick Reference table
- Add full command section with flags and example output
- Priority: medium
- Labels: documentation
