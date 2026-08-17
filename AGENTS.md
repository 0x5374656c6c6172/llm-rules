# Agent Rules

This repository is a rule set for LLM agents. All rules live at the root of the project as kebab-case Markdown files. No subdirectories are used.

## Scope of This Document

When working in this repository, follow the governance sections in this file (*Naming Convention*, *Rule Format*, *Applied Rules*, and so on) **and** the individual rule files listed in *Applied Rules*. Other kebab-case `.md` rule files that are not listed there exist for consumption by agents working in *other* projects — do not treat them as instructions for this codebase unless explicitly added to *Applied Rules*.

## Naming Convention

Every rule file must follow these conventions:

- **kebab-case** with a `.md` extension (e.g., `code-quality.md`, `error-handling.md`).
- **Lowercase only**; no spaces, PascalCase, or snake_case.
- **Concise and descriptive**; the name should indicate the rule’s scope.

Good examples:

- `always-follow.md`
- `code-quality.md`
- `documentation.md`
- `error-handling.md`
- `testing.md`

Bad examples:

- `CodeQuality.md` (PascalCase)
- `code_quality.md` (snake_case)
- `my rule.md` (contains space)

## Rule Format

Each rule file is a Markdown document in the project root and must follow this structure:

### 1. Title

A top-level heading (`#`) with a short, human-readable rule title.

### 2. Scope

A clear statement of when the rule applies, framed around the operation or artifact the rule governs (e.g., "All code changes", "Frontend TypeScript files", "every `git push` operation").

Keep the scope author-neutral. Describe what the rule applies to, never who performs it — do not reference "an agent" or any specific actor. Rules are portable and must stand on their own regardless of who carries them out. Conditions under which the rule does not apply, such as an existing project convention, belong in Exceptions rather than the Scope.

### 3. Statement

The rule itself, written as one or more concise, imperative statements.

### 4. Rationale

A brief explanation of why the rule exists and what problem it prevents.

### 5. Examples (optional)

Short do/don’t examples that illustrate the rule in practice.

### 6. Exceptions (optional)

Any situations where the rule can be relaxed or does not apply.

## How to Create a New Rule

1. Create a new file in the project root.
2. Name it in kebab-case with the `.md` extension.
3. Follow the rule format above.
4. Ensure the first heading matches the rule title.

## Updating Rules

- Edit the relevant `.md` file directly.
- Keep changes focused; one idea per rule file.
- To make a rule active in this repository, add a row to *Applied Rules*.
- To deactivate a rule, remove its row from *Applied Rules*.
- Update `README.md` if a rule changes the high-level workflow.

## Applied Rules

The rules below govern day-to-day work in this repository. Each rule lives in its own `.md` file at the project root — the full text is the authoritative source.

| Rule | File |
|------|------|
| Conventional Commits | [`conventional-commits.md`](./conventional-commits.md) |
| No Automatic Commits | [`no-automatic-commits.md`](./no-automatic-commits.md) |
| Open Remote After Push | [`open-remote-after-push.md`](./open-remote-after-push.md) |

