# Branch Naming

## Scope

Applies to every branch created in a Git repository.

## Statement

Name branches using the pattern `<type>/<short-description>` where `<type>` is one of the following prefixes and `<short-description>` is a brief, kebab-case summary of the branch's purpose:

- `feat/` — a new feature or enhancement.
- `fix/` — a bug fix.
- `docs/` — documentation-only changes.
- `refactor/` — code restructuring with no feature or fix.
- `test/` — test additions or corrections.
- `chore/` — maintenance, tooling, or repository housekeeping.
- `ci/` — CI configuration changes.
- `perf/` — performance improvements.

Keep the description under 50 characters total (excluding the type prefix). Use only lowercase letters, digits, and hyphens — no uppercase, underscores, slashes beyond the type prefix, or issue numbers in the branch name.

When a branch addresses an issue, reference the issue in the commit message or pull request instead of the branch name.

## Rationale

A consistent branch naming convention makes it easy to scan a list of branches and understand their purpose at a glance. It also enables automation (e.g., auto-labeling pull requests, generating release notes) that relies on parsing branch names. Without a convention, branch names become inconsistent and harder to manage as the team or project grows.

## Examples

### Do

```text
feat/oauth-login
fix/null-pointer-on-empty-input
docs/api-reference
chore/upgrade-eslint
```

### Don't

```text
JohnsFeature
login_fix_2
try-stuff
issue-42
```

## Exceptions

- The repository already defines its own branch naming convention (e.g., in a contributing guide or CI configuration). Follow that convention instead.
- Short-lived personal branches that are never pushed to a shared remote are exempt.
