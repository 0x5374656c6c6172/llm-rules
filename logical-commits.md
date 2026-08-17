# Logical Commits

## Scope

Applies to every Git commit.

## Statement

Each commit should represent a single logical unit of work — one feature, one bug fix, one refactor, or one configuration update. Group related changes that serve a shared purpose into one commit. Split unrelated changes into separate commits. Every commit should leave the codebase in a working, coherent state.

Do not bundle unrelated modifications into the same commit, and do not split a single logical change across multiple commits.

## Rationale

Commits are the unit of review, revert, and history. A commit that mixes unrelated changes is harder to review, harder to revert cleanly, and obscures intent. A change fragmented across multiple commits complicates `git bisect` and makes the history harder to follow. Keeping each commit focused on one logical unit ensures the history is readable, reviewable, and useful for debugging.

## Examples

### Do

```text
# Commit 1: add the UserSerializer class
# Commit 2: add tests for UserSerializer
# Commit 3: update the API endpoint to use UserSerializer
```

### Don't

```text
# One commit that simultaneously:
# - adds UserSerializer
# - renames a utility function in an unrelated module
# - fixes a typo in a README
```

## Exceptions

- A project or team convention requires squashing all commits into one before merging (the individual commits should still be logically batched during development).
- A change is genuinely atomic — for example, renaming a function and updating all its call sites is a single logical unit even though multiple files are touched.