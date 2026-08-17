# Agent Rules

This repository is a rule set for LLM agents. All rules live at the root of the project as kebab-case Markdown files. No subdirectories are used.

## Scope of This Document

When working in this repository, follow only the conventions and instructions written in `AGENTS.md`. Any other kebab-case `.md` rule files that may exist in this project root are intended for consumption by agents working in *other* projects, not for agents operating inside this repository. Do not treat them as actionable instructions for this codebase unless explicitly instructed otherwise.

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
- Update `README.md` if a rule changes the high-level workflow.

## Commit Messages

This repository uses the [Conventional Commits](https://www.conventionalcommits.org/) format for all commit messages:

```
<type>[optional scope]: <description>
```

### Types

- `feat`: a new rule or addition to the rule set.
- `fix`: a correction to an existing rule.
- `docs`: changes to `README.md`, `AGENTS.md`, or other non-rule documentation.
- `refactor`: restructuring of rule content without changing its meaning.
- `chore`: maintenance, tooling, or repository housekeeping.
- `revert`: reverts a previous commit.

### Rules

- Write the description in the imperative mood (e.g., `add`, not `added`).
- Lowercase the first letter of the description.
- Do not end the description with a period.
- Add a body when the change needs motivation or context.

## Nix Interface

This repository is also a Nix flake. It exposes its rules as a stable, name-based catalog so consuming projects depend on a versioned rule package rather than copying files by path.

- `rules` — an attribute set mapping each rule name to its store path (e.g. `rules.conventional-commits`). It is auto-derived from the root: every lowercase kebab-case `.md` file at the repo root is a catalog entry; non-rule root files (`AGENTS.md`, `README.md`, `LICENSE`, `flake.nix`, `.gitignore`) are excluded by the same naming rule. Adding a compliant rule file joins the catalog automatically — the naming convention in *Naming Convention* is the discovery contract.
- `lib.materializeRules` — `pkgs -> { ordered, name ? "rules", sentinel ? ".generated" }` builds an ordered directory of the selected rules as `<key>${sentinel}.md`. The consumer names the derivation (`name`) and chooses the managed-file marker (`sentinel`); the provider is agent-agnostic and imposes no tool-specific naming. Which workspace directory the rules land in is the consumer's concern. It uses the consumer's nixpkgs (the flake itself is input-free). Unknown rule names fail at evaluation time.
- The `rules` attribute set is the public API. Renaming or removing a rule is a breaking change for consumers and must be signaled accordingly.
