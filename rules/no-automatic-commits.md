# No Automatic Commits

## Scope

Applies to all Git operations where a commit could be created or staged, including but not limited to file edits, merges, rebases, and any workflow that stages changes.

## Statement

Do not create Git commits unless the user has explicitly requested a commit. After making changes, stage the files but wait for the user to ask before running `git commit`. When the user does request a commit, confirm the scope of what will be committed before proceeding.

## Rationale

Automatic commits reduce user control over the repository history. They can commit incomplete work, bundle unrelated changes, or introduce unwanted entries in the log. By requiring explicit user approval, the workflow keeps the commit history intentional and clean, and avoids situations where the user must undo or amend a commit that was made prematurely.

## Examples

### Do

```sh
# After making changes, stage but do not commit.
git add src/auth.ts src/auth.test.ts

# Wait for the user to say "commit these changes" or similar.
# Then confirm scope:
# "I've staged src/auth.ts and src/auth.test.ts. Would you like me to commit them?"
```

### Don't

```sh
# After making changes, automatically commit without asking.
git add .
git commit -m "fix: update auth module"
```

## Exceptions

- The user has previously instructed the workflow to commit after each logical change (e.g., "always commit when you finish a task").
- The changes are part of an automated pipeline (e.g., CI-generated version bumps) where committing is a defined step in the process.
