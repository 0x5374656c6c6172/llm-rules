# Keep README Current

## Scope

Applies to any change that modifies setup instructions, usage examples, feature descriptions, API documentation, or project structure referenced in the repository's `README.md` (or equivalent top-level documentation).

## Statement

When a change affects information documented in the README, update the README in the same commit or pull request. Ensure that setup steps, usage examples, command references, and dependency lists remain accurate after the change.

Do not leave the README in a state where a new contributor following its instructions would encounter errors or outdated guidance.

## Rationale

The README is the first document new contributors and users encounter. Stale or incorrect instructions erode trust, create confusion, and waste time during onboarding. Keeping documentation in sync with code changes ensures that the README remains a reliable source of truth.

## Examples

### Do

```text
# A dependency was added to support a new feature.
# The README's "Installation" section now includes it in the setup steps.
# Both the code change and the README update are in the same commit.
```

### Don't

```text
# The project now requires Node 20, but the README still says Node 18.
# A new contributor follows the README and runs into compatibility errors.
```

## Exceptions

- The README has not been updated yet, but a separate pull request is already in progress to update it.
- The change is internal and does not affect anything described in the README (e.g., a private utility function refactor).
- The project uses generated documentation (e.g., JSDoc, Sphinx) and the README does not contain the relevant information — the generated docs are updated separately.
