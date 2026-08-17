# Conventional Commits

## Scope

Applies to every Git commit message.

## Statement

Write all commit messages using the [Conventional Commits](https://www.conventionalcommits.org/) format:

```
<type>[optional scope]: <description>

[optional body]

[optional footer(s)]
```

Use one of the following types:

- `feat`: a new feature or addition.
- `fix`: a bug fix or correction.
- `docs`: documentation-only changes.
- `style`: formatting, whitespace, or styling changes that do not affect code meaning.
- `refactor`: code restructuring that neither fixes a bug nor adds a feature.
- `perf`: a change that improves performance.
- `test`: adding or correcting tests.
- `chore`: maintenance, tooling, or repository housekeeping.
- `ci`: changes to CI configuration or scripts.
- `build`: changes to the build system or external dependencies.
- `revert`: reverts a previous commit.

Follow these rules for every message:

- Write the description in the imperative mood (e.g., `add`, not `added`).
- Lowercase the first letter of the description.
- Do not end the description with a period.
- Keep the subject line (first line) under 72 characters.
- Use the optional body to explain what and why, wrapped at 72 characters.
- Signal a breaking change with a `!` after the type/scope and/or a `BREAKING CHANGE:` footer describing the impact.

## Rationale

A consistent, machine-readable commit history makes it easier for humans to scan changelogs and for tooling to automate versioning, release notes, and change classification. Conventional Commits encodes intent (feature vs. fix vs. chore) directly in the commit type, reducing ambiguity for both reviewers and downstream tooling.

## Examples

### Do

```
feat(auth): add OAuth login flow
```

```
fix(parser): handle empty input without crashing

Previously an empty input string caused a nil dereference. Guard
against it and return an empty result instead.
```

```
refactor!: rename UserRepo to UserRepository

BREAKING CHANGE: the public UserRepo type is renamed to
UserRepository. Update all references.
```

### Don't

```
updated stuff
```

```
Fixed a bug.
```

## Exceptions

- The repository already defines its own commit-message convention (e.g., a different set of types, a prefix-based scheme, or a contributing guide). Follow that convention instead.
- Commits produced by tooling that does not support custom messages (e.g., some automated dependency bots), where overriding the message is not feasible.
