# Stay Within Scope

## Scope

Applies to every task or instruction executed in a project.

## Statement

Execute exactly what was requested. Do not expand the scope of a task to include additional steps that were not explicitly asked for, even when they appear to be a natural extension. When a task admits multiple interpretations or could reasonably include steps beyond what was stated, ask for clarification before acting.

## Rationale

Agents tend to anticipate "what comes next" and bundle it into the current task. While this may seem helpful, it can change state the user did not intend to touch, introduce unexpected side effects, and erode user control over the workflow. Keeping actions strictly within the stated scope ensures predictability and preserves trust.

## Examples

### Do

```text
# User: "Create the rule file for branch naming."
# Action: create branch-naming.md — nothing more.
```

### Don't

```text
# User: "Create the rule file for branch naming."
# Action: create branch-naming.md AND add it to AGENTS.md AND update README.md.
```

## Exceptions

- The user has previously given explicit standing instructions to bundle a specific follow-up step (e.g., "always register new rules in AGENTS.md").
