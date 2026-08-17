# Run Tests Before Commit

## Scope

Applies to every commit in a repository that has a defined test suite or test command.

## Statement

Run the project's test suite before committing. If any test fails, fix the failure or document why the failure is unrelated to the change before proceeding with the commit.

Identify the correct test command by checking the project's configuration (e.g. `package.json` scripts, `Makefile` targets, `pyproject.toml`, or a `README`). If no test suite or test command exists, document the absence and skip this step.

## Rationale

Committing code that breaks existing tests introduces regressions that can cascade through CI and block other contributors. Running tests locally catches failures early, when they are cheapest to fix, and ensures that a change does not silently break existing behavior.

## Examples

### Do

```sh
# Node.js project — run the test script from package.json
npm test

# Python project — run pytest
pytest

# Go project
go test ./...
```

### Don't

```sh
# Committing without running tests, even though a test suite exists
git add src/
git commit -m "fix: update parser"
```

## Exceptions

- The repository has no test suite or test command configured, in which case this rule is not applicable.
- The change is purely cosmetic (e.g., fixing whitespace, updating comments) and cannot affect runtime behavior — document the rationale in the commit message.
- The test suite is prohibitively slow and a lighter-weight alternative (e.g., a targeted subset of tests) is the agreed-upon practice for the project.
