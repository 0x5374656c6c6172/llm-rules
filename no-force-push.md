# No Force Push

## Scope

Applies to every `git push` operation targeting a shared branch (e.g. `main`, `develop`, `release/*`, or any branch used by multiple contributors).

## Statement

Do not use `git push --force` or `git push --force-with-lease` on shared branches without explicit user approval. When a force push is needed, explain why it is necessary and confirm the scope of the rewrite before proceeding.

If a force push is declined or approval cannot be obtained, propose a safer alternative such as reverting the problematic commits or creating a new commit that addresses the issue.

## Rationale

Force-pushing rewrites branch history, which can break other contributors' local copies, CI pipelines, and open pull requests. It also makes it harder to audit what changed and when. Restricting force pushes to shared branches prevents accidental history rewrites and keeps collaboration smooth.

## Examples

### Do

```sh
# Instead of force-pushing to fix a typo in the last commit:
git revert HEAD
git push origin main
```

```sh
# If a force push is truly needed (e.g., removing a committed secret):
# Explain the situation, get approval, then proceed.
git push --force-with-lease origin feature/my-branch
```

### Don't

```sh
# Force-pushing to main to rewrite the last three commits:
git rebase -i HEAD~3
git push --force origin main
```

## Exceptions

- The target branch is a personal or feature branch not used by others.
- The repository's workflow explicitly requires force pushes (e.g., a rebase-only workflow where contributors own their feature branches).
- The environment is a local-only or throwaway repository with no collaborators.
